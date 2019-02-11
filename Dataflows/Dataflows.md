# MS Power BI Dataflows - Public Preview
###### by [Scott Sugar](https://linkedin.com/in/scottsugar)

You've built a few Power BI reports based on data from your CRM/ERP, and you may have noticed a few issues along the way.  One of those issues is the duplication of data retreival across the various Power BI reports.  A common example of this is your customer records - your Sales report, and your Quality of Service report, and almost all your other reports are pulling in your list of clients from your CRM/ERP backend.  This isn't a big problem while creating your first few reports, but what happens as you continue to develop additional reports?, or as you enable self-serve reporting for your colleagues?  If you continue to scale up the number of reports you have, you may have so many duplicate data pulls that the performance of your CRM/ERP is impacted.

Another issue is consistency.  If you have multiple reports pulling your client list (or your sales transactions) at different times of the day, or in a slightly different way, will the data be consistent across all your reports?  Confidence in reports is diminished when inconsistencies are discovered.

Yet another issue is maintainability, if you migrate or upgrade your CRM/ERP, you may have to update every report.

The traditional solution to these problems is to have "staged" data utilizing a data lake (structured & unstructured data) and/or a data warehouse (structured data) as your central data repository, your "single source of truth" from which all reports pull data.  For many SMEs this is the ideal solution, but perceived and actual costs of creating, managing, and securing a data lake/warehouse are oten an impediment to getting to this level of sophistication.

Power BI Dataflows helps bridge that gap, allowing you to retreive and schedule retrieval of data utilizing the familiar Power BI "Get Data" interface, and store it in a data lake (Azure Data Lake Storage) accessible by Power BI without the complexity of setting up, managing, or securing a data lake. 

### Some benefits of using MS Power BI Dataflows
* Enable team collaboration while building your organizations data retrieval and preparation processes.
* Eliminate duplication of data retreival processes ensuring data retreival has a minimal and consistent impact on your data sources.
* Provide a consistent "single source of truth" to build reports and visualizations on top of across your organization.

### Warning: Still in Public Preview
At the time of writing this article (Feb, 2019) Power BI Dataflows functionality is still in Public Preview, which means that functionality could be added or removed prior to release to General Availability.  This is not recommended for production usage at this time.

Click [here](https://powerbi.microsoft.com/en-us/blog/introducing-power-bi-data-prep-wtih-dataflows/) for the official Microsoft introduction blog posting for Power BI Dataflows which also contains information on some of the advanced functionality available within Power BI dataflows - linked entities, and computed entities.

### Deciding if Power BI Dataflows is Right For You
Here are a few questions to help you decide if MS Power BI Dataflows is the right move for your organization:
* Do you have multiple reports retreiving the same data (sales report, quality of service report both retreiving client data)
* Do you want to present a unified and consistent 'single source of truth' to enable self-serve reporting?
* Do you want to have multiple team members collaborate on the retreival and preparation of data.

If you answered yes to any of the above, then MS Power BI Dataflows is the right option for you.

---
**Note**

As of Feb 2019, Power BI Dataflows is still in Public Preview, and therefore should not be used in production until General Availability is released.

---

### Get Started with MS Power BI Dataflows Today
If your answers to the questions in the decision points above lead you to believe that Power BI Dataflows is right for your organization, or if you just want to learn more about Power BI Dataflows, [drop us a line today](mailto:cloud@proserveit.com?Subject=I%20Want%20To%20Learn%20More%20About%20Power%20BI%20Dataflows). Our team of Data & Analytics experts will be happy to schedule a demo or a tutorial session.