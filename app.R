#!/usr/bin/env Rscript
library(shiny)
library(shinydashboard)
library(densityClust)
library(ggplot2)
rm(list = ls())

#########################################################################################
#############################           ui          #####################################
#########################################################################################
sideBar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Decision Graph", tabName = "decisiongraph", icon = icon("dashboard")),
    menuItem("Algorithmic Clustering", icon = icon("th"), tabName = "algoclustering"), 
    #badgeLabel = "new", badgeColor = "green")
    menuItem("Eye Detection Clustering", icon = icon("th"), tabName = "eyeclustering")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "decisiongraph",
      fluidRow(
        box(title = "Decision Graph",
            solidHeader = TRUE,
            status = "warning", 
            plotOutput(outputId = "decision_graph", height = 300)
        ),
        box(
          title = "Decision Graph Panel",
          solidHeader = TRUE,
          status = "warning",
          sliderInput("dc", "Folds of Default Distance Criterion, dc", min = 1, max = 5, value = 1.56, step = 0.01),
          sliderInput("delta", label = div(HTML("Distance to Nearest More Densed Neighbor &delta;:")), min = 1, max = 5, value = 2, step = 0.01),
          sliderInput("rho", label = div(HTML("Local Density &rho;:")) , min = 0, max = 50, value = 20, step = 5)
        ),
        box(
          title = "Source Data",
          solidHeader = TRUE,
          status = "success",
          width = 12,
          fileInput("file1", "Choose CSV File",
                    accept = c(
                      "text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")
          ),
          tags$hr(),
          checkboxInput("header", "Header", TRUE),
          tableOutput("contents")
        ),
        box(
          title = "Reference",
          solidHeader = TRUE,
          status = "success",
          width = 12,
          "Alex Rodriguez and Alessandro Laio. Clustering by fast search and find of density peaks. Science, 344(6191):1492–1496, 2014."
        )
      )  
    ),
    
    tabItem(tabName = "algoclustering",
      fluidRow(
        box(title = "Selected Feature Map",
            solidHeader = TRUE,
            status = "warning",
            width = 12,
            checkboxGroupInput(inputId = "inCheckboxGroup1", label = "Input checkbox 1", inline = TRUE),
            h5(textOutput(outputId = "value"))
        ),
        box(title = "Feature Maps",
            solidHeader = TRUE,
            status = "warning",
            width = 12,
            uiOutput("plots")
        )
      ) 
    ),
    
    tabItem(tabName = "eyeclustering",
      fluidRow (
        box(
          title = "Eye Detection Data",
          solidHeader = TRUE,
          status = "success",
          width = 12,
          fileInput("file2", "Choose CSV File",
                    accept = c(
                      "text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")
          ),
          tags$hr(),
          checkboxInput("header2", "Header", TRUE),
          tableOutput("contents2")
        ),
        box(
          title = "Eye Detection Clustering Results",
          solidHeader = TRUE,
          status = "success",
          width = 12,
          uiOutput("plots1")
        )
      )
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Clustering Dashboard"),
  sidebar = sideBar,
  body = body
)

