#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(RColorBrewer)
library(KernSmooth)

shinyUI(fluidPage(  theme = "flatly.css",
                    wellPanel(style = "padding: 2px; border-bottom: 3px solid #CCC;", 
                              fluidRow(
                                column(3, offset = 1, h3("Gibbs Sampler Demo")),
                                column(5, 
                                       br(),
                                       helpText("Click on a button to move that many steps"),
                                       actionButton("go", label = "1"),
                                       actionButton("go_10", label = "10"),
                                       actionButton("go_50", label = "50"),
                                       actionButton("go_100", label = "100"),
                                       br(),br()
                                ),
                                column(3, 
                                       br(),
                                       helpText("Steps so far"),
                                       h4(textOutput("steps_so_far"))
                                )
                              )
                    ),
                    
                    h5(withMathJax(
                      "$$ \\begin{bmatrix} X \\\\ Y \\end{bmatrix} 
    \\sim 
    \\mathcal{N} \\left( 
    \\mu = 
      \\begin{bmatrix} 1 \\\\ 2 \\end{bmatrix},
    \\Sigma = 
      \\begin{bmatrix} 1 & 1/2 \\\\ 1/2 & 1 \\end{bmatrix}
    \\right) $$"
                    )),
                    
                    br(),br(),
                    sidebarPanel(style = "padding: 2px; background-color: #fff; border-right: 3px solid #CCC; border-top: 0px; border-left: 0px; border-bottom: 0px;",
                                 width = 4, 
                                 plotOutput("marginal_and_joint_plots")),
                    mainPanel(width = 8,
                              plotOutput("main_plot")
                    )
))