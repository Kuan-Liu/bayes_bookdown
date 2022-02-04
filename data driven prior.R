rm(list=ls())
cat("\014")

library(rjags)

directory <- "~/Documents/GitHub/canbest-practicum/prior"
filename <- file.path(directory, "prior-txt/data-driven-dexa-epi.txt")

BURN.IN <- 10000
N.SAMPLES <- 20000

model.string <- "
model{
  for (i in 1:n){
    y[i] ~ dbern(p[i])
    mu[i] <- alpha + beta1*x1[i] + beta2*x2[i] + beta3*x3[i] + e[study[i]]
    log(p[i]) <- mu[i]
  }
  alpha ~ dnorm(0, 0.01)
  beta1 ~ dnorm(0, 0.01)
  beta2 ~ dnorm(0, 0.01)
  beta3 ~ dnorm(0, 0.01)
  tau_e <- 1.0 / (sigma_e)
  sigma_e ~ dgamma(2, 4)
  for (j in 1:Nstudy){
    e[j] ~ dnorm(0, tau_e)
  }
}"

writeLines(model.string, filename)

# group 1: dexa + epi
# group 2: epi
# group 3: dexa
# group 4: placebo (coded as 0 here)


# dexamethasone and epinephrine vs. epinephrine: Léa Bentur et al. (2005)
# outcome: 7-day discharge among inpatients (y = 1 => still hospitalized 7 days)

y <- c(rep(1, 5), rep(0, 29 - 5), rep(1, 13), rep(0, 32 - 13))
trt <- c(rep(1, 29), rep(2, 32))

study <- rep(1, length(trt))


# dexamethasone and salbutamol vs. dexamethasone vs. placebo: Asher Tal et al. (1982)
# outcome: partial and total failure

y <- c(y, rep(0, 8), rep(1, 4), rep(0, 8-4), rep(1, 5), rep(0, 8 - 5))
trt <- c(trt, rep(1, 8), rep(0, 8), rep(3, 8))

study <- c(study, rep(2, length(trt) - length(study)))


# dexamethasone and albuterol vs. albuterol: Suzanne Schuh et al. (2001)
# outcome: admission to hospital (within 240 minutes after initial treatment)

y <- c(y, rep(1, 7), rep(0, 36 - 7), rep(1, 15), rep(0, 34 - 15))
trt <- c(trt, rep(1, 36), rep(2, 34))

# double counting: data counts for group 1 too
y <- c(y, rep(1, 7), rep(0, 36 - 7))
trt <- c(trt, rep(1, 36))

study <- c(study, rep(3, length(trt) - length(study)))

# dexamethasone vs. placebo: Mirta Mesquita (2009)
y <- c(y, rep(1, ))


# dexamethasone vs. placebo: Howard Corneli (2007)
# outcome: hospitalization

y <- c(y, rep(1, 121), rep(0, 305 - 121), rep(1, 121), rep(0, 295 - 121))
trt <- c(trt, rep(3, 305), rep(0, 295))

# double counting
y <- c(y, rep(1, 121), rep(0, 305 - 121))
trt <- c(trt, rep(1, 305))

study <- c(study, rep(4, length(trt) - length(study)))

# epinephrine: S. Hariprakash (2003)
# outcome: admittance to hospitalization

y <- c(y, rep(1, 19), rep(0, 38 - 19), rep(1, 23), rep(0, 37 - 23))
trt <- c(trt, rep(2, 38), rep(0, 37))

# double counting
y <- c(y, rep(1, 19), rep(0, 38 - 19))
trt <- c(trt, rep(1, 38))

study <- c(study, rep(5, length(trt) - length(study)))


x1 <- as.integer(trt == 1)
x2 <- as.integer(trt == 2)
x3 <- as.integer(trt == 3)

data <- list(
  "x1" = x1,
  "x2" = x2,
  "x3" = x3,
  "y" = y,
  "n" = length(trt),
  "study" = study,
  "Nstudy" = length(unique(study))
)

jags <- jags.model(
  filename,
  data = data,
  inits = list(
    "alpha" = -1,
    "beta1" = -1,
    "beta2" = -1,
    "beta3" = -1,
    "sigma_e" = 2
  ),
  n.chains = 1
)

update(jags, BURN.IN)

mcmc.samples <- coda.samples(
  jags,
  c("alpha", "beta1", "beta2", "beta3", "sigma_e", "e"),
  N.SAMPLES,
)

beta.samples <- as.matrix(mcmc.samples[[1]][,c(2, 3, 4)])
colMeans(exp(beta.samples))
apply(beta.samples, 2, sd)




a1 <- 2;b1 <- 8
a2 <- 3;b2 <- 7
a3 <- 5;b3 <- 5
a4 <- 8;b4 <- 2

w  <- c(1/4,1/4,1/4, 1/4)
theta <- seq(0,1,0.01)
p1 <- dbeta(theta,a1,b1)
p2 <- dbeta(theta,a2,b2)
p3 <- dbeta(theta,a3,b3)
p4 <- dbeta(theta,a4,b4)
pool <- w[1]*p1+w[2]*p2+w[3]*p3+w[4]*p4

r  <- 1.2*max(c(p1,p2,p3,p4, pool))


plot(theta,p1,col=gray(0.5),lwd=2,ylim=c(0,r),type="l",
     xlab=expression(theta),ylab="Prior",
     cex.lab=1.5,cex.axis=1.5)
lines(theta,p2,col=gray(0.5),lwd=2)
lines(theta,p3,col=gray(0.5),lwd=2)
lines(theta,p4,col=gray(0.5),lwd=2)
lines(theta,pool,col=gray(0),lwd=2)
legend("topleft",c("Experts","Mixture of experts"),lwd=2,col=gray(c(0.5,0)),
       bty="n",cex=1.5)


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