#########################################################################################
#############################         server        #####################################
#########################################################################################
server <- function(input, output, session) {
  ##############################################################
  ####################### Decision Graph #######################
  ##############################################################
  output$decision_graph <- renderPlot({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    plot(distanceData()$STRUC_all_scal_CLUST, main = NULL)
  })
  
  output$contents <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    read.csv(inFile$datapath, header = input$header, nrows = 5)
  })
  
  ####################### source data #######################
  distanceData <- reactive(
    if (!is.null(input$file1)){
      STRUCTURES = read.table(input$file1$datapath, header = input$header)
      STRUCTURES = STRUCTURES[STRUCTURES$Method!="byDefault",]
      STRUC_all = STRUCTURES[,c(3:6,8:11)]
      STRUC_all_scal = scale(STRUC_all,center = TRUE, scale = TRUE)
      STRUC_all_scal_DIST = dist(STRUC_all_scal, method = "euclidean")
      estDc = estimateDc(STRUC_all_scal_DIST)
      STRUC_all_scal_CLUST = densityClust(STRUC_all_scal_DIST, dc = estDc*input$dc)
      STRUC_all_scal_CLUST = findClusters(STRUC_all_scal_CLUST, rho = input$rho, delta = input$delta)
      STRUCTURES["Clusters"] = STRUC_all_scal_CLUST$clusters
      numClust = length(unique(STRUCTURES$Clusters))
      return (list("STRUCTURES" = STRUCTURES, "STRUC_all_scal_CLUST" = STRUC_all_scal_CLUST,
                   "estDc" = estDc, "numClust" = numClust))
    }
  )
  
  ###############################################################
  ####################### Algo Clustering #######################
  ###############################################################
  ############### Selected Features ###############
  observe({
    x <- colnames(distanceData()$STRUCTURES)[c(2:11)]
    # Can use character(0) to remove all choices
    if (is.null(x))
      x <- character(0)
    # Can also set the label and select items
    updateCheckboxGroupInput(session, "inCheckboxGroup1",
                             label = "Check Features to Use: ",
                             choices = x,
                             selected = x,
                             inline = TRUE
    )
  })
  output$value <- renderText({
    s <- paste(input$inCheckboxGroup1, collapse = " ")
    paste(distanceData()$numClust, "clusters on feature maps of", s, sep = " ")
  })
  
  plotInput <- reactive({
    if (!is.null(input$inCheckboxGroup1)) {
      n_plot <- length(input$inCheckboxGroup1)
      return (list("n_plot"=n_plot))
    }
  })
  
  ################# Feature Maps ###################
  output$plots <- renderUI({
    if (is.null(plotInput()))
      return(NULL)
    N <- plotInput()$n_plot
    plot_output_list <- lapply(1:min(10,N*(N-1)/2), function(i) {
      plotname <- paste("plot", i, sep="")
      column(4, plotOutput(plotname))
    })   
    do.call(tagList, plot_output_list)
  })
  
  ########## Produce "Selected Feature Maps" panel #########
  observe({
    if (!is.null(plotInput())) {
      N <- plotInput()$n_plot
      
      STRUCTURES = distanceData()$STRUCTURES
      properties <- input$inCheckboxGroup1
      var_list = combn(properties, 2, simplify = FALSE) 
      
      lapply(1:min(10, N*(N-1)/2), function(i){
        output[[paste("plot", i, sep="")]] <- renderPlot({
          if (var_list[[i]][1]!="Fraction") xlabname = paste("Excess", var_list[[i]][1], sep = " ")
          else xlabname = paste(var_list[[i]][1], sep = " ")
          
          if (var_list[[i]][2]!="Fraction") ylabname = paste("Excess", var_list[[i]][2], sep = " ")
          else ylabname = paste(var_list[[i]][2], sep = " ")
          
          ratio.display <- 8/8
          ratio.values <- (max(STRUCTURES[var_list[[i]][1]])-min(STRUCTURES[var_list[[i]][1]]))/
            (max(STRUCTURES[var_list[[i]][2]])-min(STRUCTURES[var_list[[i]][2]]))
          
          ggplot(STRUCTURES, aes_string(x=var_list[[i]][1], y=var_list[[i]][2])) + labs(x = xlabname, y = ylabname) + 
            theme(text = element_text(size=20)) + geom_point(size=2,aes(x= STRUCTURES[var_list[[i]][1]], y = STRUCTURES[var_list[[i]][2]],colour=factor(Clusters))) + 
            scale_color_discrete(name="Clusters") + coord_fixed(ratio.values / ratio.display)
        })
      })
    }
  })
  
  ###############################################################
  ####################### Eye Clustering #######################
  ###############################################################  
  output$contents2 <- renderTable({
    inFile2 <- input$file2
    if (is.null(inFile2))
      return(NULL)
    read.csv(inFile2$datapath, header = input$header2, skip = 1, nrows = 5)
  })

  eyeData <- reactive(
    if (!is.null(input$file2)){
      STRUCnote = read.table(input$file2$datapath, header = input$header2, skip = 1)
      STRUCTURES = distanceData()$STRUCTURES
      final = merge(STRUCTURES, STRUCnote, by = "Structures")
      return (list("final_data" = final))
    }
  )
  
  output$plots1 <- renderUI({
    if (is.null(plotInput()) || is.null(eyeData()))
      return(NULL)
    N <- plotInput()$n_plot
    plot_output_list_1 <- lapply(1:min(10,N*(N-1)/2), function(i) {
      plotname <- paste("plot1_", i, sep="")
      column(4, plotOutput(plotname))
    })   
    do.call(tagList, plot_output_list_1)
  })

  observe({
    if (!is.null(plotInput()) && !is.null(eyeData())) {
      N <- plotInput()$n_plot
      
      STRUCTURES = eyeData()$final_data
      properties <- input$inCheckboxGroup1
      var_list = combn(properties, 2, simplify = FALSE) 
      
      lapply(1:min(10, N*(N-1)/2), function(i){
        output[[paste("plot1_", i, sep="")]] <- renderPlot({
          if (var_list[[i]][1]!="Fraction") xlabname = paste("Excess", var_list[[i]][1], sep = " ")
          else xlabname = paste(var_list[[i]][1], sep = " ")
          
          if (var_list[[i]][2]!="Fraction") ylabname = paste("Excess", var_list[[i]][2], sep = " ")
          else ylabname = paste(var_list[[i]][2], sep = " ")
          
          ratio.display <- 8/8
          ratio.values <- (max(STRUCTURES[var_list[[i]][1]])-min(STRUCTURES[var_list[[i]][1]]))/
            (max(STRUCTURES[var_list[[i]][2]])-min(STRUCTURES[var_list[[i]][2]]))
          
          ggplot(STRUCTURES, aes_string(x=var_list[[i]][1], y=var_list[[i]][2])) + labs(x = xlabname, y = ylabname) + 
            theme(text = element_text(size=20)) + geom_point(size=2,aes(x= STRUCTURES[var_list[[i]][1]], y = STRUCTURES[var_list[[i]][2]],colour=factor(GB.Type))) + 
            scale_color_discrete(name="GB.Type") + coord_fixed(ratio.values / ratio.display)
        })
      })
    }
  })
}

#########################################################################################
#############################        running        #####################################
#########################################################################################
shinyApp(ui, server)
