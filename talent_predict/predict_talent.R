# Predict the skill-segments of talent
# This takes awhile, run on the cloud.

library(tm)
library(topicmodels)
library(ggplot2)
setwd("../")
load("gibbs/gibbs_full_models.RData")
model <- models[[2]]
dat <- read.csv("data/talent_skills.csv")
dat <- subset(dat, nchar(as.vector(skills)) > 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))
post <- posterior(model, dtm)
save(post, file = "talent_predict/posterior.RData")
