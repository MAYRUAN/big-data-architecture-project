# Project Summary

## Implementation Overview

Summarize the end-to-end project in your own words.

Describe the dataset, the purpose of the pipeline, and how the major technologies work together:

**Source Data → NiFi → HDFS → Hive → Spark MLlib → HBase**

Spark execution is submitted through **YARN**.

## Dataset

**Dataset name:** branch_growth    
**GitHub direct URL:** https://raw.githubusercontent.com/MAYRUAN/big-data-architecture-project/refs/heads/main/dsc650-big-data-portfolio-starter-main/sample-data/branch_growth.csv  

Briefly explain what the dataset contains and why it is appropriate for the selected Spark MLlib workflow.  

The branch_growth dataset captures branch-level financial and operational metrics across four attributes: Branch_ID, Region, Ad_Budget_K (advertising budget in thousands), and New_Accnts_Opened (new accounts acquired).  

It is ideal for Spark MLlib workflows—specifically linear or polynomial regression—for the following reasons:  

**Clear Feature-Target Relationship:** Ad_Budget_K serves as a direct numeric predictor, while New_Accnts_Opened is a continuous target variable suitable for predictive modeling.  
**Categorical Feature Engineering:** The Region attribute provides an ideal field for Spark MLlib feature pipelines, such as string indexing (StringIndexer) and one-hot encoding (OneHotEncoder), to evaluate localized growth patterns.  
**Distributed Scalability:** The structured, numeric-heavy schema translates cleanly into Spark VectorAssembler pipelines, demonstrating end-to-end feature extraction and model training across a distributed cluster.  

## Environment Setup

Document the supporting environment configuration required by the project.

Explain why the required Python libraries (for example, `numpy` and `happybase`) are needed and why the HBase Thrift server must be running for the Spark-to-HBase portion of the pipeline.

**Required Python Libraries**  

**happybase:** Acts as the Python client interface for HBase, enabling direct connection, table creation, and record insertion via standard Python syntax.  

**numpy:** Supplies high-performance numerical data structures and underlying array handling required by downstream analytical pipelines and PySpark transformations.  

**Role of the HBase Thrift Server**  
HBase is built natively in Java and communicates via custom Java RPCs. The Thrift server acts as a cross-language API gateway (listening on port 9090) that translates non-Java Python/happybase calls into native HBase operations. It must be running for PySpark drivers and scripts to establish connections and write streaming/batch data to HBase tables.  


### Package Installation Evidence

![Package Installation](screenshots/package-installation.png)

### HBase Thrift Server Evidence

![HBase Thrift Server](screenshots/hbase-thrift-server.png)

## What Worked

Summarize the major portions of the pipeline that executed successfully.

**Data Ingestion & Hive Storage:** Raw branch performance data was successfully ingested via NiFi to HDFS and structured into the branch_growth Hive table for SQL-based querying.  
**Spark Cluster Execution:** The PySpark job (sparkml.py) submitted cleanly via spark-submit to YARN, properly allocating containers across worker nodes.  
**Data Preprocessing & Feature Engineering:** PySpark handled data cleaning by dropping null records (growth_df.na.drop()) and vectorized Ad_Budget_K into input feature arrays using VectorAssembler.  
**Model Training & Evaluation:** A LinearRegression model successfully trained on a 70/30 split, outputting high-accuracy evaluation metrics ($R^2 \approx 0.9394$, $RMSE \approx 3.8134$).  
**HBase Metric Persistence & Verification:** Spark executors successfully opened Thrift client connections during foreachPartition to write evaluation metrics to branch_growth_metrics, as verified by a scan in the HBase shell.  

## Issues & Challenges Encountered

Describe the most meaningful technical problems encountered while building the project.

Challenges: Resolving Script and Execution Errors During Pipeline Development

For each important challenge, explain:

1. What happened?  
  Unexpected errors occurred during code execution and script execution while connecting Spark MLlib transformations to downstream storage targets.  
