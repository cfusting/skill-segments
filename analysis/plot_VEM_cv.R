library(ggplot2)
load("cv/full_model_cv_results.RData")
results$skill_segments <- seq(2, 120, 10)
ggplot(results, aes(x = skill_segments, y = perplexity)) + geom_line(color = "blue") +
  labs(title = "VEM CV")
ggplot(results, aes(x = skill_segments, y = alpha)) + geom_line(color = "red") +
  labs(title = "VEM CV")
