### Introduction to Discrete Random Variables

The following facts hold for discrete random variables:
  
  1. The probability associated with every value lies between 0 and 1
2. The sum of all probabilities for all values is equal to 1
3. Probabilities for discrete RVs are additive. i.e., $P(3\textrm{ or }4)=P(3)+P(4)$
  
  
  #### Expected Value
  
  Example: Consider the discrete random variable $S$, the sum of two fair dice.

```{r, echo=FALSE}
data <- data.frame(x = 2:12, y = c(1:6,5:1)/36 )
ggplot(data, aes(x=x, y=y)) +
  geom_point() +
  geom_linerange(aes(ymax=y, ymin=0)) +
  ylab('Probability') + xlab('Sum') +
  ggtitle('Distribution of the sum of two dice') +
  scale_x_continuous(breaks = c(2,4,6,8,10,12)) +
  theme_bw()
```

We often want to ask 'What is expected value of this distribution?' You might 
think about taking a really, really large number of samples from this distribution 
and then taking the mean of that really really big sample. We define the expected 
value (often denoted by $\mu$) as a weighted average of the possible values and 
the weights are the proportions with which those values occur.

$$\mu=E[S]	=	\sum_{\textrm{possible }s}\;s\cdot P\left(S=s\right)$$
  In this case, we have that
$$\begin{aligned} \mu = E[S] 
&=	\sum_{s=2}^{12}s\cdot P(S=s) \\
&=	2\cdot P\left(S=2\right)+3\cdot P\left(S=3\right)+\dots+11\cdot P\left(S=11\right)+12\cdot P\left(S=12\right) \\
&=	2\left(\frac{1}{36}\right)+3\left(\frac{2}{36}\right)+\dots+11\left(\frac{2}{36}\right)+12\left(\frac{1}{36}\right) \\
&=	7
\end{aligned}$$ 
  
  #### Variance
  
  Similarly we could define the variance of $S$ (which we often denote $\sigma^{2}$) 
as a weighted average of the squared-deviations that could occur. 
$$ \sigma^{2}=V[S]	= \sum_{\textrm{possible }s}\; (s-\mu)^2 \cdot P\left(S=s\right)$$
  which in this example can be calculated as
$$\begin{aligned} \sigma^{2}=V[S] 
&= \sum_{s=2}^{12}\left(s-\mu\right)^{2}P(S=s) \\
&= (2-7)^{2}\left(\frac{1}{36}\right)+(3-7)^{2}\left(\frac{2}{36}\right)+\dots+(12-7)^{2}\left(\frac{1}{36}\right) \\
&= \frac{35}{6}=5.8\bar{3}
\end{aligned}$$
  
  We could interpret the expectation as the sample mean of an infinitely large 
sample, and the variance as the sample variance of the same infinitely large 
sample. These are two very important numbers that describe the distribution.

**Example:** Aubrey is a massage therapist and over the last year, the number 
of clients she sees per work day (denoted Y) varied according the following table:
  
  |  Number of Clients         |   0   |   1   |   2   |   3   |   4   |
  |---------------------------:|:-----:|:-----:|:-----:|:-----:|:-----:| 
  |  **Frequency/Probability** |  0.30 |  0.35 |  0.20 |  0.10 |  0.05 |
  
  ```{r}
distr <- data.frame(    clients = c( 0,   1,    2,    3,    4   ),    # two columns 
                        probability = c(0.3, 0.35, 0.20, 0.10, 0.05 ) )   # 
ggplot(distr, aes(x=clients)) +                   # graph with clients as the x-axis
  geom_point(aes(y=probability)) +                # where the dots go
  geom_linerange(aes(ymax=probability, ymin=0)) + # the vertical lines       
  theme_bw()                                      # set background color...
```

Because this is the long term relative frequency of the number of clients (over 
                                                                           200 working days!), it is appropriate to interpret these frequencies as probabilities. 
This table and graph is often called a **probability mass function (pmf)** because 
it lists how the probability is spread across the possible values of the random 
variable. We might next ask ourselves what is the average number of clients per day?
  
  $$\begin{aligned} E\left(Y\right)	
&=	\sum_{\textrm{possible }y}y\,P\left(Y=y\right) \\
&=	\sum_{y=0}^{4}y\,P\left(Y=y\right) \\
&=	0\,P\left(Y=0\right)+1\,P\left(Y=1\right)+2\,P\left(Y=2\right)+3\,P\left(Y=3\right)+4\,P\left(Y=4\right) \\
&=	0\left(0.3\right)+1\left(0.35\right)+2\left(0.20\right)+3\left(0.10\right)+4\left(0.05\right) \\
&=	1.25 \end{aligned}$$
  
  Notice that this number is not an integer and therefore is not a value that 
