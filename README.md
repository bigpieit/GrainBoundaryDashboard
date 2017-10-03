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
<b>STRUCTURESnew.txt</b> is the properties file of grain boundary structures. Please upload as <b>'source data'</b> at the <b>'Decision Graph'</b> section<br>
>> head -5 STRUCTURESnew.txt<br>
Structures   Fraction     E[J/m2]      V[A]         Fx           Fy           Fz           Q4           Q6           Q8           Q12          Method<br>
lammps_0001  0.4800       0.93680      0.16544      -2.17289     0.09197      0.00385      -0.08194     -0.14352     -0.02246     -0.16911     byEQ<br>
lammps_0002  0.4800       0.94716      0.18797      -1.81158     0.45094      0.00306      -0.08864     -0.14978     -0.01830     -0.17313     byEQ<br>
lammps_0003  0.4800       0.95167      0.17775      -1.91515     0.09950      0.00046      -0.08491     -0.14605     -0.01882     -0.17080     byEQ<br>
lammps_0004  0.4800       0.95168      0.19061      -1.80610     0.51287      0.00361      -0.09380     -0.15482     -0.01712     -0.17811     byEQ<br>
</p>
<p>
<b>STRUCnote.txt</b> is the categorization of grain boundary structures through laboring eye detection. Please upload as <b>'Eye Detection Data'</b> at <b>'Eye Detection Clustering'</b> section<br>
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
