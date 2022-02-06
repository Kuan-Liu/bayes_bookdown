#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# par(mar = c(4, 4, 2, 0) + 0.1)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Metropolis Algorithm"),
  wellPanel(
    p("This app illustrates the process of sampling from the posterior 
      distribution using the Metropolis algorithm."), 
    h2("Instruction:"), 
    p("0. Choose a desired standard deviation for the proposal distribution."), 
    p("1. Click the 'Initialize' button to start a new sampling."), 
    p("2a. Click 'Propose a value' to obtain a new value from the proposal distribution."), 
    p("2b. Click 'Accept/Reject' to probabilitistically decide whether to accept or reject the proposed value."), 
    p("3. To simulate more samples, click the 'Draw 100 samples' or the 'Draw 100 samples' button.")
  ), 
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("sd", "Proposal SD", 0.01, 1, value = 0.1),
      actionButton("init", "Initialize"), 
      actionButton("prop", "Propose a theta value"), 
      actionButton("acc", "Accept/Reject"), 
      actionButton("run100", "Draw 100 samples"), 
      actionButton("run1000", "Draw 1000 samples"), 
      textOutput("nsample"), 
      textOutput("acc_rate")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", 
                 plotOutput("TargetPlot"), 
                 plotOutput("SamplePlot")), 
        tabPanel("Trace", 
                 plotOutput("TracePlot"), 
                 plotOutput("AcfPlot"))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  dens_kern <- function(x) {
    dnorm(x, 0.5, 1 / sqrt(2)) * dbeta(x, 13, 9)
  }
  x0 <- seq(-0.3, 0.3, length.out = 101)
  v <- reactiveValues(th0 = NULL, proposed = NULL, sam = NULL, 
                      accept = 0, rug = FALSE)
  observeEvent(input$init, {
    v$th0 <- runif(1)
    v$proposed <- NULL
    v$sam <- NULL
    v$accept <- 0
    v$rug <- FALSE
  })
  observeEvent(input$prop, {
    if (!is.null(v$th0)) {
      v$proposed <- rnorm(1, sd = input$sd) + v$th0
      v$rug <- FALSE
    }
  })
  observeEvent(input$acc, {
    if (!is.null(v$proposed)) {
      u <- runif(1)
      if (u < dens_kern(v$proposed) / dens_kern(v$th0)) {
        v$th0 <- v$proposed
        v$accept <- v$accept + 1
      }
      v$sam <- c(v$sam, v$th0)
      v$proposed <- NULL
    }
  })
  observeEvent(input$run100, {
    if (!is.null(v$th0)) {
      sam_mcmc <- rep(NA, length = 101)
      sam_mcmc[1] <- v$th0
      for (i in 1:100) {
        proposed <- sam_mcmc[i] + rnorm(1, sd = input$sd)
        if (proposed > 1 | proposed < 0) {
          sam_mcmc[i + 1] <- sam_mcmc[i]
          next
        }
        if (runif(1) < dens_kern(proposed) / dens_kern(sam_mcmc[i])) {
          sam_mcmc[i + 1] <- proposed
          v$accept <- v$accept + 1
        } else {
          sam_mcmc[i + 1] <- sam_mcmc[i]
        }
      }
      v$th0 <- sam_mcmc[101]
      v$sam <- c(v$sam, sam_mcmc[2:101])
      v$proposed <- NULL
      v$rug <- TRUE
    }
  })
  observeEvent(input$run1000, {
    if (!is.null(v$th0)) {
      sam_mcmc <- rep(NA, length = 1001)
      sam_mcmc[1] <- v$th0
      for (i in 1:1000) {
        proposed <- sam_mcmc[i] + rnorm(1, sd = input$sd)
        if (proposed > 1 | proposed < 0) {
          sam_mcmc[i + 1] <- sam_mcmc[i]
          next
        }
        if (runif(1) < dens_kern(proposed) / dens_kern(sam_mcmc[i])) {
          sam_mcmc[i + 1] <- proposed
          v$accept <- v$accept + 1
        } else {
          sam_mcmc[i + 1] <- sam_mcmc[i]
        }
      }
      v$th0 <- sam_mcmc[1001]
      v$sam <- c(v$sam, sam_mcmc[2:1001])
      v$proposed <- NULL
      v$rug <- TRUE
    }
  })
  output$TargetPlot <- renderPlot({
    if (!is.null(v$th0)) {
      prop_sd <- input$sd
      curve(dens_kern(x), from = 0, to = 1, 
            xlab = expression(theta), ylab = "")
      curve(dnorm(x, v$th0, prop_sd) * 0.1, from = v$th0 - 0.3, 
            to = v$th0 + 0.3, add = TRUE, col = "lightblue")
      x <- x0 + v$th0
      polygon(c(v$th0 - 0.3, x, v$th0 + 0.3), 
              c(0, dnorm(x, v$th0, prop_sd) * 0.1, 0), 
              col = rgb(0.8, 1, 1, 0.2), border = NA)
      points(v$th0, 0, pch = 19, col = "skyblue3")
      segments(v$th0, 0, y1 = dens_kern(v$th0), col = "blue")
      text(0, 2, bquote("Current value" == .(round(v$th0, 2))), pos = 4, 
           col = "skyblue3")
      if (!is.null(v$proposed)) {
        proposed <- v$proposed
        segments(proposed, 0, y1 = dens_kern(proposed), col = "red")
        points(proposed, 0, pch = 19, col = "red")
        text(0, 1.75, bquote("Proposed value" == .(round(v$proposed, 2))), 
             pos = 4, col = "red")
        text(0, 1.5, bquote(italic(P)(Accept) == 
                              .(round(min(dens_kern(v$proposed) / 
                                            dens_kern(v$th0), 1), 3) * 100) ~ "%"), 
             pos = 4)
      }
      if (v$rug) {
        rug(v$sam[(-99):0 + length(v$sam)])
      }
    }
  })
  output$SamplePlot <- renderPlot({
    if (!is.null(v$sam)) {
      hist(v$sam, col = "lightblue1", xlab = expression(theta), 
           xlim = c(0, 1), main = "Sampled Values", freq = FALSE)
      if (length(v$sam) > 10) {
        lines(density(v$sam, bw = "SJ"), col = "blue")
      }
    }
  })
  output$TracePlot <- renderPlot({
    if (!is.null(v$sam)) {
      plot(v$sam, type = "l", xlab = "Sample", ylab = "")
    }
  })
  output$AcfPlot <- renderPlot({
    if (!is.null(v$sam)) {
      acf(v$sam, main = "Autocorrelation Plot")
    }
  })
  output$nsample <- renderText({ 
    paste("Number of simulation samples:", length(v$sam))
  })
  output$acc_rate <- renderText({ 
    paste("Acceptance rate:", round(v$accept / length(v$sam), 2))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
