# Gibbs cross-validation 1-fold (assumes stable results).

start <- proc.time()
# Determine topic number by cross validating on perplexity
library(tm)
library(doMC)
library(topicmodels)

dat <- read.csv("toc.csv")
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

print("Order DTM:")
print(dtm)

# Setup CV
options("mc.cores" = 16)
FOLDS <- 1
PROPORTION <- 0.1
control <- list(alpha = .01, verbose = 50, keep = 1, iter = 200)

validate.lda <- function(i, x, validate.entries) {
  validate <- dtm[validate.entries, ]
  train <- dtm[-validate.entries, ]
  model <- LDA(train, k = x, method = "gibbs", control = control)
  
  perp <- perplexity(model, validate)
  lik <- logLik(model)
  alpha <- model@alpha
  iter <- model@iter
  
  print(paste("Cross Validation for", x, "topics run", i, ". Alpha:", alpha, "Likelihood:", lik,
              "Perplexity:", perp, "Iterations:", iter))
  print("----")
  
  return(list(alpha, lik, perp, iter))
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
  print(paste("Cross validating... Topics:", x, "Folds:", FOLDS, "Proportion", PROPORTION))
  validate.entries <- sample(SAMPLE, size = floor(SAMPLE * PROPORTION))
  params <- mclapply(seq(1, FOLDS, by = 1), validate.lda, x, validate.entries,
                     mc.silent = FALSE, mc.preschedule = FALSE, 
                     mc.allow.recursive = TRUE)
  
  alpha <- mean(verticalUnlist(1, params))
  lik <- mean(verticalUnlist(2, params))
  perp <- mean(verticalUnlist(3, params))
  iter <- mean(verticalUnlist(4, params))
  
  print(paste("Cross Validation for", x, "topics complete. Alpha:", alpha, "Likelihood:", lik,
              "Perplexity:", perp, "Iterations:", iter))
  print("----")
  
  return(list(alpha, lik, perp, iter))
}

params <- mclapply(seq(2, 21, 1)^2, cross.validate.lda, mc.silent = FALSE,
                   mc.preschedule = FALSE, mc.allow.recursive = TRUE)

results <- data.frame(alpha = verticalUnlist(1, params), 
                      likelihood = verticalUnlist(2, params),
                      perplexity = verticalUnlist(3, params), 
                      iterations = verticalUnlist(4, params))

optimal <- which.min(results$perplexity)

print("Optimal values:")
print(results[optimal,])

end <- proc.time()
print(paste("Elapsed", end - start))

save(results, file = "full_model_cv_results2.RData")
