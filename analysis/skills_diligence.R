toc <- read.csv("toc.csv")

# Use this to examine the frequency of some order's associated talent skills
# We expect to have some skills with > 1 occurences
index <- 20
example.skills <- factor(unlist(strsplit(as.character(toc[index,3]), ' ')))
toc[index,]
table(example.skills)[table(example.skills) > 1]

# Check for skill
example.skills[example.skills == 'micro']
