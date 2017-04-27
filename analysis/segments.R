# Examine overlap between minor-segments and skill-segments
library(ggplot2)
library(reshape2)

dat <- read.csv("data/toc.csv")
dat <- subset(dat, skills != "")
dat <- subset(dat, candidate_number < 20)
seg <- read.csv("data/get_segments.csv")
des <- read.csv("data/segment_descriptions.csv")
load("gibbs/gibbs_full_models.RData")
model <- models[[2]]

# Get the minor-segment for each document. Order is retained.
seg.desc <- merge(seg, des)

# Merge sorts order_id lexicographically after merge and may cause elements to 
# be out of order. Retain order by adding an id column and sorting ascending following
# the merge
dat$id <- 1:nrow(dat)
merged <- merge(dat, seg.desc)
merged <- merged[order(merged$id), ]

# Confirm ordering if you wish
wrong <- 0
for (i in 1:nrow(dat)) {
  if(dat[i, 1] != merged[i, 1]) wrong = wrong + 1
}
wrong

merged$job_type_id <- as.factor(merged$short_description)
fin <- cbind(minor_segment = merged$short_description, as.data.frame(model@gamma))
ag <- aggregate(fin[,2:ncol(fin)], by = list(minor_segment = fin$minor_segment), FUN = "mean")

# Scale the results over skill-segments
ag.scaled <- apply(ag[,2:ncol(ag)], MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))
rownames(ag.scaled) <- ag$minor_segment
colnames(ag.scaled) <- 1:model@k

# Don't scale
ag.noscaled <- as.matrix(ag[,2:ncol(ag)])
rownames(ag.noscaled) <- ag$minor_segment
colnames(ag.noscaled) <- 1:model@k

# Plot the matrix (not scaled)
ag.melt <- melt(ag.noscaled)
ag.melt$Var2 <- as.factor(ag.melt$Var2)

png(filename = "~/Dropbox/consulting/aquent_recruitment/plots/segment_overlap_90.png",
    width = 1500, height = 1500)
ggplot(data = ag.melt, aes(x = Var1, y = Var2, fill = value)) + 
  geom_tile(color = "white", size = 1) +
  scale_fill_gradient2(low = "white", high = "steelblue", 
                       limit = c(min(ag.melt$value), 
                                 max(ag.melt$value)), 
                       name="Mean Probability") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
        axis.text.y = element_text(vjust = .5, size = 12, hjust = 1)) +
  labs(title = "Minor-Segment / Skill-Segment Mass", x = "Minor-Segment",
       y = "Skill-Segment")
dev.off()
