# Predict talent well suited for orders
library(tm)
library(topicmodels)
library(ggplot2)

load("gibbs/gibbs_full_models.RData")
model <- models[[2]]
load("talent_predict/posterior.RData")
sf.o <- read.csv("data/sf_orders.csv")
sf.t <- read.csv("data/sf_talent.csv")
tal <- read.csv("data/talent_skills.csv")
tal <- subset(tal, nchar(as.vector(skills)) > 20)
dat <- read.csv("data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)

# Ensure ordering is retained using an id column and post merge sort ascending 
tal$id <- 1:nrow(tal)
tal.m <- merge(tal, sf.t)
tal.m <- tal.m[order(tal.m$id), ]
dat$id <- 1:nrow(dat)
ord.m <- merge(dat, sf.o)
ord.m <- ord.m[order(ord.m$id), ]

# Get the talent and order distributions and compare
talent <- post$topics[tal.m$id, ]
orders <- model@gamma[ord.m$id, ]
dis <- distHellinger(talent, orders)

# Find some examples
ord.ind <- floor(runif(1, 1, nrow(ord.m)))
ORDER <- ord.m$order_id[ord.ind]
ORDER
o.topics <- sort(orders[ord.ind, ], index.return = TRUE, decreasing = TRUE)
o.topics$ix[1:4]
sim <- sort(dis[, ord.ind], index.return = TRUE)
tal.ind <- sim$ix[1]
t.topics <- sort(talent[tal.ind, ], index.return = TRUE, decreasing = TRUE)
t.topics$ix[1:4]
order.df <- data.frame(ss = 1:90, Probability = orders[ord.ind, ], Entity = "Order")
talent.df <- data.frame(ss = 1:90, Probability = talent[tal.ind, ], Entity = "Talent")
both.df <- rbind(order.df, talent.df)

ggplot(both.df, aes(x = ss, y = Probability, fill = Entity)) +
  geom_bar(alpha = 1, stat = "Identity", position = "dodge") +
  labs(title = "Skill-Segment Probabilities", x = "Skill-Segment" )

qplot(1:100, sim$x[1:100], col = I("red"), main = paste("Similarity of Talent with Order", 
                                                        ORDER), 
      xlab = "Talent", ylab = "Similarity")
tal.m$person_id[sim$ix[1:3]]
