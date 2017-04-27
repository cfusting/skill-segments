library(tm)
library(topicmodels)
library(doMC)
options("mc.cores" = 4)

dat <- read.csv("toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
rm(dat)
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

control <- list(verbose = 1, keep = 1)
model <- LDA(dtm, 50, control = control)

save(model, file = "VEM_model_50.RData")