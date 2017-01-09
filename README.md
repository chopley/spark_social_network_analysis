# Analysing social network data using Apache Spark and Graphframes 

Example of spark social network analysis using Spark. This was run on a MacBook Pro with 16GB RAM.

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

Start the notebook as follows:

```
cd ~/Documents/zeppelin-0.5.6-incubating-bin-all/
./bin/zeppelin-daemon.sh start
```
The Zeppelin notebook can be found here:

*http://localhost:8080/#/*

The interpreter can be found here:

*http://localhost:8080/#/interpreter*

And a status page can be found here

*http://localhost:4040/jobs/*


You will need to modify the following in the Zeppelin interpreter

- spark.driver.maxResultSize	4g
- spark.executor.memory	10g
- spark.serializer	org.apache.spark.serializer.KryoSerializer
- zeppelin.driver.memory	8g

The *spark\_zeppelin\_social\_network\_analysis.json* file contains the Apache Zeppelin notebook appropriate for this example. This can be imported through the front page of the Zeppelin Browser and then loaded.

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

This can be done using the native Neo4J language *Cypher*, however since the audience for this tutorial are likely to be interested in large data bulk loading I use the *neo4j-import* bulk-loader.

First we remove any remnants of the graph in the current directory (in case you have run the graph importation previously)

```
rm -rf ./graph
```
The next step is to import the data itself. For this we need the data files (both node information and edge information) as well as data file schema.

The schema can be extracted from the files produced in the Apache Spark process.  Assuming the header line is still present in the csv files, this can be accomplished in a using *sed* as follows:


```
sed -n 1p nodes_male.csv/part-00000 >> nodeHeaderGender.txt
```
This produces a new file containing the header line from 


```
nodes_male.csv/part-00000
```

Minor modification will need to be done to the file in order to correctly index it during the *Neo4J* importation process. This involves adding the *:ID* flag to the index (or ID) column.

The header file will need to change as 

```
UserId,Gender,Grade,Race,Gender_homophilly,Grade_homophilly,Race_homophilly,Label,Pagerank
```

to

```
UserId:ID,Gender,Grade,Race,Gender_homophilly,Grade_homophilly,Race_homophilly,Label,Pagerank
```

the edge header file needs to be of the following form
```
:START_ID,:END_ID,count

```

We also need to remove the header files from the individual data files themselves. In real data analysis, the csv files in the folder will record the data from each Spark partition ---typically thousands of files--- making removal of the header files very tedious. 

A useful command to deal with this is to change into the respective csv folders and use *sed* to remove the first line from each file in the folder as follows

First in the folder associated with the male nodes

```
cd nodes_male.csv
for i in $( ls * ); do sed -i '1d' $i; done
```

Next in the folder containing the csv files associated with the female nodes.

```
cd ../nodes_female.csv
for i in $( ls * ); do sed -i '1d' $i; done

```
and now the edges files

```
cd ../edges.csv
for i in $( ls * ); do sed -i '1d' $i; done

```
Now all the files in the folders above will have had the first lines removed from them.

Next we import the data into a Neo4J database. 

The Neo4J bulk loader is awfully useful in allowing files to be read using regular expressions. 

Typically the output of writing to text file using Spark will result in a number of files labelled

```
part-00000, part-00001, part-00002 ...
```

Below I provide an example of using Regular expressions to import all the files matching this pattern from a given folder.

```
../neo4j-community-3.0.4/bin/neo4j-import  --into  ./graph --nodes:men "nodeHeaderGender.txt,nodes_male.csv/part-[0-9]{5}" --nodes:women "nodeHeaderGender.txt,nodes_female.csv/part-[0-9]{5}" --relationships:knows "edgeHeader.txt,edges.csv/part-[0-9]{5}"
```
You can expect the following if successful

```
IMPORT DONE in 2s 868ms. Imported:
  1461 nodes
  0 relationships
  13149 properties
```

We need to stop the Neo4J database before removing the old database and importing the new database.

```
../neo4j-community-3.0.4/bin/neo4j stop
```

Remove the existing graph database from the Neo4J installation

```
rm -rv ../neo4j-community-3.0.4/data/databases/graph.db
```

And now copy the newly created graph from the bulk-import process into the appropriate location in the Neo4J installation

```
cp -rv graph ../neo4j-community-3.0.4/data/databases/graph.db
```
And finally restart the Neo4J server

```
../neo4j-community-3.0.4/bin/neo4j restart
```

The Neo4J server can be access at

*http://localhost:7474/browser/*


