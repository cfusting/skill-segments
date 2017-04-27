# Cross-Validate the Gibbs LDA for alpha. See cross-val.R for other details.
# Easily adapted to cross validate k (topic number) or delta

start <- proc.time()
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

# Setup CV
options("mc.cores" = 32)
FOLDS <- 3
PROPORTION <- 0.1

validate.lda <- function(i, x, validate.entries) {
  validate <- dtm[validate.entries, ]
  train <- dtm[-validate.entries, ]
  model <- LDA(train, k = 20, method = "Gibbs", control = list(alpha = x, iter = 1000,
                                                               burnin = 1000, thin = 100,
                                                               verbose = 50))
  perp <- perplexity(model, validate)
  lik <- logLik(model)
  print(paste("Trial:", i, "Alpha:", x, "Perplexity:", perp, "Likelihood:", lik))
  return(list(perp, lik, x))
}

verticalUnlist <- function(index, dat) {
  result <- c()
  for (i in 1:length(dat)) {
    result <- c(result, dat[[i]][[index]])
  }
  return(result)
}

# Cross validate 
cross.validate.lda <- function(x) {
  print(paste("Cross validating... alpha:", x, "Folds:", FOLDS, "Proportion", PROPORTION))
  validate.entries <- sample(nrow(dtm), size = floor(nrow(dtm) * PROPORTION))
  params <- mclapply(seq(1, FOLDS, by = 1), validate.lda, x, validate.entries,
                     mc.silent = FALSE, mc.preschedule = FALSE, 
                     mc.allow.recursive = TRUE)
  return(list(mean(verticalUnlist(1, params)), mean(verticalUnlist(2, params)),
              mean(verticalUnlist(3, params))))
}

seq_grow <- function(start, end, seed, how) {
  # Grow a sequence within a given range with a user defined function
  cnt <- start 
  grow <- seed
  result <- c(start)
  while (cnt <= end) { 
    cnt <- cnt + grow
    result <- c(result, cnt)
    grow <- how(grow)
  }
  result
  }

params <- mclapply(seq_grow(.0001, 1, .0005, function(x) x + x/3), cross.validate.lda, mc.silent = FALSE,
                   mc.preschedule = FALSE, mc.allow.recursive = TRUE)

results <- data.frame(perplexity = verticalUnlist(1, params),
                      likelihood = verticalUnlist(2, params),
                      alpha = verticalUnlist(3, params))

optimal <- which.min(results$perplexity)

print("Optimal values:")
print(results[optimal,])

end <- proc.time()
print(paste("Elapsed", end - start))

save(results, file = "alpha_cv_results3.RData")