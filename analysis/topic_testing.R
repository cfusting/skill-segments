# Analysis of gibbs models with different numbers of topics
library(topicmodels)
library(tm)
library(ggplot2)

load("gibbs/gibbs_topic_testing.RData")

calculateOrderEntropy <- function(model) {
  apply(model@gamma, 1, function(x) -sum(x * log(x)))
}

# Evaluate entropy over orders
order.ents <- lapply(models, calculateOrderEntropy)
DOCS <- length(order.ents[[1]])

buildDataFrame <- function(x, ss, ents) {
  data.frame(Skill_segment = rep(ss[x], length(ents[[x]])), Entropy = ents[[x]])
}
dfs <- lapply(1:length(order.ents), buildDataFrame, as.character(seq(20, 80, 10)), order.ents)
df.order.ents <- do.call("rbind", dfs)
order.ents.mean <- lapply(order.ents, mean)

ggplot(df.order.ents, aes(x = df.order.ents$Entropy, y = ..count.., 
                          colour = df.order.ents$Skill_segment)) +
  geom_density(alpha = .3, position = "dodge") + labs(title = "Order Entropy Density", 
                                                      x = "Entropy",
                                                      colour = "Model", 
                                                      y = "Count") +
  geom_vline(xintercept = unlist(order.ents.mean), linetype = "longdash")

df <- data.frame(skill_segment = seq(20, 80, 10), order_entropy = unlist(order.ents.mean))

# Evaluate entropy over topics
calculateSkillSegmentEntropy <- function(model) {
  apply(model@beta, 1, function(x) -sum(exp(x) * x))
}

ss.ents <- lapply(models, calculateSkillSegmentEntropy)
dfs <- lapply(1:length(ss.ents), buildDataFrame, as.character(seq(20, 80, 10)), ss.ents)
df.ss.ents <- do.call("rbind", dfs)

ggplot(df.ss.ents, aes(y = df.ss.ents$Entropy, x = df.ss.ents$Skill_segment, 
                       fill = df.ss.ents$Skill_segment)) +
  geom_boxplot() + labs(title = "Skill-Segment Entropy", x = "Number of Skill-Segments",
                                    fill = "Model", y = "Entropy")

# Build the skill-segment spreadsheets

buildSkillSegmentTable <- function(model) {
  terms <- terms(model, 20)  
  ent <- apply(model@beta, 1, function(x) -sum(exp(x) * x))
  dist <- distHellinger(exp(model@beta))
  dist.s <- apply(dist, 1, function(x) sort(x, index.return = TRUE)$ix[2:4])
  mass <- apply(model@gamma, 2, sum) / length(model@documents)
  ss.table <- rbind(terms, ent, mass, dist.s)
  ent.s <- sort(ent, index.return = TRUE)
  rownames(ss.table)[1:20] <- "Terms" 
  rownames(ss.table)[21] <- "Entropy" 
  rownames(ss.table)[22] <- "Mass" 
  rownames(ss.table)[23] <- "Nearest Topic 1" 
  rownames(ss.table)[24] <- "Nearest Topic 2" 
  rownames(ss.table)[25] <- "Nearest Topic 3" 
  return(ss.table[, ent.s$ix])
}

tables <- lapply(models, buildSkillSegmentTable)
lapply(tables, function(x) write.table(x, file = paste("skill_segments_", ncol(x), ".csv",
                                                       sep = ""), 
                                       quote = FALSE, sep = ",",
                                       col.names = NA))
