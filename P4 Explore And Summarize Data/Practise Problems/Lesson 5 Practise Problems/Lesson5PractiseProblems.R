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
  coord_trans(y='sqrt')

## Adding Mean geom Line

pf.m <- pf.s + geom_line(stat='summary',fun.y=mean)
pf.m

## Adding 10% and 90% quantile

pf.q <- pf.m + geom_line(stat = 'summary',fun.y=quantile,fun.args = list(probs = .9),linetype=2,color='blue')
pf.q

## Adding median the 50% mark line

pf.med <- pf.q + geom_line(stat = 'summary',fun.y='quantile',fun.args = list(probs=.5),color='blue')
pf.med


## Correlation 

cor.test(pf$age,pf$friend_count)

with(pf,cor.test(age,friend_count))


## Correlation on subsets

with(subset(pf,age<=70),cor.test(age,friend_count))


## create a scatter Plot between likes_received (y) vs. www_likes_received (x).

ggplot(aes(www_likes_received,likes_received),data = pf)+
  geom_point()

## Create a scatter plot for above graph with 95% quantile
ggplot(aes(www_likes_received,likes_received),data = pf)+
  geom_point()+
  xlim(0,quantile(pf$www_likes_received,0.95))+
  ylim(0,quantile(pf$likes_received,0.95))+
  geom_smooth(method='lm',color='red')

with(pf,cor.test(www_likes_received,likes_received))


##Caution with correlation
install.packages('alr3')
library(alr3)

data("Mitchell")
names(Mitchell)

# Create a scatterplot of temperature (Temp) vs. months (Month).

ggplot(aes(x=Month,y=Temp),data=Mitchell)+
  geom_point()

with(Mitchell,cor.test(Temp,Month))

ggplot(aes(x=Month,y=Temp),data=Mitchell)+
  geom_point()+
  scale_x_continuous(breaks = seq(0,204,12))


## Calculate age in months
pf$age_with_months <- pf$age + (1 - pf$dob_month / 12)

##Create data groups using age with months variable

age_groups_months <- group_by(pf,age_with_months) 

pf.fc_by_age_months <- summarise(age_groups_months,
                                 friend_count_mean = mean(friend_count),
                                 friend_count_median = median(friend_count),
                                 n = n())

pf.fc_by_age_months <- arrange(pf.fc_by_age_months, age_with_months)
head(pf.fc_by_age_months) 


# Create a new line plot showing friend_count_mean versus the new variable,
# age_with_months. Be sure to use the correct data frame (the one you created
# in the last exercise) AND subset the data to investigate users with ages less
# than 71.

ggplot(aes(x=age_with_months,y=friend_count_mean),
  data=subset(pf.fc_by_age_months,age_with_months < 71))+
  geom_line()+
  geom_smooth()




