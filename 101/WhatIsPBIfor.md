# 101 - What is Power BI for?
###### by [Scott Sugar](https://linkedin.com/in/scottsugar)

I recently spoke with a colleague that had completed a Power BI [Dashboard In A Day](https://powerbi.microsoft.com/en-us/diad/) course, and during their post-training research they ran into terms like Data Warehouse and Data Lake, and wondered how it all fit together.  The training course taught them how to build a dashboard in a day - connect into data, clean/transform it, visualize it, and publish it - all within Power BI.  So where did these other systems fit in?

From there, we discussed what I find are the two ways to leverage Power BI
1. A drag-and-drop reporting application that sits on top of other data systems
2. A full end-to-end data orchestration and analysis system

Within the first way, you would typically leverage some combination of: a [Data Orchestration]() tool, possibly a [Data Lake](), then [dimensionally model]() your data for loading into a [Data Warehouse](), pre-analyze and load your data into an [in-memory table](), and potentially integrate other [AI/ML]() systems - all in order to extract, clean, transform, and load your data such that Power BI simply sits on top providing you a nice way to create visualizations/reports and most importantly Power BI Online provides a *secure* way to share your reports with other users in your organization that integrates easily with other O365 systems ([SharePoint](), [Teams]()).  

As for the second way to leverage Power BI - a full end-to-end data analysis system. The [Dashboard In A Day](https://powerbi.microsoft.com/en-us/diad/) training sessions clearly show that Power BI is fully capable of connecting directly into hundreds of data sources, cleaning and modeling that data with [M/Power Query](), creating complex relationships between data sources, and even integration of some basic [AI] functionality - all within Power BI Desktop (which is free!).  Power BI Online then provides the *secure* way to share your reports with other users in your organization and schedule automatic refreshes of those reports.  So essentially, Power BI is capable of performing all the extracting, cleaning and logic that a [Data Orchestration]() plus [Data Warehouse]() system would normally be programmed to do.

Despite being extremely capable, I find there are some short-comings of using Power BI as a full end-to-end data orchestration and analysis system.  The main issues are:
1. Scalability - copy/pasting logic between reports is ok with 5-10 reports, but becomes unmanageable when you get to dozens or hundreds of reports.
2. Consistency - different reports will be refreshed on different schedules, and may clean or transform data in a different ways.  Another way to say this is that there is no single source of truth. 
3. Collaboration - Power BI files are [binary]() files.  This means that two (or more) BI developers can't simultaneously work on the same Power BI report and then merge their respective changes into a single file.

The above limitations are overcome by adding in a [Data Orchestration]() tool, and [dimensionally modeling]() your data for loading into a [Data Warehouse]() that acts as the single source of truth for the organization.

So how do I recommend using Power BI?  My belief is that there is a hybrid approach that acknowledges the best practices laid out by [Kimball and Ross]() and leverages the technologies laid out in Microsoft's [Modern Data Warehouse Architecture]() guide in order to build a robust BI/DW system, while also understanding that building and configuring those technologies takes time and money.  So a multi-stream approach which uses Power BI as a rapid exploration and development tool and then productionizes the logic and analyses into [data pipelines]() and [conformed dimension]() and [fact]() tables in a [Data Warehouse]().  This accelerates value to the report consumers, while still allowing an organization to iteratively build a robust single source of truth.

So How do you use Power BI?  Let us know in the comments, or [drop us a line today](mailto:cloud@proserveit.com?Subject=I%20Want%20To%20Learn%20More%20About%20Power%20BI%20Solutions). Our team of Data & Analytics experts will be happy to schedule a demo or a tutorial session.