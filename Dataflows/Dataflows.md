# MS Power BI Dataflows
###### by [Scott Sugar](https://linkedin.com/in/scottsugar)

## Problem Statement
When adding a visualization to a report for a field that has lots of items, it can be useful to limit the visualization down to show only the top 5 or top 10 items.  We can do this by using MS Power BI's built in TopN visual level filter as shown here: 
![BuiltInTopN](images/PowerBIBuiltInTopN.png)

Sometimes though, especially when dealing with a field that has a few items with high values, and a lot of items with low values, it can be useful to show the top 5 or top 10 and then aggregate all other items into an "other" category.  While this is not currently (Nov 2018) possible using the built-in TopN functionality, it is asked for quite often, including in the comments of the orginal TopN request on [ideas.powerbi.com](https://ideas.powerbi.com/forums/265200-power-bi-ideas/suggestions/6515731-top-n-filters).  

All that being said, just because this functionality isn't built into MS Power BI, that doesn't mean it's not possible.  With a bit of [DAX](https://docs.microsoft.com/en-us/dax/data-analysis-expressions-dax-reference), we are able to build our own "TopN and Other" functionality into any report.  Follow along with the rest of this article to find out how.

## Solution Walkthrough
To build this solution, we've loaded the example data [US services trade data](exampledata/US-Services-TradeData.csv) into MS Power BI.  No further changes to this data have been made.


### Finished Product
We now have all the measures and the visualization in place, and we are showing the Top N and Other in a bar chart.  To see this in MS Power BI Desktop, I've included the .pbix file [here](https://github.com/ssugar/Blog/raw/master/TopNAndOther/pbix/TopNAndOther.pbix)

### Get Started with MS Power BI Today
There are so many things MS Power BI can do to increase data visibility and improve decision making within your organization. So, let’s recap a few important points about why you need MS Power BI in your organization.

MS Power BI is data import, modeling, and visualization made easier.  It can be a self-service data visualization tool for your end-users, or we can help build reports and dashboards for you.  MS Power BI has desktop and mobile clients - even for Apple Watch - along with web-based dashboards and reports, making your data and KPIs easy to access from any device at any time.

Simply put, MS Power BI is an extremely versatile Business Intelligence platform. If you want to learn more about how to take full advantage of MS Power BI, [drop us a line today](mailto:cloud@proserveit.com?Subject=I%20Want%20To%20Learn%20More%20About%20Power%20BI%20Solutions). Our team of Data & Analytics experts will be happy to schedule a demo or a tutorial session.