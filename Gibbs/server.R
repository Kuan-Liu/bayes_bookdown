#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(RColorBrewer)
library(KernSmooth)

gibbs_sampler <- function(N, init1, init2) {
  # for multivariate normal distribution with mean vector c(1,2) and covariance
  # matrix = matrix(c(1, 1/2, 1/2, 1), 2, 2)
  
  if (missing(init1)) init1 <- runif(1, -4, 4) 
  if (missing(init2)) init2 <- runif(1, -2, 6) 
  
  draws <- mat.or.vec(nr = N, nc = 2)
  x_1 <- init1 ; x_2 <- init2  
  draws[1, ] <- c(x_1, x_2)
  clrs <- "black"
  for (j in 2:N) {
    x_1 <- rnorm(1, (1/2)*x_2, sqrt(3/4) )    
    x_2 <- rnorm(1, (3/2) + (1/2)*x_1, sqrt(3/4))    
    draws[j, ] <- c(x_1, x_2)
  }
  
  draws
}


shinyServer(function(input, output) {
  
  nDraws <- 1e4
  draws <- gibbs_sampler(N = nDraws)
  xx <- draws[, 1]
  yy <- draws[, 2]
  
  nSteps <- reactive({
    step    <- input$go + 1
    step10  <- input$go_10
    step50  <- input$go_50
    step100 <- input$go_100
    
    steps <- step + 10*step10 + 50*step50 + 100*step100
    
    validate(need(
      steps <= nDraws, message = "You've reached the maximum number of draws"
    ))
    
    steps
  })
  
  output$steps_so_far <- renderText({
    nSteps() - 1
  })
  
  
  output$main_plot <- renderPlot({
    
    k <- nSteps()
    
    plot(xx[1],yy[1],xlim=c(-4,5),ylim=c(-2,6), 
         type = "n",
         bty = "l", xlab = "X", ylab = "Y", 
         main = "", axes = FALSE)
    if (k > 1) {
      lapply(2:k, function(j) {
        segments(xx[j-1],yy[j-1],xx[j],yy[j-1], 
                 col = ifelse(j == k, "maroon", "lightgray"),
                 lwd = ifelse(j == k, 3, 1),
                 lty = 1)
        segments(xx[j],yy[j-1],xx[j],yy[j], 
                 col = ifelse(j == k, "skyblue", "lightgray"),
                 lwd = ifelse(j == k, 3, 1),
                 lty = 1)
        points(xx[j],yy[j],
               col = ifelse(j == k, "black", "darkgray"),
               cex = ifelse(j == k, 1.5, .75),
               pch=19)
      })
    }
    points(xx[1], yy[1], col = "purple", cex = 1)
    axis(1, lwd = 6, lwd.ticks = 0, padj = -1)
    axis(2, lwd = 6, lwd.ticks = 0, padj = 1)
  })
  
  marginal_Y <- reactive({
    k <- nSteps()
    validate(need(
      k > 1, message = ""
    ))
    Y <- yy[1:k]
    
    hist(Y,
         xlab = "", ylab = "",
         main = "Marginal distribution: Y",
         border = "white", col = "skyblue",
         axes = FALSE, freq = FALSE)
  })
  
  marginal_X <- reactive({
    k <- nSteps()
    validate(need(
      k > 1, message = ""
    ))
    
    X <- xx[1:k]
    hist(X, 
         xlab = "", ylab = "",
         main = "Marginal distribution: X",
         border = "white", col = "maroon",
         axes = FALSE, freq = FALSE)
  })
  
  joint <- reactive({
    k <- nSteps()
    validate(need(
      k > 1, message = ""
    ))
    
    X <- xx[1:k]
    Y <- yy[1:k]
    Z <- bkde2D(cbind(X, Y), bandwidth = c(bw.nrd0(X), bw.nrd0(Y)))
    
    contour(Z$x1, Z$x2, Z$fhat, main = "Joint Distribution", bty = "l", axes = FALSE)
  })
  
  output$marginal_and_joint_plots <- renderPlot({
    par(mfcol = c(3,1), cex.main = 1.5)
    if (nSteps() > 1) {
      marginal_Y()
      marginal_X()
      joint()
    } else {
      plot(0, type = "n", axes = FALSE, xlab = "", ylab = "", main = "Marginal distribution Y")
      plot(0, type = "n", axes = FALSE, xlab = "", ylab = "", main = "Marginal distribution X")
      plot(0, type = "n", axes = FALSE, xlab = "", ylab = "", main = "Joint Distribution")
    }
  })
  
})