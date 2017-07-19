## lesson 5

install.packages('ggplot2', dependencies = T) 

library(ggplot2)

setwd('E:/MOOC/udacity/Data Analysis With R/eda-course-materials/lesson3')
pf <- read.csv('pseudo_facebook.tsv',sep='\t')
names(pf)

## ggplot syntax to plot two variables

ggplot(aes(x=age,y=friend_count),data =pf) +
  geom_point(alpha=1/20)+
  xlim(13,90)+
  coord_trans(y="sqrt")


# Examine the relationship between friendships_initiated (y) and age (x)
# using the ggplot syntax.

ggplot(aes(x=age,y=friendships_initiated),data=pf)+
  geom_point(alpha=1/20,position =position_jitter(height =(0)))+
  xlim(13,90)+
  coord_trans(y="sqrt")


install.packages('dplyr')
library(dplyr)

##Group pseudo fb data by age

age_groups <- group_by(pf,age)

##summarize the above dataframe

pf.fc_by_age <- summarise(age_groups,
                          friend_count_mean = mean(friend_count),
                          friend_count_median = median(friend_count),
                          n= n())

##Arrange the above created dataframe

pf.fc_by_age <- arrange(pf.fc_by_age,age)

tail(pf.fc_by_age)

##plot a graph between avg friend count and age.

ggplot(aes(x=age,y=friend_count_mean),data = pf.fc_by_age) +
  geom_line()

##Overlaying summaries with raw data

pf.s <- ggplot(aes(x=age,y=friend_count),data=pf)+
  xlim(13,90)+
  geom_point(alpha=0.05,position=position_jitter(h=0),color='orange')+
  coord_trans(y='sqrt')+
  geom_line(stat='summary',fun.y=mean)