# Build Gibbs model over different topic numbers and evaluate the topics.

library(tm)
library(doMC)
library(topicmodels)
options("mc.cores" = 8)
dat <- read.csv("../data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
SAMPLE <- nrow(dat)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
rm(dat)
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))
# Remove terms that appear only once
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

# What really is random anyway?
SEED <- 2015
control <- list(alpha = .0001, verbose = 50, keep = 1, iter = 1000, burnin = 1000, 
                thin = 100, seed = SEED)

buildModel <- function(x) {
  model <- LDA(dtm, k = x, method = "gibbs", control = control)
}

models <- mclapply(seq(20, 80, 10), buildModel, mc.silent = FALSE)

save(models, file = "gibbs_topic_testing_very_low_alpha.RData")