$Y$ could actually take on.  You might be tempted to therefore round it to the 
nearest integer.  That would be wrong. The rational is that if we wanted to 
estimate the number of clients she has per month (and thus her income), we would 
have a worse estimate if we used the rounded number.

Another example of a case where rounding would be inappropriate is in gambling 
situations where the amount won or lost per hand isn't particularly important but 
the average amount won or lost over hundreds or thousands of plays is what matters. 
A Roulette wheel has 18 red and 18 black slots along with 2 green. If you bet $1 
on red, you could either win a dollar or lose a dollar. However, because the 
probabilities are

|                   |    Win ( + $1 )        |  Lose (- $1)      |
|------------------:|:----------------------:|:-----------------:|
| **Probability**   |  $\frac{18}{38}$       |  $\frac{20}{38}$  |

then the persons expected winnings per play are:

$$ \begin{aligned}E[W] 
  =	\sum_{\textrm{possible }w}w\,P\left(W=w\right) 
  =  1 \left(\frac{18}{38} \right) + -1 \left( \frac{20}{38} \right) 
  =  -0.0526 \end{aligned}$$
  
So for every Black/Red bet, the player should expect to lose 5.2 cents. While 
this number is small, it is enough to make the casino millions of dollars over 
the long run.
 
Returning to the massage therapy example, assuming that successive days are 
independent (which might be a bad assumption) what is the probability she has 
two days in a row with no clients?
$$\begin{aligned}P\left(\textrm{0 on day1 }and\textrm{ 0 on day2}\right)	
  &=	P\left(\textrm{0 on day 1}\right)P\left(\textrm{0 on day 2}\right) \\
	&=	\left(0.3\right)\left(0.3\right) \\
	&=	0.09 \end{aligned}$$
 
What is the variance of this distribution?
$$\begin{aligned}V\left(Y\right)	
  &= \sum_{\textrm{possible y}}\,\left(y-\mu\right)^{2}\,P\left(Y=y\right) \\
	&= \sum_{y=0}^{4}\,\left(y-\mu\right)^{2}P\left(Y=y\right) \\
	&=	\left(0-1.25\right)^{2}\left(0.3\right)+\left(1-1.25\right)^{2}\left(0.35\right)+\left(2-1.25\right)^{2}\left(0.20\right)+\left(3-1.25\right)^{2}\left(0.10\right)+\left(4-1.25\right)^{2}\left(0.05\right) \\
	&=	1.2875 \end{aligned}$$
 
Note on Notation: There is a difference between the upper and lower case letters 
we have been using to denote a random variable. In general, we let the upper case 
denote the random variable and the lower case as a value that the the variable 
could possibly take on. So in the massage example, the number of clients seen 
per day $Y$ could take on values $y=0,1,2,3,$ or $4$. 

### Common Discrete Distributions

#### Binomial Distribution

**Example:** Suppose we are trapping small mammals in the desert and we spread 
out three traps. Assume that the traps are far enough apart that having one being 
filled doesn't affect the probability of the others being filled and that all 
three traps have the same probability of being filled in an evening. Denote the 
event that a trap is filled with a critter as $C_{i}$ and denote the event that 
the trap is empty as $E_{i}$. Denote the probability that a trap is filled by 
$\pi=0.8$. (This sort of random variable is often referred to as a Bernoulli RV.)

The possible outcomes are 

|  Outcome           |  $\,$  |
  |:------------------:|:------:|
  |  $E_1, E_2, E_3$   |  $\,$  |
  |  $C_1, E_2, E_3$   |  $\,$  |
  |  $E_1, C_2, E_3$   |  $\,$  |
  |  $E_1, E_2, C_3$   |  $\,$  |
  |  $C_1, C_2, E_3$   |  $\,$  |
  |  $C_1, E_2, C_3$   |  $\,$  |
  |  $E_1, C_2, C_3$   |  $\,$  |
  |  $C_1, C_2, C_3$   |  $\,$  |
  
  Because these are far apart enough in space that the outcome of Trap1 is independent 
of Trap2 and Trap3, then 
$$P(E_{1}\cap C_{2}\cap E_{3})	=	P(E_{1})P(C_{2})P(E_{3})
=	(1-0.8)0.8(1-0.8)
=	0.032$$
  **Notice how important the assumption of independence is!!!** Similarly we could 
