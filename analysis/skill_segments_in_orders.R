# Explore skill-segments in orders
library(topicmodels)
library(ggplot2)
library(tm)

load("gibbs/gibbs_full_models.RData")
model <- models[[1]]
dat <- read.csv("data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))

# Remove terms that appear only once
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]

# Inspect the results
k <- model@k
TERMS <- 20
RECORD <- floor(runif(1, 1, length(model@documents)))
dat[RECORD,1]
topics <- topics(model, 4)[,RECORD]
topics
probs <- model@gamma[RECORD,]
entropy <- -sum(probs * log(probs))
entropy
# names(probs) <- 1:k
qplot(x = 1:k, y = probs, col=I("green"), main = paste("Skill-Segment Probabilities",
                                                              "Order Id:", dat[RECORD, 1], "(",
                                                              topics[1], topics[2], topics[3], 
                                                              topics[4], ")"), 
     xlab = "Skill-Segment", ylab = "Probability", geom = "bar", stat = "identity", 
     alpha = I(.2))
terms(model, TERMS)[,topics]
term.prob <- sort(exp(model@beta[topics[1], ]), decreasing = TRUE)[1:TERMS]
plot(1:TERMS, term.prob, type='b', col="red", main = "Term Probabilities",
     xlab = "Terms", ylab = "Probability", xlim = c(0,11))
