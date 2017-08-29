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
 
# Create a line graph of friend_count vs. age so that each year_joined.bucket 
# is a line tracking the median user friend_count across age. This means you 
# should have four different lines on your plot.

ggplot(aes(x = age, y = friend_count),
       data = subset(pf, !is.na(year_joined_bucket))) +
  geom_line(aes(color = year_joined_bucket), stat = 'summary', fun.y = median)

# Write code to do the following:
# (1) Add another geom_line to code below to plot the grand mean of the friend count vs age.
# (2) Exclude any users whose year_joined.bucket is NA.
# (3) Use a different line type for the grand mean.

ggplot(aes(x = age, y = friend_count),
       data = subset(pf, !is.na(year_joined_bucket))) +
  geom_line(aes(color = year_joined_bucket), stat = 'summary', fun.y = mean)+
  geom_line(stat='summary',fun.y=mean,linetype=2)


#Friending Rate

with(subset(pf,tenure>0),summary(friend_count/tenure))

# Create a line graph of mean of friendships_initiated per day (of tenure)
# vs. tenure colored by year_joined.bucket.

ggplot(aes(x=tenure,y=friendships_initiated/tenure),data=subset(pf,tenure>0))+
  geom_line(aes(color=year_joined_bucket),stat='summary',fun.y=mean)

# Instead of geom_line(), use geom_smooth() to add a smoother to the plot.
# You can use the defaults for geom_smooth() but do color the line
# by year_joined.bucket

ggplot(aes(x = 7 * round(tenure / 7), y = friendships_initiated / tenure),
 data = subset(pf, tenure > 0)) +
 geom_smooth(aes(color = year_joined_bucket))