calculate the probabilities for the rest of the table.

|  Outcome           |   Probability   |  $S$ Outcome  |   Probability        |
  |:------------------:|:---------------:|:-------------:|:--------------------:|
  |  $E_1, E_2, E_3$   |     0.008       |   $S=0$       |     0.008            |
  |------------------- | --------------- | ------------- | ---------------      |
  |  $C_1, E_2, E_3$   |     0.032       |               |                      |
  |  $E_1, C_2, E_3$   |     0.032       |   $S=1$       |  $3(0.032) = 0.096$  |
  |  $E_1, E_2, C_3$   |     0.032       |               |                      |
  |------------------- | --------------- | ------------- | ---------------      |
  |  $C_1, C_2, E_3$   |     0.128       |               |                      | 
  |  $C_1, E_2, C_3$   |     0.128       |   $S=2$       |  $3(0.128) = 0.384$  |
  |  $E_1, C_2, C_3$   |     0.128       |               |                      |
  |------------------- | --------------- | ------------- | ---------------      |
  |  $C_1, C_2, C_3$   |     0.512       |   $S=3$       |  $0.512$             |
  
  
  Next we are interested in the random variable $S$, the number of traps that were filled:
  
  |  $S$ Outcome  |   Probability   |
  |:-------------:|:---------------:|
  |   $S=0$       |  $0.008$        |
  |   $S=1$       |  $0.096$        |
  |   $S=2$       |  $0.384$        |
  |   $S=3$       |  $0.512$        |
  
  
  $S$ is an example of a Binomial Random Variable. A binomial experiment is one that:
  
  1.  Experiment consists of $n$ identical trials.
2.  Each trial results in one of two outcomes (Heads/Tails, presence/absence). One 
will be labeled a success and the other a failure.
3.  The probability of success on a single trial is equal to $\pi$ and remains the 
same from trial to trial. 
4.  The trials are independent (this is implied from property 3).
5.  The random variable $Y$ is the number of successes observed during $n$ trials.

Recall that the probability mass function (pmf) describes how the probability is 
spread across the possible outcomes, and in this case, I can describe this via a 
nice formula. The pmf of a a binomial random variable $X$ taken from $n$ trials 
each with probability of success $\pi$ is 

$$P(X=x)=\underbrace{\frac{n!}{x!(n-x)!}}_{orderings}\;\underbrace{\pi^{x}}_{y\,successes}\;\underbrace{(1-\pi)^{n-x}}_{n-y\,failures}$$
  
  where we define $n!=n(n-1)\dots(2)(1)$ and further define $0!=1$. Often the 
ordering term is written more compactly as 
$${n \choose x}=\frac{n!}{x!\left(n-x\right)!}$$. 

For our small mammal example we can create a graph that shows the binomial 
distribution with the following R code:
  
  ```{r}
dist <- data.frame( x=0:3 ) %>% 
  mutate(probability = dbinom(x, size=3, prob=0.8))
ggplot(dist, aes(x=x)) +
  geom_point(aes(y=probability)) +
  geom_linerange(aes(ymax=probability, ymin=0)) +
  ggtitle('Binomial distribution: n=3, p=0.8') +
  theme_bw()
```

To calculate the height of any of these bars, we can evaluate the pmf at the 
desired point. For example, to calculate the probability the number of full 
traps is 2, we calculate the following

$$\begin{aligned} P(X=2)	
&=	{3 \choose 2}\left(0.8\right)^{2}\left(1-0.8\right)^{3-2} \\
&=	\frac{3!}{2!(3-2)!}(0.8)^{2}(0.2)^{3-2} \\
&=	\frac{3\cdot2\cdot1}{(2\cdot1)1}\;(0.8)^{2}(0.2) \\
&=	3(0.128) \\
&=	0.384 \end{aligned}$$
  
  You can use R to calculate these probabilities. In general, for any distribution, 
the “d-function” gives the distribution function (pmf or pdf). So to get R to do 
the preceding calculation we use:
  
  ```{r}
# If    X ~ Binomial(n=3, pi=0.8)
# Then  P( X = 2 | n=3, pi=0.8 ) =
dbinom(2, size=3, prob=0.8)
```

