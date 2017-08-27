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

ggplot(aes(x=age,y=mean_friend_count),data=pf.fc_by_age_gender)+
  geom_line(aes(color=gender))


# Reshaping the data
install.packages('tidyr')
library(tidyr)

pf.fc_by_age_gender.wide <- spread(subset(pf.fc_by_age_gender,
                                          select=c(age,gender,median_friend_count)),
                                   gender,median_friend_count)

pf.fc_by_age_gender.wide




pf.fc_by_age_gender.wide <-
  subset(pf.fc_by_age_gender[c('age', 'gender', 'median_friend_count')],
         !is.na(gender)) %>%
  spread(gender, median_friend_count) %>%
  mutate(ratio = male / female)

head(pf.fc_by_age_gender.wide)

# Plot the ratio of the female to male median friend counts using the 
#data frame pf.fc_by_age_gender.wide.
ggplot(aes(x=age,y=female/male),data=pf.fc_by_age_gender.wide)+
  geom_line()+
  geom_hline(yintercept = 1,color='red',linetype=2,size=1)


# Create a variable called year_joined in the pf data frame using the variable
# tenure and 2014 as the reference year.

pf$year_joined <- floor(2014 - (pf$tenure/365))

table(pf$year_joined)

# Create a new variable in the data frame called year_joined.bucket by using 
#the cut function on the variable year_joined.

pf$year_joined_bucket <- cut(pf$year_joined,c(2004,2009,2011,2012,2014))

table(pf$year_joined_bucket)
 

ggplot(aes(x = age, y = friend_count),
       data = subset(pf, !is.na(year_joined_bucket))) +
  geom_line(aes(color = year_joined_bucket), stat = 'summary', fun.y = mean)+
  geom_line(stat='summary',fun.y=mean,linetype=2)


