# Evaluate the probability of skill-segments being in our corpus of orders
library(ggplot2)

load("gibbs/gibbs_full_models.RData")
model <- models[[2]]

# Topic Mass - Proportion of topics in training corpus
topic.mass <- apply(model@gamma, 2, sum) / length(model@documents)
topic.mass.s <- sort(topic.mass, index.return = TRUE, decreasing = TRUE)

# Topic Entropy - How certain a topic is about its terms
topic.ent <- apply(model@beta, 1, function(x) -sum(exp(x) * x))
topic.ent.s <- sort(topic.ent, index.return = TRUE)

# Topics tend to have less entropy the more massive they are
qplot(x = topic.ent, y = topic.mass, ylab = "Mass", geom = "point",
      alpha = I(1), col = I("red"), main = "Skill-Segment Mass and Entropy", 
      xlab = "Entropy")

# Plot of the topic mass distribution
qplot(x = 1:90, y = topic.mass, ylab = "Probability", geom = "bar", stat = "identity", 
      alpha = I(.2), col = I("blue"), main = "Probability of Skill-Segments in Orders", 
      xlab = "Skill-Segment")