The expectation of this distribution can be shown to be 
$$\begin{aligned}E[X]	
&=	\sum_{x=0}^{n}x\,P(X=x) \\
&=	\sum_{x=0}^{n}x\;\frac{n!}{x!\left(n-x\right)!}\pi^{x}\left(1-\pi\right)^{n-x}\\
&=	\vdots \\
&=	n\pi \end{aligned}$$
  
  and the variance can be similarly calculated
$$\begin{aligned} V[X]	
&=	\sum_{x=0}^{n}\left(x-E\left[X\right]\right)^{2}\,P\left(X=x|n,\pi\right) \\
&=	\sum_{x=0}^{n}\left(x-E\left[X\right]\right)^{2}\;\frac{n!}{x!\left(n-x\right)!}\pi^{x}\left(1-\pi\right)^{n-x} \\
&=	\vdots \\
&=	n\pi(1-\pi) \end{aligned}$$
  
  
  **Example:** Suppose a bird survey only captures the presence or absence of a 
particular bird (say the mountain chickadee). Assuming the true presence proportion 
at national forest sites around Flagstaff is $\pi=0.1$, then for $n=20$ randomly 
chosen sites, the number of sites in which the bird was observed would have the 
following PMF.

```{r}
dist <- data.frame( x = 0:20 ) %>% 
  mutate(probability = dbinom(x, size=20, prob=0.1))
ggplot(dist, aes(x=x)) +
  geom_point(aes(y=probability)) +
  geom_linerange(aes(ymax=probability, ymin=0)) +
  ggtitle('Binomial distribution: n=20, p=0.1') +
  xlab('Number of Sites Occupied') +
  theme_bw()
```

Often we are interested in questions such as $P(X\le2)$ which is the probability 
that we see 2 or fewer of the sites being occupied by mountain chickadee. These 
calculations can be tedious to calculate by hand but R will calculate these 
cumulative distribution function values for you using the “p-function”. This 
cumulative distribution function gives the sum of all values up to and including 
the number given.

```{r}
# P(X=0) + P(X=1) + P(X=2)
sum <- dbinom(0, size=20, prob=0.1) + 
  dbinom(1, size=20, prob=0.1) + 
  dbinom(2, size=20, prob=0.1)
sum
# P(X <= 2)
pbinom(2, size=20, prob=0.1)
```

In general we will be interested in asking four different questions about a distribution.

1.  What is the height of the probability mass function (or probability density function). 
For discrete variable $Y$ this is $P\left(Y=y\right)$ for whatever value of $y$ 
  we want. In R, this will be the `d`-function.
2.  What is the probability of observing a value less than or equal to $y$? In 
other words, to calculate $P\left(Y\le y\right)$. In R, this will be the `p`-function.
3.  What is a particular quantile of a distribution? For example, what value separates 
the lower $25\%$ from the upper $75\%$? In R, this will be the `q`-function.
4.  Generate a random sample of values from a specified distribution. In R, this 
will be the `r`-function.

#### Poisson Distribution

A commonly used distribution for count data is the Poisson.

1.  Number of customers arriving over a 5 minute interval
2.  Number of birds observed during a 10 minute listening period
3.  Number of prairie dog towns per 1000 hectares
4.  Number of alga clumps per cubic meter of lake water

A discrete RV is a Poisson RV if the following conditions apply:
  
  1.  Two or more events do not occur at precisely the same time or in the same space
2.  The occurrence of an event in a given period of time or region of space is 
independent of the occurrence of the event in a non overlapping period or region.
3.  The expected number of events during one period or region, $\lambda$, is the 
same in all periods or regions of the same size.

Assuming that these conditions hold for some count variable $Y$, the the 
probability mass function is given by
$$P(Y=y)=\frac{\lambda^{y}e^{-\lambda}}{y!}$$
  where $\lambda$ is the expected number of events over 1 unit of time or space 
and $e$ is the constant $2.718281828\dots$. 

$$E[Y]	=	\lambda$$
  $$Var[Y]	=	\lambda$$
  
  
  **Example:** Suppose we are interested in the population size of small mammals in 
a region. Let $Y$ be the number of small mammals caught in a large trap over a 12 
hour period. Finally, suppose that $Y\sim Poisson(\lambda=2.3)$. What is the 
probability of finding exactly 4 critters in our trap?
  $$P(Y=4)	=	\frac{2.3^{4}\,e^{-2.3}}{4!} =	0.1169$$
  What about the probability of finding at most 4?
  $$\begin{aligned} P(Y\le4)	
