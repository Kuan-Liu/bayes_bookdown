---
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
colorlinks: yes
---

# Getting started with R and Rstudio {#intro_r}

## R and Rstudio Installation

R is a language and environment for statistical computing and graphics (https://cran.r-project.org/manuals.html). Many users of R like a tool called **RStudio** (https://www.rstudio.com/). This software is what is called an Integrated Development Environment (IDE) for R. It has several nice features, including docked windows for your console and syntax-highlighting editor that supports direct code execution, as well as tools for plotting and workspace management.

### Windows operating system

- install R, https://cran.r-project.org/bin/windows/base/
- install Rstudio, https://www.rstudio.com/products/rstudio/download/#download
- [YouTube Instruction](https://www.youtube.com/watch?v=TFGYlKvQEQ4)

### macOS operating system

- install R, https://cran.r-project.org/bin/macosx/
- install Rstudio, https://www.rstudio.com/products/rstudio/download/#download (select macOS 10.14+ option)
- [YouTube Instruction](https://www.youtube.com/watch?v=LanBozXJjOk)



## R Packages
Packages are the fundamental units of reproducible R code. They include reusable R functions, the documentation that describes how to use them, and sample data.[@wickham2015r]

To load the functions in a given package, we first have to install the package. We do this using the install.packages() function. Run the line of code that installs the tidyverse package below by removing the # at the start of the second line to ‘uncomment’ the code. R will install the package to a default directory on your computer. If any dialogue box prompts you to ‘set up a personal library instead’, click yes. Once we have the package installed, we must load the functions from this library so we can use them within R.


```r
  # install.packages(“tidyverse”, dependencies = T) #uncomment this line if you haven't installed this package;

  library(tidyverse) # load package library
```

The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures (https://www.tidyverse.org/). The core packages are ggplot2 (data visualization), dplyr(dataframe manipulation), tidyr(data reshaping), readr(reading datasets), purrr (function and iterations) and tibble(dataframe).


### Bayesian Analysis in R using brms package

The course will mainly use the brms package in R[@burkner2017advanced], which offers a standard R-modelling type interface to the underlying computing engine Stan. Direct use of Stan is not ideal for teaching Bayesian methods.  The brms package automatically writes Stan code that can be viewed and edited, so after learning brms, the enterprising student may want to use this Stan code as a steppingstone toward programming directly in Stan. The brms package can be installed and loaded in the same way as any other R package, in this case by typing the following commands in R:


```r
#uncomment this line if you haven't installed this package;  
# install.packages(“brms”) 
  library(brms)
```

## Working in Rstudio

### Rstudio layout

When you open RStudio, your interface is made up of four panes as shown below. These can be organised via menu options **View > Panes >**

![Rstudio layout](images/intro_to_r_rstudiolayout.png)

We can run code in the console at the prompt where R will evaluate it and print the results. However, the best practice is to write your code in a new script file so it can be saved, edited, and reproduced. To open a new script, we select **File > New File > R Script**. 

To run code that was written in the script file, you can highlight the code lines you wish be evaluated and press CTRL-Enter (windows) or Cmd+Return (Mac). Additionally, You can comment or uncomment script lines by pressing Ctrl+Shift+C (windows) or Cmd+Shift+C (Mac). The comment operator in R is `# `. You can find more RStuio default [keyboard shortcuts here](https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts-in-the-RStudio-IDE).

In our first tutorial, we will also introduce Rmarkdown, a R version of the markdown file editor that can write and output document in html, word, or pdf format that contents not only the programming code but also any evaluation outputs and graphs. To read more about Rmarkdown, please visit https://rmarkdown.rstudio.com/lesson-1.html.

### Customization

You can customize your Rstudio session under the Options dialog **Tools > Global Options** menu (or **RStudio > Preferences** on a Mac). A list of customization categories can be found here, https://support.rstudio.com/hc/en-us/articles/200549016-Customizing-RStudio. For example, it's popular to change Rstudio appearance and themes (e.g., mordern, sky, dark, and classic).

### Working directory
The working directory is the default location where R will look for files you want to load and where it will put any files you save. You can use function `getwd()` to display your current working directory and use function `setwd()` to set your workding directory to a new folder on your computer. One of the great things about using RStudio Projects is that when you open a project it will automatically set your working directory to the appropriate location. 


```r
getwd() #show my current working directory;
```

```
## [1] "D:/GitHub/bayes_bookdown"
```


### Getting help with R

The help section of R is extremely useful if you need more information about the packages and functions that **you are currently loaded**. You can initiate R help using the help function `help() ` or `?`, the help operator.


```r
help(brms)
```


## Basic R (a crash introduction) 

A more comprehensive introduction to base R can be found at https://cran.r-project.org/doc/manuals/r-release/R-intro.html. In this subsection, I will briefly outline some common R functions and commands for arithmetic, creating and working with object, vector, matrix, and data. 

This short introduction is created using the intro to R workshop notes by [Prof. Kevin Thorpe](https://www.dlsph.utoronto.ca/faculty-profile/thorpe-kevin-e/) as well as multiple open-source materials. 

Some **important** notes:

- R is case sensitive.

- Commands are separated by a newline in the console.

- The # character can be used to make comments. R doesn’t execute the rest of the line after the # symbol - it ignores it.

- Previous session commands can be accessed via the up and down arrow keys on the keyboard.

- When naming in R, avoid using spaces and special characters (i.e., !@#$%^&*()_+=;:'"<>?/) and avoid leading names with numbers.

<script src="hideOutput.js"></script>

### Arithmetic 



```r
2*3
2^3
2 + (2 + 3) * 2 - 5

log(3)
exp(3)
log(exp(1)) #playing with Euler's number;
```

  
\BeginKnitrBlock{exercise}\iffalse{-91-82-111-117-110-100-105-110-103-32-73-115-115-117-101-115-32-105-110-32-82-93-}\fi{}<div class="exercise"><span class="exercise" id="exr:unnamed-chunk-6"><strong>(\#exr:unnamed-chunk-6)  \iffalse (Rounding Issues in R) \fi{} </strong></span>Try evaluating `log(0.01^200) ` and `200*log(0.01)` in R. Note that they are mathematically equivalent.</div>\EndKnitrBlock{exercise}

<div class="fold o">

```r
log(0.01^200)
```

```
## [1] -Inf
```

```r
200*log(0.01)
```

```
## [1] -921.034
```
</div>


### Vectors

Operator `<- ` is called the assignment operation, we can create a vector (numeric, characteristic, or mixture) using the assignment operation and the `c()` function.



```r
# a vector of a single element;
x <- 3
x

# a character vector
x <- c("red", "green", "yellow")
x
length(x)
nchar(x) #number of characters for each element;

# encode a vector as a factor (or category);
y <- factor(c("red", "green", "yellow", "red", "red", "green"))
y
class(y)
as.numeric(y) # we can return factors with numeric labels;

# we can also label numeric vector with factor levels;
z <- factor(c(1,2,3,1,1,2), levels = c(1,2,3), labels = c("red", "green","yellow"))
z
class(z)
mode(z)

#we can use this to create dummy variables for regression;
contrasts(z) 

# a numeric vector;
x <- c(10.4, 5.6, 3.1, 6.4, 21.7, 53.5, 3.6, 2.6, 6.1, 1.7)
x
length(x) #return number of elements;

# a numeric vector composed of all integers between 1 and 10;
y <- 1:10
y

# a numeric vector composed of all even number integers between 0 and 10;
z <- seq(0,10, by=2)
z

# simple vector based calculations;
x + y
x*y
x/y
```



### R Session information {-}


```
## R version 4.0.5 (2021-03-31)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 19042)
## 
## Matrix products: 
## 
## locale:
## [1] LC_COLLATE=English_Canada.1252  LC_CTYPE=English_Canada.1252   
## [3] LC_MONETARY=English_Canada.1252 LC_NUMERIC=C                   
## [5] LC_TIME=English_Canada.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] brms_2.15.0     Rcpp_1.0.7      forcats_0.5.1   stringr_1.4.0  
##  [5] dplyr_1.0.7     purrr_0.3.4     readr_2.0.0     tidyr_1.1.3    
##  [9] tibble_3.1.3    ggplot2_3.3.5   tidyverse_1.3.1
```

