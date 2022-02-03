# strongly enthusiastic prior

rm(list=ls())

tol = 1e-5
mean = log(0.6)
sd = 1 # going to be between 0.2 and 0.3

while (TRUE){
  
  if (qnorm(0.95, mean=mean, sd=sd) > 0){
    sd = sd - tol
  }
  else{
    break
  }
}

sd

# moderately enthusiastic prior

rm(list=ls())

tol = 1e-5
mean = log(0.8)
sd = 1

while (TRUE){
  
  if (qnorm(0.95, mean=mean, sd=sd) > 0){
    sd = sd - tol
  }
  else{
    break
  }
}

sd

# skeptical

rm(list=ls())

tol = 1e-5
mean = log(1)
sd = 1

while (TRUE){
  
  if (qnorm(0.05, mean=mean, sd=sd) < log(0.6)){
    sd = sd - tol
  }
  else{
    break
  }
}

sd # same as for strongly enthusiastic, which makes sense

# strongly skeptical

rm(list=ls()) 

tol = 1e-5
mean = log(1)
sd = 1

while (TRUE){
  
  if (qnorm(0.05, mean=mean, sd=sd) < log(0.8)){
    sd = sd - tol
  }
  else{
    break
  }
}

sd # idem as above, identical as mod. enthusiastic, which is a sensible result to



# epinephrine: S. Hariprakash (2003)
# outcome: admittance to hospitalization

rm(list=ls())

# enthusiastic prior

rr <- (19/38)/(23/37) 

tol <- 1e-5
mean <- log(rr) # -0.2177235
sd <- 1

while (TRUE){
  
  if (qnorm(0.95, mean=mean, sd=sd) > 0){
    sd <- sd - tol
  }
  else{
    break # error?
  }
}

sd # 0.13236



# skeptical

rm(list=ls())

rr <- (19/38)/(23/37)

tol <- 1e-5
mean <- log(rr)
sd <- 1

while (TRUE){
  
  if (qnorm(0.05, mean=log(1), sd=sd) < mean){
    sd <- sd - tol
  }
  else{
    break
  }
}

sd # 0.13236, same as before

# dexamethasone vs. placebo: Suzanne Schuh et al. (2001)
# outcome: admission to hospital (within 240 minutes after initial treatment)

# dexamethasone vs. placebo: Howard Corneli (2007)
# outcome: hospitalization

rm(list=ls())

# enthusiastic prior

rr <- 0.5*(4/17)/(5/19) + 0.5*(121/305)/(121/295)

tol <- 1e-5
mean <- log(rr) # -0.3510097
sd <- 1

while (TRUE){
  
  if (qnorm(0.95, mean=mean, sd=sd) > 0){
    sd <- sd - tol
  }
  else{
    break # error?
  }
}

sd # 0.21339



# skeptical

rm(list=ls())

rr <- 0.5*(7/36)/(15/34) + 0.5*(121/305)/(121/295)

tol <- 1e-5
mean <- log(rr)
sd <- 1

while (TRUE){
  
  if (qnorm(0.05, mean=log(1), sd=sd) < mean){
    sd <- sd - tol
  }
  else{
    break
  }
}

sd

### get median q1 and 3-rd quartile q2 of p
fn <- function(par){
  a <- par[1]
  b <- par[2]
  return(sum((pbeta(c(0.1, 0.9), a, b) - c(0.025, 0.975))^2))
}

optim(c(1, 1), fn)

fn2 <- function(par){
  a <- par[1]
  b <- par[2]
  return(sum((extraDistr::pbbinom(c(10, 90), 100, a, b) - c(0.025, 0.975))^2))
}
optim(c(1, 1), fn2)


