# Monitoring and Auto-Healing Kafka-Connect with PowerShell on Windows
###### by [Scott Sugar](https://linkedin.com/in/scottsugar)

[Kafka-Connect](https://www.confluent.io/product/confluent-connectors) is part of the larger [Apache Kafka](https://kafka.apache.org/) ecosystem.  Here at ProServeIT, we typically run Kafka using [Confluent Cloud on Azure](https://www.confluent.io/azure).  While there are a variety of [fully managed Confluent connectors](https://docs.confluent.io/cloud/current/connectors/index.html) that allow for data acquisition into Confluent's fully managed Kafka instances, there are some situations where [self-managed connectors](https://docs.confluent.io/home/connect/supported.html) are required (either due to security requirements, or because a fully managed connector doesn't yet exist).  In those cases, you'll often need to run Kafka-Connect yourself, and monitoring and management of the self-managed connectors becomes your task to ensure that your real-time streams of data stay up and running.

### Monitoring and Auto-Healing

Monitoring and Auto-Healing is done with a PowerShell script (see the PowerShell Scripts and Setup/Usage Info section below).  This checks on the connectors task status every 5 minutes.  If a connectors task is in a FAILED state, the script will attempt to restart the task.  In some situations this will fix the issue, but not all situations.  The PowerShell script will also log each connectors task status to Azure Log Analytics so Alerts can be created to quickly notify your team of a failed connector task.

### Running this as a Windows Service

We also provide a script to install the monitoring and auto-healing script as a windows service.  This will allow for the task status check and auto-heal to run without user intervention.  

### PowerShell Scripts and Setup/Usage Info

The PowerShell scripts and setup/usage information is available [here](https://github.com/ssugar/kafka-connect-monitoring).

### Get Started with Confluent or Kafka
If you've been tasked with streaming real-time data for reporting or other purposes, please [drop us a line today](mailto:cloud@proserveit.com?Subject=Confluent%20Cloud%20on%20Azure). Our team of Data & Analytics experts will be happy to review your situation together.