install.packages('statnet')
library('statnet')
library('csv')
update.packages('statnet')
data("faux.magnolia.high")
fmh <- faux.magnolia.high
fmh
plot(fmh, displayisolates = FALSE, vertex.cex = 0.7)
a<-summary(fmh)
g<-as.matrix.network(fmh,matrix.type='incidence')
bbb <- as.matrix.network.edgelist(fmh)
write.csv(bbb,"networkEdges.csv")

race <- get.vertex.attribute(fmh, "Race")
sex <- get.vertex.attribute(fmh, "Sex")
grade <- get.vertex.attribute(fmh, "Grade")
write.csv(race,"raceNodes.csv")
write.csv(sex,"sexNodes.csv")
write.csv(grade,"gradeNodes.csv")

