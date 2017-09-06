# Let's consider the price of a diamond and it's carat weight.
# Create a scatterplot of price (y) vs carat weight (x).install.packages('ggplot2')

library(ggplot2)
data(diamonds)

#Create a scatterplot of price (y) vs carat weight (x).
ggplot(aes(x=carat,y=price),data=diamonds)+
  geom_point()+
  xlim(0,quantile(diamonds$carat,0.99))+
  ylim(0,quantile(diamonds$price,0.99))+
  geom_smooth(color='red')


#ggpairs function
install.packages('GGally')
install.packages('scales')
install.packages('memisc')
install.packages('lattice')
install.packages('MASS')
install.packages('car')

library(GGally)
library(scales)
library(memisc)
library(lattice)
library(MASS)
library(car)

set.seed(2000)

diamond_samp <- diamonds[sample(1:length(diamonds$price),10000),]

ggpairs(diamond_samp)

# Create two histograms of the price variable and place them side by side on one output image.

# The first plot should be a histogram of price and the second plot should transform
# the price variable using log10.

library(gridExtra)

plot1 <- ggplot(aes(x=price),data=diamonds)+
  geom_histogram()+
  ggtitle('Price')

plot2 <- ggplot(aes(x=log10(price)),data=diamonds)+
  geom_histogram()+
  ggtitle('Price (log10)')

grid.arrange(plot1,plot2)


# Add a layer to adjust the features of the scatterplot. Set the transparency to one half,
# the size to three-fourths, and jitter the points.

?diamonds

cuberoot_trans = function() trans_new('cuberoot',
                                         transform = function(x) x^(1/3),
                                         inverse = function(x) x^3)


ggplot(aes(carat, price), data = diamonds) + 
  geom_point(alpha=0.5,size=0.5,position = 'jitter') + 
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat')



# Adjust the code below to color the points by clarity.
# A layer called scale_color_brewer() has been added to adjust the legend and provide custom colors.

library(RColorBrewer)

ggplot(aes(x = carat, y = price,color=clarity), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div',
                     guide = guide_legend(title = 'Clarity', reverse = T,
                                          override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Clarity')


# Adjust the code below to color the points by cut.Change any other parts of the code as needed.

ggplot(aes(x = carat, y = price, color = cut), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div',
                     guide = guide_legend(title = 'Clarity', reverse = T,
                                          override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and cut')






