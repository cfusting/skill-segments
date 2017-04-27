# Compute the entropy of the topic distributions 
load("gibbs/gibbs_full_models.RData")
model <- models[[2]]
topic.ent <- apply(model@beta, 1, function(x) -sum(exp(x) * x))

# Display min skill-segments
topic.ent.s <- sort(topic.ent, index.return = TRUE)
terms(model, 10)[,topic.ent.s$ix[1]]
terms(model, 20)[,topic.ent.s$ix[90]]
terms(model, 10)[,topic.ent.s$ix[3]]

# Order topics by entropy
write.table(terms(model, 20)[, topic.ent.s$ix], file = "gibbs_topics_90.csv", quote = FALSE, 
            sep = ",", row.names = FALSE)

# Topic Mass - Proportion of topics in training corpus
topic.mass <- apply(model@gamma, 2, sum) / length(model@documents)
topic.mass.s <- sort(topic.mass, index.return = TRUE)

# Topics tend to have less entropy the more massive they are
plot(topic.mass, topic.ent)
