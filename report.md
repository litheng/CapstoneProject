# Data Science Capstone: Milestone Report
by Chia LT  




## Introduction
This report forms part of the submission for the Coursera Data Science Capstone module.  Using the Yelp dataset provided, this report describes the analysis performed to uncover the types of businesses that are most popular across the different countries/states within the dataset.  Popularity is broadly defined by the number of checkins garnered by each business as it represents the number of customers of that business.  The outcome of the analysis attempts to provide an insight into what are the potential types of businesses that are popular and whether there is difference across the different states.

A [Yelp Shiny App](https://miny.shinyapps.io/yelp_app) has been created to supplement this report and all codes used in this analysis can be found on [Github](http://example.com) repo.


## Data
### Exploring the Data
The Yelp dataset contains a total of 5 files: Business, Checkin, Review, Tip and User.  For the purpose of this analysis, only the first 2 files are used.  The preprocessing codes can be found in the prepare.R file.


It is observed that the "categories" column in the Business dataset contains terms that describes the type of each business while the "attributes"" column shows a list of features/facilities tagged to each business.  These columns would potentially be useful when analysing the top businesses.  The Checkin dataset contains primarily the checkin count for each day of the week and each hour of the day.


### Reshaping the Checkin Data
In order to determine the number of checkins per business, there is a need to transpose the checkins for each business as the checkin count is broken down into periods.  A histogram is then plotted based on the checkin data.
![](Figs/resahape_checkin_data-1.png) 
The histogram shows that the checkin count for majority of the businesses are less than 1000.

### Combining Business and Checkin Data
The checkin data is then combined with the business data, which provides the name, state, categories and attributes.


```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     3.0    12.0    32.0   138.1   104.0 62650.0
```

![](Figs/combine_business_checkin_data-1.png) 
The map shows that the locations of the businesses in the dataset are spread over 4 countries: Canada, Germany, UK and US.

![](Figs/plot_distribution_chart-1.png) 
The distribution chart shows that in most states, the checkins for businesses are positively skewed with star ratings between 3 and 4. It also shows that there are more businesses in Nevada(NV) state in US and the number of checkins and reviews of those businesses are much higher.

## Methods
## Identifying the Top Businesses
To identify which are the most popular businesses (defined by number of checkins), the 95th percentile of the checkin count is calculated.  Businesses with checkin count above this quantile are selected.
  

```
## 95% 
## 548
```

```
##              business_id checkin_count
## 1 jf67Z1pnwElRSXllpQHiJg         62646
## 2 hW0Ne_HTHEAgGF1rAdmR-g         53707
## 3 AtjsjFzalWqJ7S9DUFQ4bw         23612
## 4 3Q0QQPnHcJuX1DLCL9G9Cg         23576
## 5 JpHE7yhMS5ehA9e8WG_ETg         15479
## 6 34uJtlPnKicSaX1V8_tu1A         15213
##                                       name review_count stars
## 1           McCarran International Airport         2201   3.5
## 2 Phoenix Sky Harbor International Airport         1512   3.5
## 3            The Cosmopolitan of Las Vegas         2510   4.0
## 4  Charlotte Douglas International Airport          983   3.5
## 5                      ARIA Hotel & Casino         2440   3.5
## 6         The Venetian Resort Hotel Casino         2079   4.0
##                                                                                   categories
## 1                                                                  Hotels & Travel, Airports
## 2                                                                  Hotels & Travel, Airports
## 3          Hotels & Travel, Arts & Entertainment, Casinos, Event Planning & Services, Hotels
## 4                                                                  Hotels & Travel, Airports
## 5 Arts & Entertainment, Resorts, Casinos, Event Planning & Services, Hotels & Travel, Hotels
## 6          Hotels & Travel, Arts & Entertainment, Casinos, Event Planning & Services, Hotels
##   state  longitude latitude
## 1    NV -115.15112 36.08634
## 2    AZ -112.00644 33.43475
## 3    NV -115.17464 36.10991
## 4    NC  -80.94504 35.21938
## 5    NV -115.17704 36.10762
## 6    NV -115.16966 36.12119
```
It is noted that the top 5 businesses are either airpors or hotels/casinos, which is not unexpected.

### Creating Categories Word Cloud
To analyse the types of businesses that are most popular, a word cloud is created based on the category terms of the selected businesses.


```
##                        word freq
## restaurants     restaurants 1310
## bars                   bars  603
## food                   food  551
## american           american  429
## nightlife         nightlife  382
## arts                   arts  231
## hotels               hotels  227
## new                     new  224
## entertainment entertainment  217
## shopping           shopping  214
```
From the category terms that are tagged to the top businesses, 3 main business types are identified: Restaurants, Bars and Hotels.  A word cloud for all the category terms tagged to the top businesses is created.

![](Figs/create_word_cloud-1.png) 

## Methods
### Select Top Business Category Types
A subset of the top businesses is created based on the top category terms identified: Restaurants Bars and Hotels.



### Create Box Plot
Box plots are created based on the 3 business types, followed by the 13 states.

![](Figs/create_boxplot-1.png) ![](Figs/create_boxplot-2.png) 
From the first boxplot, it appears that there is no significant difference in the median between bars and restaurants but the median for hotels is lower than the other two types.  The second boxplot shows that the checkin count is obviously higher in some states (like AZ and NV) than the others.

### Analysis of Variance

```
##                Df    Sum Sq  Mean Sq F value Pr(>F)    
## state          15 3.339e+08 22260484   78.20 <2e-16 ***
## type            2 3.133e+07 15662787   55.02 <2e-16 ***
## state:type     22 1.275e+08  5796975   20.36 <2e-16 ***
## Residuals   24916 7.093e+09   284672                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```
## Tables of means
## Grand mean
##          
## 191.1497 
## 
##  state 
##       AZ     BW    EDH ELN FIF    IL KHL  MLN   NC   NV    ON     PA
##      207   8.56   29.6   8   8  54.9   8 21.8  113  355  16.2   83.3
## rep 9259 111.00 1066.0   1   1 288.0   1 67.0 2417 6329 242.0 1557.0
##         QC    SC SCB     WI
##       29.6  45.7   7   65.7
## rep 2383.0 111.0   1 1122.0
## 
##  type 
##      Bar Hotel Restaurant
##      230   297        172
## rep 4795  1521      18640
## 
##  state:type 
##      type
## state Bar  Hotel Restaurant
##   AZ   314  104   191      
##   rep 1589  525  7145      
##   BW     7   12     9      
##   rep   23    9    79      
##   EDH   36   25    27      
##   rep  333   94   639      
##   ELN    8                 
##   rep    1    0     0      
##   FIF         8            
##   rep    0    1     0      
##   IL    76   17    53      
##   rep   58   21   209      
##   KHL               8      
##   rep    0    0     1      
##   MLN   26   22    20      
##   rep   18    7    42      
##   NC   152   56   108      
##   rep  442  153  1822      
##   NV   346  885   308      
##   rep 1300  433  4596      
##   ON    18   15    16      
##   rep   47   11   184      
##   PA    92   61    82      
##   rep  337   63  1157      
##   QC    37   34    28      
##   rep  396  129  1858      
##   SC    59    8    43      
##   rep   23    2    86      
##   SCB         7            
##   rep    0    1     0      
##   WI    81   30    65      
##   rep  228   72   822
```

## Results
From the summary results of the analyis of variance, it is noted that there are individual F-values (and associated p-values) for each of three variables: State, Business Type and interaction between State and Business Type.  The p-value for all variables are < 0.01, which signifies that there is a strong relation between number of checkins and the state which the business is located and the type of business.  The interaction effect between state and business type is also statistically significant, meaning that there is a dependency between the variables.  It is also noted that the means of checkins is a lot higher in AZ or NV than other states and the means of the business types differ from state to state.  For instance, bars in AZ have higher mean checkins than hotels but in NV, its vice versa.

Further analysis is performed on which are the top businesses by region/country and the categories and attributes of these businesses.  To view the analysis, please access the [Yelp Shiny App](https://miny.shinyapps.io/yelp_app).  The first tab of the app lists the total checkin count of the selected region by day as well as the names of the 10 businesses with the highest checkin count in the region. The second tab shows the word clouds for categories and attributes of the top selected percentage of businesses in the selected region.  This allows users to see which are categories of business that are most frequented and their associated attributes, like whether it is good for groups or offers parking lots.

## Discussion
This analysis has taken into account all the states provided.  However, it has been observed that other than businesses in the US, data for the other countries are limited with some having only single digit checkins.  As such, these may potentially be excluded from the analysis and the focus can be on understanding businesses within the US states only, which have much larger sample sizes.

To make the analysis output even more useful, it can be performed by zooming into the cities and even neighhbourhoods which the businesses are located in, as the info is available in the business dataset.
