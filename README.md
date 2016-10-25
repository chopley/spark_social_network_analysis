# spark_social_network_analysis
Example of spark social network analysis using Spark

Install Neo4J (see https://neo4j.com/)
Install Zeppelin 0.5.6 
(https://zeppelin.apache.org/download.html zeppelin-0.5.6-incubating-bin-all.tgz)

You will need to modify the following in the Zeppelin interpreter
spark.driver.maxResultSize	4g
spark.executor.memory	10g
spark.serializer	org.apache.spark.serializer.KryoSerializer
zeppelin.driver.memory	8g


