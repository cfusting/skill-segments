# Cross-Validate the VEM LDA models using perplexity on hold out data on
# the topic number.
#
# In practice each model can take up to ~10 GB of ram to process => 32 cores
# will require ~320 GB at any given time. This script was run on an r3.8xlarge EC2
# instance on Amazon's cloud using run.sh. The entire workspace image is saved into
# the current directory but this can be optimized to suite the user's needs (for
# example one could simply save the dataframe of output data).
#
# NOTE: Gibbs sampling is much faster and is preffered.

start <- proc.time()

# Determine topic number by cross validating on perplexity
library(tm)
library(doMC)
library(topicmodels)

# Example of a run using the full data set
# Comment in SAMPLE related code to try a small subset on a local workstation
#SAMPLE <- 50

dat <- read.csv("toc.csv")
#sam <- sample(nrow(toc), size = SAMPLE)
#dat <- toc[sam,]

# Remove orders with no skills or high candidate numbers
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)

# For the full data set SAMPLE must be set to the total number of observations
SAMPLE <- nrow(dat)

#dat <- read.csv("dat.csv")
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")
skills <- DataframeSource(skills.frame)
skill.corpus <- VCorpus(skills)
dtm <- DocumentTermMatrix(skill.corpus)
# Remove terms that appear only once
terms.once <- findFreqTerms(dtm, 1, 1)
terms.once.index <- which(dtm$dimnames[[2]] %in% terms.once)
dtm <- dtm[, -terms.once.index]
print("Order DTM:")
print(dtm)

# Setup CV
options("mc.cores" = 16)
FOLDS <- 10
PROPORTION <- 0.1
MIN.K <- 122
MAX.K <- 222
INTERVAL.K <- 10
control <- list()

validate.lda <- function(i, x, validate.entries) {
  validate <- dtm[validate.entries, ]
  train <- dtm[-validate.entries, ]
  model <- LDA(train, k = x, control = control)
  
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

params <- mclapply(seq(MIN.K, MAX.K, by = INTERVAL.K), cross.validate.lda, mc.silent = FALSE,
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
