# Data Visualization : Visualising Pakistan Drone Attacks

## Summary 
The United States has targeted militants in the Federally Administered Tribal Areas [FATA] and the province of Khyber Pakhtunkhwa [KPK] in Pakistan via its Predator and Reaper drone strikes since year 2004. Pakistan Body Count (www.PakistanBodyCount.org) is the oldest and most accurate running tally of drone strikes in Pakistan. The dateset used in this visualization project provides the count of the people killed and injured in drone strikes, including the ones who died later in hospitals or homes due to injuries caused or aggravated by drone strikes, making it the most authentic source for drone related data in this region.

## Design

- As the dataset represents the attacks over time, I chose **Connected Scatter Plot** to visualize parameters like number of drone strikes, number of terrorists killed and the number of civilian casualties over a year timeline. The connected scatter plots are perfect representation choice for time series data because they allow user to the spot the relationship between the successive data points.

- A **Bar Plot** to represent the total number of attacks carried out in each province and city, as bar graphs are the best representation choice for catergorical data visualization.

- A **Color Themed Bar Plot** over a year timeline to highlight the relationship b/w the president's tenure and the number of attacks carried out.

## Feedback

#### Reader 1

- Your visualization has many connected scatter plots, it would be difficult for the end user to understand the relationship b/w the various variables until you specify proper titles and axis lables for your charts, so add required titles to convey the specific message.

#### Reader 2

- Use different colors to represent the lines and dots. Make sure you use light colors for the line and high contrast colors for the dots,   as it would be asthetically pleasing for the end user to easily pick up the data points.

#### Reader 3.

- Sort the bars of a bar plot in the increasing/decreasing order to represent the trend b/w various categories. 
- Add a lengend to your tenure analysis graph to highlight the values of tenure variable.

## Data

- `attacks.csv` : This tiny dataset which has around 400 rows contains information about drone attacks carried out on pakistan soil for fight aganist terrorism. This dataset is obtained from the website kaggle.



