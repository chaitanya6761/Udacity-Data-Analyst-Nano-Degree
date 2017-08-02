library(ggplot2)

setwd('E:/MOOC/udacity/Data Analysis With R/eda-course-materials/lesson3')
pf <- read.csv('pseudo_facebook.tsv',sep='\t')
names(pf)

##Median Friend_count by age and gender

ggplot(aes(x=age,y=friend_count),data=subset(pf,!is.na(gender)))+
  geom_line(aes(color=gender),stat='summary',fun.y=medain)


# Write code to create a new data frame, called 'pf.fc_by_age_gender', that contains information on 
#each age AND gender group.

groups_by_age_gender <- group_by(subset(pf,!is.na(gender)),age,gender)

pf.fc_by_age_gender <- summarise(groups_by_age_gender,
                                 mean_friend_count = mean(friend_count),
                                 median_friend_count = median(friend_count),
                                 n = n())
pf.fc_by_age_gender <- arrange(pf.fc_by_age_gender,age,gender)
