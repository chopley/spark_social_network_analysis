# Analysing social network data using Apache Spark and Graphframes 

Example of spark social network analysis using Spark

##Install Neo4J 
https://neo4j.com/download/community-edition/
neo4j-community-3.0.4

You will need to modify the file

*neo4j-community-3.0.4/conf/neo4j.conf*

Ensure that the correct database file is used by modifying the appropriate line to reflect below:

*dbms.active_database=graph.db*

##Install Apache Zeppelin 0.5.6 
The example in this repo were tested using Apache Zeppelin 0.5.6 

The download location is 
*https://zeppelin.apache.org/download.html* You should use the binary file located at *zeppelin-0.5.6-incubating-bin-all.tgz*

You will need to modify the following in the Zeppelin interpreter

- spark.driver.maxResultSize	4g
- spark.executor.memory	10g
- spark.serializer	org.apache.spark.serializer.KryoSerializer
- zeppelin.driver.memory	8g

The *spark\_zeppelin\_social\_network\_analysis.json* file contains the Apache Zeppelin notebook appropriate for this example.

##Data description
The data are an anonymised data set from the *Statnet* *R* package. The data are a simulation based on the *National Longitudinal Study of Adolescent Health  (Harris, Florey,
Tabor, Bearman, Jones, and Udry 2003)*. 

The anonymisation is described in *A Statnet Tutorial (Goodreau, Handcock, Hunter, Butts and Morris ), Journal of Statistical Software, February 2008, Volume 24* 
https://www.jstatsoft.org/article/view/v024i09. 

The data were extracted using the R script *network\_data\_simulation.R*. Running this script will produce the following files

1. networkEdges.csv
2. raceNodes.csv
3. sexNodes.csv
4. gradeNodes.csv

These are all included in the *Github* repo.

### Spark Social Network Preparation



### Neo4J data importation
After the social network data are created by the Apache Spark process the can be imported into Neo4J.

This can be done using the native Neo4J language Cypher, however since the audience for this tutorial are likely to be interested in large data bulk loading I give an example using the *neo4j-import* bulk-loader.

First we remove any remnants of the graph in the current directory (in case you have run the graph importation previously)

```
rm -rf ./graph
```
The next step is to import the data itself. For this we need the data files (both node information and edge information) as well as data file schema.

The *nodeHeaderGender.txt* can be extracted from the files produced in the Apache Spark process.  Assuming the header line is still present in the csv files, this can be accomplished in a using *sed* as follows:


```
sed -n 1p nodes_male.csv/part-00000 >> nodeHeaderGender.txt
```

We also need to remove the header files from the individual data files themselves. In this example there is only a single file in each csv folder (owing to the coalesce(1) command) , however in real data analysis there will be a csv file produced for each partition in the Spark process--- this would typically mean thousands of files making removal of the header files very tedious. A useful command to deal with this is to change into the respective csv folders and use *sed* to remove the first line from each file in the folder as follows

```
cd nodes_male.csv
for i in $( ls * ); do sed -i '1d' $i; done

cd ../nodes_female.csv
for i in $( ls * ); do sed -i '1d' $i; done

```
Next we import the data into a Neo4J database. In the example below the files look as follows:

```
```

```
../neo4j-community-3.0.4/bin/neo4j-import  --into  ./graph --nodes:men "nodeHeaderGender.txt,nodes_male.csv/part-00000" --nodes:women "nodeHeaderGender.txt,nodes_female.csv/part-00000" --relationships:knows "edgeHeader.txt,edges.csv/part-00000"
```

We need to stop the Neo4J database before removing the old database and importing the new database.

```
../neo4j-community-3.0.4/bin/neo4j stop
```

```
rm -rv ../neo4j-community-3.0.4/data/databases/graph.db
cp -rv graph ../neo4j-community-3.0.4/data/databases/graph.db
../neo4j-community-3.0.4/bin/neo4j restart
```
