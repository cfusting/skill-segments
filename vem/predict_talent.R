# Evaluate the ability of the VEM LDA model to predict talent 

library(topicmodels)
library(tm)

setwd("/home/elpinguino/Dropbox/consulting/aquent_recruitment")
load("sample_82_model.RData")
tsk <- read.csv("talent_skills.csv")
tsk <- subset(tsk, skills != "")
sam <- sample(nrow(toc), size = 1000)
dat <- tsk[sam,]
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")

skills <- DataframeSource(skills.frame)
skill.corpus <- VCorpus(skills)
dtm <- DocumentTermMatrix(skill.corpus)

post <- posterior(model, dtm)

# Get the most probable topics for a talent
TERMS <- 10
RECORD <- 106
dat[RECORD,1]
tops <- sort(post$topics[RECORD, ], decreasing = TRUE)
plot(names(tops), tops, main = "Topics", xlab = "topics", ylab = "Probability", type = "p",
     col = "green")
topics <- as.numeric(names(tops[1:3]))
terms(model, TERMS)[,topics]
term.prob <- sort(exp(model@beta[topics[1], ]), decreasing = TRUE)[1:TERMS]
plot(1:TERMS, term.prob, type='b', col="red", main = "Term Probabilities",
     xlab = "Terms", ylab = "Probability", xlim = c(0,11))
