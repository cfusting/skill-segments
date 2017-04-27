library(ggplot2)
load("cv/alpha_cv_results3.RData")
results <- results
ggplot(results, aes(x = log(alpha), y = perplexity)) + geom_line(color = "red") +
  labs(title = "Gibbs CV 20 skill-segments")
