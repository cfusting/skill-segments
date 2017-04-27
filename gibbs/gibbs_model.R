# Build gibbs models with different topic numbers.

library(tm)
library(topicmodels)
library(doMC)
options("mc.cores" = 4)

dat <- read.csv("data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
rm(dat)
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

control <- list(alpha = .01, verbose = 1, keep = 1, iter = 1000, burnin = 1000, thin = 100)
models <- mclapply(c(50, 90, 120), function(x) LDA(dtm, x, method = "Gibbs", control = control), 
                   mc.silent = FALSE)

save(models, file = "gibbs_full_models.RData")
