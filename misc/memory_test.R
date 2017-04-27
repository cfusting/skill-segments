# Evaluate memory usage on a single model.
library(tm)
library(doMC)
library(topicmodels)

# Orders
toc <- read.csv("toc.csv")
dat <- toc
# Remove orders with no skills or high candidate numbers
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
skills <- DataframeSource(skills.frame)
skill.corpus <- VCorpus(skills)
dtm <- DocumentTermMatrix(skill.corpus)
# Remove terms that appear only once
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

LDA(dtm, 50)
