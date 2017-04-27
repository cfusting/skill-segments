# Consider skill-segment similarity 
library(ggplot2)
library(topicmodels)

load("gibbs/gibbs_full_models.RData")
model <- models[[2]]

# Get the topic similarities
topic.sim <- distHellinger(exp(model@beta))
image(1:90, 1:90, topic.sim, col = rev(heat.colors(100)), main = "Skill-Segment Similarity",
      xlab = "Skill-Segment", ylab = "Skill-Segment")

# Compare a topic with the rest
TOPIC <- 83
terms(model, 20)[, TOPIC]
topic.sim.s <- sort(topic.sim[, TOPIC], index.return = TRUE)
terms(model, 20)[, topic.sim.s$ix[2]]

qplot(x = 1:90, y = topic.sim.s$x, col = I("red"), main = paste("Similarity Relative to", 
                                                                "Skill-Segment",
                                                                TOPIC), 
      xlab = "Sorted Skill-Segments", ylab = "Hellinger Distance")