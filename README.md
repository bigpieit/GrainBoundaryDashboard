<h1>
GrainBoundaryDashBoard Manual
</h1>

<h2> 
Overview
</h2>
<p>
'GrainBoudaryDashboard' is an interactive clustering analysis and visualization dashboard of grain boundary data. The clustering is done by fast search and find of density peaks. Please refer to the References for our implementation and application[1] and the algorithm detail[2].
</p>

<h2> 
Packages Required
</h2>
<p>
This is an R Shiny dashboard pacage. Libraries used are:
<ul>
  <li> <a href="https://cran.r-project.org/web/packages/shiny/index.html"> shiny </a> </li>
  <li> <a href="https://rstudio.github.io/shinydashboard/"> shinydashboard </a> </li>
  <li> <a href="https://cran.r-project.org/web/packages/densityClust/index.html"> densityClust </a> </li>
  <li> <a href="http://ggplot2.org/"> ggplot2 </a> </li>
</ul>
</p>

<h2>
Data Format
</h2>
<p>
>> head -5 STRUCnote.txt<br>
NK: 1 SK: 2 FK: 3 Disordered: 4 Not-Applicable: 5<br>
Structures   GB-Type<br>
lammps_0001    SK<br>
lammps_0002    SK<br>
lammps_0003    SK<br>
</p>

<h2> 
Run From Command Line
</h2>

<h2>
Reference
</h2>
<p>
<ol>
  <li> Qiang Zhu, Amit Samanta, Bingxi Li, Robert E Rudd, Timofey Frolov, Predicting phase behavior of grain boundaries with evolutionary search and machine learning, <a href="https://arxiv.org/abs/1707.09699">arXiv:1707.09699</a> [cond-mat.mtrl-sci] </li>
  <li> Alex Rodriguez and Alessandro Laio. Clustering by fast search and find of density peaks. Science, 344(6191):1492–1496, 2014. </li>
</ol>
</p>
