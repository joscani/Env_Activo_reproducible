# unir ola1 y ola2
load("tempData/ola1.RData")
load("tempData/ola2.RData")
ola1$id_ola <- 1
ola2$id_ola <- 2
ola1_2 <- rbind(ola1,ola2)
names(ola1_2)



# The variable waveid indicates when an individual entered SHARE. All
# household members present in wave 1 have a wave 1 waveid. In case a
# new person moves in a wave 1 household after wave 1, she or he gets a
# wave 2 waveid, because the first wave she or he is included in the
# coverscreen is wave 2. Waveid takes the following values corresponding to
# the following wave/questionnaire version:
#   “42”, “51”: referring to wave 1
#   “61”, “62”, “64”: referring to wave 2

table(ola1$waveid)
table(ola2$waveid)

if(!file.exists("tempData")){
	dir.create("tempData")
}

if(!file.exists("tempData/ola1_2.RData")){
	save(ola1_2,file="tempData/ola1_2.RData")
}
rm(list=ls())


