# MS Power BI Dataflows
###### by [Scott Sugar](https://linkedin.com/in/scottsugar)

You've built a few Power BI reports based on data from your CRM/ERP, and you've noticed a few things along the way.  One of those things is the duplication of data retreival across the various Power BI reports.  A common example of this is your customer records - Your Sales report, and your Quality of Service report, and almost all your other reports are pulling in your list of clients from your CRM/ERP backend.  This isn't a big problem while creating your first few reports, but what happens as you continue to create additional reports?, or as you provide self-serve reporting to your end-users?  If you continue to scale up the number of reports you have, you may have so many duplicate data pulls that you slow down your CRM/ERP backend.

Another issue is one of consistency.  If you have multiple reports pulling your client list (or your sales transactions) at different times of the day, or in a slightly different way, will the data be consistent across all your reports?

The traditional solution to these problems is to have "staged" data utilizing a data lake (structured & unstructured data) and/or a data warehouse (structured) as your central data repository, your "single source of truth".  For many SMEs this is the ideal solution, but perceived and actual costs of creating, managing, and securing a data lake are oten an impediment to getting to this level of sophistication.

Power BI Dataflows helps bridge that gap, allowing you to retreive and schedule retrieval of data utilizing the familiar Power BI "Get Data" interface, and store it in a data lake (Azure Data Lake Storage) accessible by Power BI without the complexity of setting up, managing, or securing a data lake. 

### So, What are MS Power BI Dataflows?
MS Power BI Embedded is a set of services that allow you to display Power BI reports, dashboards, or just single visualizations within your own application, or even within SharePoint and/or Microsoft Teams.  This means that you can connect to hundreds of Cloud and on-premises data sources within MS Power BI, create appealing and interactive visuals, dashboards, and reports, and then display those within your organizations applications and websites with minimal code and development.

### Different MS Power BI Dataflows Options
There are 3 different SKU series available for MS Power BI Embedded:
* P-series SKU (Premium)
    - mainly for Enterprises that want a full featured Business Intelligence platform.  It is more expensive than the other options.
* EM-series SKU (Embedded)
    - similar to the P-series SKU, but you can't share content via the online Power BI service.  The lower tiers are currently difficult to purchase (requires a volume license agreement).
* A-series SKU (Azure)
    - purchased via an Azure subscription.  Provides flexibile pause, scale-up, and scale-down functionality with no monthly or yearly commitment.  Can only embed within a custom application.

Click [here](https://docs.microsoft.com/en-us/power-bi/developer/embedded-faq#technical) for a full breakdown of the different features available for each SKU series.

### Deciding if Power BI Dataflows is Right For You
Here are a few questions to help you decide if MS Power BI Embedded is the right move for your organization:
* Are you sharing your reports with more than 70 users?
* Are your reports only being viewed at certain times of the day/month/year?
* Do you have a custom application that you'd like your reports to show up in?

If you answered yes to any of the above, then MS Power BI Embedded is the right option for you.

### Get Started with MS Power BI Dataflows Today
If your answers to the questions in the decision points above lead you to believe that Power BI Embedded is right for your organization, or if you just want to learn more about Power BI Embedded, [drop us a line today](mailto:cloud@proserveit.com?Subject=I%20Want%20To%20Learn%20More%20About%20Power%20BI%20Embedded). Our team of Data & Analytics experts will be happy to schedule a demo or a tutorial session.