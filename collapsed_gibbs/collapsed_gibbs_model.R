# Speed test for the collapsed Gibbs sampling approach
library(lda)
library(tm)
library(topicmodels)

dat <- read.csv("toc.csv")
dat <- subset(dat, skills != "")
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
rm(dat)

dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

# Convert to lda package format
lda.format <- dtm2ldaformat(dtm)

rm(dtm)

model <- lda.collapsed.gibbs.sampler(lda.format[[1]], 50, lda.format[[2]], 50, 
                                     .01, .1, burnin = 0, compute.log.likelihood = TRUE)
save(model, file = "gibbs_50it_model.RData")