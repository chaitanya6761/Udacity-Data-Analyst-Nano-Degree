##lesson 3

install.packages('ggplot2', dependencies = T) 

library(ggplot2)

setwd('E:/MOOC/udacity/Data Analysis With R/eda-course-materials/lesson3')
pf <- read.csv('pseudo_facebook.tsv',sep='\t')
names(pf)


## Ploting of dob
ggplot(aes(x=dob_day),data=pf)+
  geom_histogram(binwidth = 1)+
  scale_x_continuous(breaks = 1:31)

##ploting of dob by month using facet
ggplot(aes(x=dob_day),data=pf) +
  geom_histogram(binwidth = 1) +
  scale_x_continuous(breaks = 1:31)+
  facet_wrap(~dob_month)


##Histogram of friend count
ggplot(aes(x=friend_count),data=pf)+
  geom_histogram()


##Limiting the values on x axis
ggplot(aes(x = friend_count), data=pf)+
  geom_histogram()+
  scale_x_continuous(limits = c(0,1000))

##Setting the binwidth and scaling the x_axis
ggplot(aes(x=friend_count),data=pf)+
  geom_histogram(binwidth = 25)+
  scale_x_continuous(limits=c(1,1000),breaks = seq(0,1000,50))

##Faceting friend_count Histogram by gender
ggplot(aes(x=friend_count),data=pf)+
  geom_histogram(binwidth = 25)+
  scale_x_continuous(limits=c(1,1000),breaks = seq(0,1000,50))+
  facet_wrap(~gender)

##Removing the NA values
ggplot(aes(x=friend_count),data=subset(pf,!is.na(gender)))+
  geom_histogram(binwidth = 25)+
  scale_x_continuous(limits=c(1,1000),breaks = seq(0,1000,50))+
  facet_wrap(~gender)


##Statistics by gender
table(pf$gender)

by(pf$friend_count,pf$gender,summary)


##Plotting tenure using color and fill parameters
ggplot(aes(x=tenure/365),data=pf)+
  geom_histogram(binwidth = .25,color='black',fill='#F79420')

##Labeling Plots
ggplot(aes(x=tenure/365),data=pf)+
  geom_histogram(binwidth = .25,color='black',fill='#F79420')+
  scale_x_continuous(breaks = seq(0,7,1),limits = c(0,7))+
  labs(title='Years',x='Number of Years',y='Number Of users in Sample')



##Plotting Ages
ggplot(aes(x=age),data=pf)+
  geom_histogram(binwidth = 1,fill='#F79420')+
  scale_x_continuous(breaks=seq(0,115,5))

##Plot Using Log Scale nd Grid

install.packages('gridExtra')
library(gridExtra)

p1 <- ggplot(aes(x=friend_count),data=pf)+
  geom_histogram()

p2 <- p1 + scale_x_log10() 

p3 <- p1 + scale_x_sqrt()

grid.arrange(p1,p2,p3)


#frequency ploygon
ggplot(aes(x=friend_count,y=..count../sum(..count..)),data=subset(pf, !is.na(gender)))+
  geom_freqpoly(aes(color=gender),binwidth=10)+
  labs(title='men v/s women friend_count',x='friend_count',y='proportion of users with that friend count')+
  scale_x_continuous(limits=c(0,1000),breaks=seq(0,1000,50))


ggplot(aes(x=friend_count,y=..density..),data=subset(pf, !is.na(gender)))+
  geom_freqpoly(aes(color=gender),binwidth=10)+
  labs(title='men v/s women friend_count',x='friend_count',y='proportion of users with that friend count')+
  scale_x_continuous(limits=c(0,1000),breaks=seq(0,1000,50))


ggplot(aes(x=www_likes),data=subset(pf,!is.na(gender)))+
  geom_freqpoly(aes(color=gender))+
  scale_x_log10()

by(pf$www_likes,pf$gender,summary)


ggplot(aes(x=gender,y=friendships_initiated),data=subset(pf,!is.na(gender)))+
  geom_boxplot()+
  coord_cartesian(ylim=c(0,250))
  

by(pf$friendships_initiated,pf$gender,summary)


#Converting a value to binary

summary(pf$mobile_likes)

summary(pf$mobile_likes > 0)


mobile_check_in <- NA

pf$mobile_check_in <- ifelse(pf$mobile_likes > 0 ,1,0)

pf$mobile_check_in <- factor(pf$mobile_check_in)

table(pf$mobile_check_in)

sum(pf$mobile_check_in==1) / length(pf$mobile_check_in)












