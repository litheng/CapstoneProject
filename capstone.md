Data Science Capstone Project: Yelp Business Checkin Data Analysis
========================================================
author: Chia LT
date: 14 Nov 2015
css: style.css
transition: rotate

Introduction
========================================================
type: blue
Using the [Yelp](http://www.yelp.com/) dataset provided, this analysis attempts to uncover the types of businesses that are most popular across the different countries/states within the dataset.  Popularity here is broadly defined by the number of checkins garnered by each business as it represents the number of customers of that business.

The outcome of the analysis attempts to provide an insight into what are the popular types of businesses and whether there is difference across the different states.

Methodology
========================================================
type: blue
The methods used in this analysis include the following:
- Aggregation of checkins by business ids
- Wordcloud based on category terms of businesses falling in the 95th percentile
- Identification of top 3 types of businesses with most checkins
- Box plots of businesses by top business types and by states
- Anova test on the top business types against the state which the business is located

Box Plot
========================================================
type: small-code
The following shows the box plot of checkin count by state

```r
library(robustbase); library(RColorBrewer); load("data/bustype.RData")
adjbox(checkin_count~state, data=bustype, main=("Checkin Count by State"),
  ylab="No. of Checkins", font.lab=3, col=brewer.pal(12,"Set3"), log="y")
```

![plot of chunk plot_boxplot](capstone-figure/plot_boxplot-1.png) 

Conclusion
========================================================
type: blue
The analysis shows that the top 3 business types with highest checkin count are Restaurants, Bars and Hotels.  In addition, there is a strong relation between checkin count and the type of business and the state it is in.  For e.g. businesses in Arizona and Nevada garner much more checkins than other states.  Further analysis is performed on which are the top businesses by region/country and their associated categories and attributes.
<div>Please access <img style="background-color:transparent; border:0px; box-shadow:none; height:100px; vertical-align:middle" src="icon_checkin.png"/><a href="https://miny.shinyapps.io/yelp_app">Yelp Shiny App</a> to view the analysis output.</div>