&=	P(Y=0)+P(Y=1)+P(Y=2)+P(Y=3)+P(Y=4) \\
&=	0.1003+0.2306+0.2652+0.2033+0.1169 \\
&=	0.9163 \end{aligned}$$
  
  What about the probability of finding 5 or more?
  $$P(Y\ge5)	=	1-P(Y\le4) =	1-0.9163 =	0.0837$$
  
  These calculations can be done using the distribution function (d-function) for 
the Poisson and the cumulative distribution function (p-function).

```{r}
dist <- data.frame( NumCaught = 0:10 ) %>%
  mutate( probability = dpois( NumCaught, lambda=2.3 ) )
ggplot(dist, aes(x=NumCaught)) +
  geom_point( aes(y=probability) ) +
  geom_linerange(aes( ymax=probability, ymin=0)) +
  ggtitle(expression(paste('Poisson Distribution with  ', lambda == 2.3))) +
  labs(x='Number Caught') +
  theme_bw()            
# P( Y = 4)
dpois(4, lambda=2.3)
# P( Y <= 4)
ppois(4, lambda=2.3)
# 1-P(Y <= 4)  ==  P( Y > 4)  ==  P( Y >= 5)
1-ppois(4, 2.3)
```

### Continuous Random Variables

Continuous random variables can take on an (uncountably) infinite number of values, 
and this results in a few obnoxious mathematical differences between how we handle 
continuous and discrete random variables.  In particular, the probability that a 
continuous random variable $X$ will take on a particular value will be zero, so 
we will be interested in finding the probability that the random variable is in 
some interval instead.  Wherever we had a summation, $\sum$, we will instead have 
an integral, but because many students haven't had calculus, we will resort to 
using R or tables of calculated values.

#### Uniform(0,1) Distribution

Suppose you wish to draw a random number number between 0 and 1 and any two 
intervals of equal size should have the same probability of the value being in 
them. This random variable is said to have a Uniform(0,1) distribution.

Because there are an infinite number of rational numbers between 0 and 1, the 
probability of any particular number being selected is $1/\infty=0$. But even 
though each number has 0 probability of being selected, some number must end up 
being selected. Because of this conundrum, probability theory doesn't look at 
the probability of a single number, but rather focuses on a region of numbers. 

To make this distinction, we will define the distribution using a 
**probability density function (pdf)** instead of the probability mass function. 
In the discrete case, we had to constrain the probability mass function to sum 
to 1. In the continuous case, we have to constrain the probability density function 
to integrate to 1.

```{r, echo=FALSE}
data <- data.frame(x = seq(-.2, 1.2, length=1000)) %>%
  mutate( y = dunif(x))
ggplot(data, aes(x=x, y=y)) +
  geom_line() +
  labs(x='X', y='density', title='PDF of Uniform(0,1)') +
  geom_text(x=.5, y=.5, label='Area = 1') +
  theme_bw() 
```

```{r, echo=FALSE}
data <- data.frame(x = seq(-.2, 1.2, length=1000)) %>%
  mutate( y = dunif(x))
ggplot(data, aes(x=x, y=y)) +
  geom_line() +
  geom_area(data=data %>% filter(x < .4), fill='grey', alpha=.4) +
  labs(x='X', y='density', title='PDF of Uniform(0,1)') +
  geom_text(x=.2, y=.5, label='P(X<=0.4) == 0.4', parse=TRUE) +
  theme_bw() 
```

Finding the area under the curve of a particular density function $f(x)$ usually 
requires the use of calculus, but since this isn't a calculus course, we will 
resort to using R or tables of calculated values.

#### Exponential Distribution

The exponential distribution is the continuous analog of the Poisson distribution 
and is often used to model the time between occurrence of successive events. 
Perhaps we are modeling time between transmissions on a network, or the time 
between feeding events or prey capture. If the random variable $X$ has an 
Exponential distribution, its probability density function is 
$$f(x)=\begin{cases}
\lambda e^{-\lambda x} & x\ge0\;\textrm{ and }\;\lambda>0\\
0 & \textrm{otherwise}
\end{cases}$$
 



Analogous to the discrete distributions, we can define the Expectation and 
Variance of these distributions by replacing the summation with an integral
$$\mu = E[X] =	\int_{0}^{\infty}x\,f(x)\,dx = \dots = \frac{1}{\lambda} $$
$$\sigma^2 = Var[X]	=	\int_{0}^{\infty}\left(x-\mu\right)^{2}\,f\left(x\right)\,dx =	\dots = \frac{1}{\lambda^{2}}$$
 
