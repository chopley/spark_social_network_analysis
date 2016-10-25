# spark_social_network_analysis
Example of spark social network analysis using Spark

##Install Neo4J 
See https://neo4j.com/

##Install Zeppelin 0.5.6 
https://zeppelin.apache.org/download.html Use file zeppelin-0.5.6-incubating-bin-all.tgz
You will need to modify the following in the Zeppelin interpreter
spark.driver.maxResultSize	4g
spark.executor.memory	10g
spark.serializer	org.apache.spark.serializer.KryoSerializer
zeppelin.driver.memory	8g

##Data description
Anonymised social network from the 

National Longitudinal Study of Adolescent Health, or Add Health (Udry 2003; Harris, Florey,
Tabor, Bearman, Jones, and Udry 2003) by a process described in the Appendix. We call this rm -rf ./graph

1. rm -rf graph.db
2. ../neo4j-community-3.0.4/bin/neo4j-import  --into  ./graph --nodes:men "nodeHeaderGender.txt,nodes_male.csv/part-00000" --nodes:women "nodeHeaderGender.txt,nodes_female.csv/part-00000" --relationships:knows "edgeHeader.txt,edges.csv/part-00000"
3. ../neo4j-community-3.0.4/bin/neo4j stop
4. rm -rv ../neo4j-community-3.0.4/data/databases/graph.db
5. cp -rv graph ../neo4j-community-3.0.4/data/databases/graph.db
6. ../neo4j-community-3.0.4/bin/neo4j restart
