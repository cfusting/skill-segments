library(ggplot2)
dat <- read.csv("data/talent_associated_to_order.csv")
qplot(subset(dat, X1 > 1 & X1 < 20)[,2], main = "Candidates on Orders in the Previous 2 Years",
      xlab = "Number of Candidates", ylab = "Number of Orders", 
      col = I("blue"), binwidth = 1, alpha = I(0.2))
