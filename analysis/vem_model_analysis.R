# Sample the dataset
library(topicmodels)
library(tm)

setwd("/home/elpinguino/Dropbox/consulting/aquent_recruitment")
toc <- read.csv("toc.csv")
toc <- subset(toc, skills != "")
toc <- subset(toc, candidate_number < 20)
sam <- sample(nrow(toc), size = 1000)
dat <- toc[sam,]
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")

skills <- DataframeSource(skills.frame)
skill.corpus <- VCorpus(skills)
dtm <- DocumentTermMatrix(skill.corpus)

k = 90
control <- list(alpha = .011269020, estimate.alpha = FALSE, verbose = 1, keep = 1)
model <- LDA(dtm, k, control = control)

# Inspect the results
TERMS <- 10
RECORD <- 1111
dat[RECORD,1]
topics <- topics(model, 4)[,RECORD]
topics
plot(1:k, model@gamma[RECORD,], type="l", col="green", main = "Topic Probabilities", 
     xlab = "Topic", ylab = "Probability")
terms(model, TERMS)[,topics]
term.prob <- sort(exp(model@beta[topics[1], ]), decreasing = TRUE)[1:TERMS]
plot(1:TERMS, term.prob, type='b', col="red", main = "Term Probabilities",
     xlab = "Terms", ylab = "Probability", xlim = c(0,11))
