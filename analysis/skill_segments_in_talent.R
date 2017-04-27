# Predict the skill-segments of talent

library(tm)
library(topicmodels)
library(ggplot2)

load("gibbs/gibbs_full_models.RData")
model <- models[[2]]
dat <- read.csv("data/talent_skills.csv")
dat <- subset(dat, nchar(as.vector(skills)) > 20)
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
dtm <- DocumentTermMatrix(VCorpus(DataframeSource(skills.frame)))

# Inspect the results
k <- model@k
TERMS <- 10
RECORD <- 1765
dat[RECORD,]
probs <- posterior(model, dtm[RECORD, ])$topics
topics <- (sort(probs, index.return = TRUE, decreasing = TRUE)$ix)[1:4]
topics
qplot(x = 1:k, y = as.vector(probs), col=I("green"), main = paste("Skill-Segment Probabilities",
                                                        "Talent Id:", dat[RECORD, 1], "(",
                                                        topics[1], topics[2], topics[3], 
                                                        topics[4], ")"), 
      xlab = "Skill-Segment", ylab = "Probability", geom = "bar", stat = "identity", 
      alpha = I(.2))
terms(model, TERMS)[,topics]
term.prob <- sort(exp(model@beta[topics[1], ]), decreasing = TRUE)[1:TERMS]
plot(1:TERMS, term.prob, type='b', col="red", main = "Term Probabilities",
     xlab = "Terms", ylab = "Probability", xlim = c(0,11))