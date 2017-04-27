# The production model configuration
library(tm)
library(doMC)
library(topicmodels)

dat <- read.csv("../data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
rm(dat)
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))

# Remove terms that appear only once
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

model <- LDA(dtm, k = 20, method = "Gibbs", control = list(alpha = 0.001, iter = 1000,
                                                             burnin = 1000, thin = 100,
                                                             verbose = 50))

save(model, file = "model.RData")