2. How you investigated it?  
   Analyzed raw terminal execution logs and stack traces, then cross-referenced error messages against external online technical resources, class documentation, and rewatched the walkthrough video.  
3. What you changed or fixed?  
   Refined Python script logic to handle dataframe schema constraints cleanly and corrected partition-level execution code to allow Spark executors to write outputs smoothly. Rerun the command in the terminal to fix errors.  
4. What you learned from the issue.  
   Developing strong end-to-end troubleshooting habits—isolating errors using log output and leveraging technical documentation—is essential for resolving integration issues across distributed big data systems.  


## Results

Summarize the final technical results, including the successful movement of data through the pipeline and the machine learning results produced by Spark MLlib.

**Pipeline Data Movement**  
**Ingestion & Storage:** Raw branch growth data flowed seamlessly through Apache NiFi into HDFS, where it was structured into the branch_growth Hive table.  
**Processing & Analytics:** PySpark queried Hive (SELECT Ad_Budget_K, New_Accnts_Opened), cleaned missing entries (growth_df.na.drop()), and vectorized input attributes via VectorAssembler.  
**Persistence & Verification:** Using foreachPartition, Spark executors wrote the final performance outputs to the branch_growth_metrics HBase table, which was verified with the HBase shell scan command.  

**Spark MLlib Model Results**  
**R-Squared ($R^2$):** 0.9393862497926574 ($\approx 0.9394$)  
**Root Mean Squared Error (RMSE):** 3.8133770876014292 ($\approx 3.8134$)  
**Predictive Performance:** The LinearRegression model demonstrated an exceptionally high goodness of fit, explaining approximately 93.94% of the variance in new account openings with respect to advertising expenditure (Ad_Budget_K), with an average prediction error of only 3.81 accounts.  


## Lessons Learned

Describe the most important technical lessons gained from integrating multiple distributed services in one environment.  

Integrating multiple distributed services highlights that pipeline success relies on managing data formats and network handoffs across distinct architectures, rather than viewing individual tools in isolation.  
Writing to external storage, such as HBase, from Spark requires partition-aware execution, such as foreachPartition, to prevent network bottlenecks and connection pool exhaustion across worker nodes.  
Stable execution requires a firm grasp of how YARN orchestrates resources, allocating memory overhead and driver or executor containers across the cluster.  
Finally, diagnosing failures in complex environments depends on analyzing logs across every layer—from YARN and Spark down to HBase—while embedding defensive data preparation to maintain end-to-end pipeline resilience.  
 

## Production Considerations

Explain what you would change if this architecture were being deployed as a production system.  

Possible areas to consider include:

- security and authentication;
- high availability;
- observability and monitoring;
- resource sizing;
- automation and CI/CD;
- data governance;
- secrets management;
- scalability and fault tolerance.

Transitioning this architecture into a production-grade system requires moving from a local, client-mode sandbox to an enterprise enterprise data platform focused on security, automation, and reliability.

**Production Architecture Upgrades**

**Orchestration & CI/CD:** Replace manual spark-submit executions with Apache Airflow to automate pipeline scheduling, dependency management, and automated retries. Deploy code through automated CI/CD pipelines to ensure consistent testing and deployment.  

**Security & Secrets Management:** Implement Kerberos authentication across all cluster services and migrate sensitive connection strings from scripts to a centralized vault, such as HashiCorp Vault, to enforce secure access controls.  

**High Availability & Fault Tolerance:** Run Spark in Cluster Mode rather than Client Mode so the driver runs redundantly inside YARN containers. Configure active-standby NameNodes and ResourceManagers using Apache ZooKeeper to remove single points of failure.  

**Observability & Monitoring:** Integrate Prometheus and Grafana to track Spark executor health, memory overhead, and HBase throughput in real time, setting up automated alerts for pipeline failures.  


