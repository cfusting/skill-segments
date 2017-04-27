library(ggplot2)

load("gibbs/gibbs_full_models.RData")
load("talent_predict/posterior.RData")
model <- models[[2]]

# Market niches
topic.mass <- apply(model@gamma, 2, sum) / length(model@documents)
talent.topic.mass <- apply(post$topics, 2, sum) / nrow(post$topics)

# Print Design Light Web
pdlw.topics <- c(38, 77, 79)
pdlw <- topic.mass[pdlw.topics]
pdlw.talent <- talent.topic.mass[pdlw.topics]
pdlw.frame <- data.frame(Skill_Segment = pdlw.topics, Probability = pdlw,
           Niche = rep("Print Branding Light Web", length(pdlw)))
pdlw.talent.frame <- data.frame(Skill_Segment = pdlw.topics, Probability = pdlw.talent,
                                Niche = rep("Print Branding Light Web", length(pdlw)))

# Social Media Writer
smw.topics <- c(83, 55)
smw <- topic.mass[smw.topics]
smw.talent <- talent.topic.mass[smw.topics]
smw.frame <- data.frame(Skill_Segment = smw.topics, Probability = smw,
          Niche = rep("Social Media Writer", length(smw)))
smw.talent.frame <- data.frame(Skill_Segment = smw.topics, Probability = smw.talent,
                        Niche = rep("Social Media Writer", length(smw)))

df <- rbind(pdlw.frame, smw.frame)
df.talent <- rbind(pdlw.talent.frame, smw.talent.frame)

ggplot(df, aes(x = Skill_Segment, y = Probability)) + geom_bar(stat = "Identity", col = "green",
  alpha = I(.5)) + facet_wrap(~ Niche) + 
  labs(title = "Skill-Segement Probabilities in Market Niche Over Orders", x = "Skill-Segment")

ggplot(df.talent, aes(x = Skill_Segment, y = Probability)) + geom_bar(stat = "Identity", 
  col = "green", alpha = I(.5)) + facet_wrap(~ Niche) + 
  labs(title = "Skill-Segement Probabilities in Market Niche Over Talent", x = "Skill-Segment")

df.ag <- aggregate(x = df$Probability, FUN = sum, by = list(Niche = df$Niche))
colnames(df.ag)[2] <- "Probability"
df.ag$Entity <- "Order"
df.talent.ag <- aggregate(x = df.talent$Probability, FUN = sum, by = list(Niche = df.talent$Niche))
colnames(df.talent.ag)[2] <- "Probability"
df.talent.ag$Entity <- "Talent"

qplot(x = Niche, y = Probability, data = df.ag, geom = "bar", stat = "Identity",  
      alpha = I(0.5), col = Niche, xlab = "Market Niche", 
      main = "Market Niche Probability Over Orders", size = I(1.5))

qplot(Niche, Probability, data = df.talent.ag, geom = "bar", stat = "Identity",  
      alpha = I(0.5), col = Niche, xlab = "Market Niche", 
      main = "Talent Market Niche Probability Over Talent", size = I(1.5))

df.ag.both <- rbind(df.ag, df.talent.ag)

ggplot(df.ag.both, aes(x = Niche, y = Probability, col = Niche)) +
  geom_bar(stat = "Identity", alpha = I(.5), size = I(1.5)) + facet_wrap(~ Entity) + 
  labs(title = "Skill-Segement Probabilities in Market Niche", x = "Skill-Segment")