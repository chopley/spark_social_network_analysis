# spark_social_network_analysis
Example of spark social network analysis using Spark

##Install Neo4J 
See https://neo4j.com/

##Install Zeppelin 0.5.6 
https://zeppelin.apache.org/download.html Use file zeppelin-0.5.6-incubating-bin-all.tgz
You will need to modify the following in the Zeppelin interpreter

- spark.driver.maxResultSize	4g
- spark.executor.memory	10g
- spark.serializer	org.apache.spark.serializer.KryoSerializer
- zeppelin.driver.memory	8g

##Data description
The data are an anonymised data set from the Statnet package. This is based on the National Longitudinal Study of Adolescent Health  (Harris, Florey,
Tabor, Bearman, Jones, and Udry 2003). The anonymisation is described in A statnet Tutorial (Goodreau, Handcock, Hunter, Butts and Morris ),Journal of Statistical Software,February 2008, Volume 24 
https://www.jstatsoft.org/article/view/v024i09. The data were extracted using the R script network_data_simulation.R producing the following output files
1. networkEdges.csv
2. raceNodes.csv
3. sexNodes.csv
4. gradeNodes.csv

```
rm -rf graph.db
../neo4j-community-3.0.4/bin/neo4j-import  --into  ./graph --nodes:men "nodeHeaderGender.txt,nodes_male.csv/part-00000" --nodes:women "nodeHeaderGender.txt,nodes_female.csv/part-00000" --relationships:knows "edgeHeader.txt,edges.csv/part-00000"
../neo4j-community-3.0.4/bin/neo4j stop
rm -rv ../neo4j-community-3.0.4/data/databases/graph.db
cp -rv graph ../neo4j-community-3.0.4/data/databases/graph.db
../neo4j-community-3.0.4/bin/neo4j restart
```
