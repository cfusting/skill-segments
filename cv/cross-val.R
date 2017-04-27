# Cross-Validate the VEM LDA models using perplexity on hold out data.
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

# This allows the user to try a sample of the data set first.
# Can be easily adopted to use the full data set
SAMPLE <- 1000
toc <- read.csv("toc.csv")
sam <- sample(nrow(toc), size = SAMPLE)
dat <- toc[sam,]
#dat <- read.csv("dat.csv")
dat$skills <- as.character(dat$skills)
skills.frame <- subset(dat, select="skills")

skills <- DataframeSource(skills.frame)
skill.corpus <- VCorpus(skills)
dtm <- DocumentTermMatrix(skill.corpus)

# Setup CV
options("mc.cores" = 32)
FOLDS <- 10
PROPORTION <- 0.1
MIN.K <- 2
MAX.K <- 100
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
# If using the full data set make sure SAMPLE = nrows(dat)
cross.validate.lda <- function(x) {
  print(paste("Cross validating... Topics:", x, "Folds:", FOLDS, "Proportion", PROPORTION))
  validate.entries <- sample(SAMPLE, size = floor(SAMPLE * PROPORTION))
  params <- mclapply(seq(1, 10, by = 1), validate.lda, x, validate.entries,
                              mc.silent = FALSE, mc.preschedule = FALSE, 
                               mc.allow.recursive = TRUE)
  return(list(mean(verticalUnlist(1, params)), mean(verticalUnlist(2, params)),
              mean(verticalUnlist(3, params)), mean(verticalUnlist(4, params))))
}

params <- mclapply(seq(MIN.K, MAX.K, by = INTERVAL.K), cross.validate.lda, mc.silent = FALSE,
                            mc.preschedule = FALSE, mc.allow.recursive = TRUE)

results <- data.frame(alpha = verticalUnlist(1, params), likelihood = verticalUnlist(2, params),
           perplexity = verticalUnlist(3, params), iterations = verticalUnlist(4, params))

optimal <- which.min(results$perplexity)

print("Optimal values:")
print(results[2,])

end <- proc.time()
print(paste("Elapsed", end - start))

rm(toc)
save.image(file = "results.RData")
