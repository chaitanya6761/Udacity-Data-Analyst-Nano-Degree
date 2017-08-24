library(ggplot2)
library(dplyr)

setwd('F:/chaitanya/eda-course-materials/lesson3')
pf <- read.csv('pseudo_facebook.tsv',sep='\t')
names(pf)


# BoxPlots of ages by gender

ggplot(aes(x=gender,y=age),data=subset(pf,!is.na(gender)))+
  geom_boxplot()+
  stat_summary(fun.y = mean,geom='point',shape=4)


#Third Qualitative Variable

ggplot(aes(x=age,y=friend_count),data=subset(pf,!is.na(gender)))+
  geom_line(aes(color=gender),fun.y=median,stat='summary')

# Write code to create a new data frame, called 'pf.fc_by_age_gender', that 
#contains information on each age AND gender group.

groups_by_age_gender <- group_by(subset(pf,!is.na(gender)),age,gender)

pf.fc_by_age_gender <- summarise(groups_by_age_gender,
                                 mean_friend_count = mean(friend_count),
                                 median_friend_count = median(friend_count),
                                 n = n())

pf.fc_by_age_gender <- arrange(pf.fc_by_age_gender,age,gender)


# Create a line graph showing the median friend count over the ages for each gender. 
#Be sure to use the data frame you just created,pf.fc_by_age_gender.

ggplot(aes(x=age,y=median_friend_count),data=pf.fc_by_age_gender)+
  geom_line(aes(color=gender))








 