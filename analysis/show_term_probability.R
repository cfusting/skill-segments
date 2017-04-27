library(ggplot2)
load("gibbs/gibbs_full_models.RData")
model <- models[[1]]

TERMS <- 1000

showTermProbs <- function(x) {
  term.prob <- sort(exp(model@beta[x, ]), decreasing = TRUE)[1:TERMS]
  qplot(1:TERMS, y = term.prob, fill = I("red"), col = I("blue"), 
        main = paste("Term Probabilities: skill-cluster", x), xlab = "Terms", 
        ylab = "Probability")
}

lapply(seq(1, 20, 5), showTermProbs)

