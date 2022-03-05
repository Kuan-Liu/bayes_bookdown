p1 <- ggplot(aes(x = height, y = fev), data = FEV) + 
  geom_point(size = 0.7) +  # add a layer with the points
  geom_smooth()

p2 <- ggplot(aes(x = age, y = fev), data = FEV) + 
  geom_point(size = 0.7) +  # add a layer with the points
  geom_smooth()

p3 <- ggplot(aes(x = factor(sex), y = fev), data = FEV) + 
  geom_boxplot()  # add a layer with a boxplot

p4 <- ggplot(aes(x = factor(smoke), y = fev), data = FEV) + 
  geom_boxplot() 

ggarrange(p1, p2, p3,p4, nrow = 2, ncol=2)