Because the exponential distribution is defined by the rate of occurrence of an 
event, increasing that rate decreases the time between events. Furthermore because 
the rate of occurrence cannot be negative, we restrict $\lambda>0$.

```{r, echo=FALSE}
data <- expand.grid(x=seq(0,10,length=1000), lambda = c(.5, 1, 2)) %>%
  mutate(y=dexp(x, rate = lambda),
         lambda = paste('lambda == ', lambda))
ggplot(data, aes(x=x, y=y)) +
  geom_area(fill='grey') +
  facet_grid(lambda~., labeller = labeller(lambda=label_parsed)) +
  labs(y='density') +
  theme_bw()
```

**Example:**  Suppose the time between insect captures $X$ during a summer evening 
for a species of bat follows a exponential distribution with capture rate of 
$\lambda=2$ insects per minute and therefore the expected waiting time between 
captures is $1/\lambda=1/2$ minute. Suppose that we are interested in the probability 
that it takes a bat more than 1 minute to capture its next insect.

$$P(X>1)=$$
 
```{r}
data <- data.frame(x=seq(0,5,length=1000), lambda = 2) %>%
  mutate(y=dexp(x, rate = lambda),
         grp = ifelse( x > 1, '> 1', '<= 1'))
ggplot(data, aes(x=x, y=y, fill=grp)) +
  geom_area() +
  labs(y='density') +
  theme_bw()
```

We now must resort to calculus to find this area. Or use tables of pre-calculated 
values. Or use R, remembering that p-functions give the area under the curve to 
the left of the given value.

```{r}
# P(X > 1)  == 1 - P(X <= 1)  ### Complement Rule
1 - pexp(1, rate=2)
```

#### Normal Distribution

Undoubtedly the most important distribution in statistics is the normal 
distribution. If my RV $X$ is normally distributed with mean $\mu$ and standard 
deviation $\sigma$, its probability density function is given by
$$f(x)=\frac{1}{\sqrt{2\pi}\sigma}\exp\left[-\frac{(x-\mu)^{2}}{2\sigma^{2}}\right]$$
where $\exp[y]$ is the exponential function $e^{y}$. We could slightly rearrange 
 the function to

$$f(x)=\frac{1}{\sqrt{2\pi}\sigma}\exp\left[-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^{2}\right]$$
 

and see this distribution is defined by its expectation $E[X]=\mu$ and its 
variance $Var[X]=\sigma^{2}$. Notice I could define it using the standard 
deviation $\sigma$, and different software packages will expect it to be defined 
by one or the other. R defines the normal distribution using the standard deviation. 

```{r, echo=FALSE}
data <- rbind(data.frame(x=seq(-5,8,length=2000), grp=1, mu=0, sigma=1),
              data.frame(x=seq(-5,8,length=2000), grp=2, mu=2, sigma=2),
              data.frame(x=seq(-5,8,length=2000), grp=3, mu=-3, sigma=0.6)) %>%
  mutate(y=dnorm(x, mean=mu, sd=sigma),
         mu = paste('mu == ', mu),
         sigma = paste('sigma ==', sigma))
label.df <- data.frame( grp=rep(1:3, each=2), label=c('mu == 0','sigma == 1', 'mu == 2','sigma == 2', 'mu==-3','sigma == 0.6'),
                        x = c(0,0, 4.8,4.8, -4.15,-4.15), y= c(.46,.43,  .16,.13, .56,.53))
ggplot(data, aes(x=x, y=y, color=factor(grp))) +
  geom_line() +
  geom_text(data=label.df, aes(label=label), parse=TRUE) +
  labs(y='density') +
  theme_bw() +
  scale_color_discrete(guide=FALSE)
```


**Example:**  It is known that the heights of adult males in the US is 
approximately normal with a mean of 5 feet 10 inches ($\mu=70$ inches) and a 
standard deviation of $\sigma=3$ inches. One of the textbook authors is a mere 5 feet 4 
inches (64 inches). What proportion of the population is shorter than the author?

```{r}
distr <- data.frame(x=seq(57, 82, length=1000)) %>%
  mutate( density = dnorm(x, mean=70, sd=3),
          group = ifelse(x<=64, 'Shorter','Taller') )
ggplot(distr, aes(x=x, y=density, fill=group)) +
  geom_line() +
  geom_area() +
  theme_bw()
```

Using R you can easily find this

```{r}
pnorm(64, mean=70, sd=3)
```
