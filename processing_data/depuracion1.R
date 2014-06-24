# depuracion 1

# completar con datos de easyshare


load("tempData/share_def2.RData")

load("../an_longitudinal/data/easyshare.RData")
tmp <- easyshare[,c("id_across_wave","sphus","chronic_mod","casp",
						  "adla","iadlza")]


share  <- merge(share.def2,tmp,by="id_across_wave")

share.clean <- share
rm(share)

table(share.clean$mh002_)

for (i in 2:9){
	print( table(share.clean[,paste0("mh00",i,"_")], share.clean[,"id_ola"]))
}


for (i in 10:17){
	print( table(share.clean[,paste0("mh0",i,"_")], share.clean[,"id_ola"]))
}

mh2 <- ifelse(as.numeric(share.clean$mh002_)==3,1,0)
mh3 <- ifelse(as.numeric(share.clean$mh003_)==3,1,0)
mh4 <- ifelse(as.numeric(share.clean$mh004_)==3 |as.numeric(share.clean$mh004_)==5 ,1,0)

mh5 <- ifelse(as.numeric(share.clean$mh005_)==3  ,1,0)
mh7 <- ifelse(as.numeric(share.clean$mh007_)==3  ,1,0)
mh8 <- ifelse(as.numeric(share.clean$mh008_)==3  ,1,0)

mh10 <- ifelse(as.numeric(share.clean$mh010_)==3  ,1,0)
mh11 <- ifelse(as.numeric(share.clean$mh011_)==3  ,1,0)
mh13 <- ifelse(as.numeric(share.clean$mh013_)==3  ,1,0)

mh14 <- ifelse(as.numeric(share.clean$mh014_)==3 | as.numeric(share.clean$mh014_)==5  ,1,0)
mh15 <- ifelse(as.numeric(share.clean$mh015_)==3 | as.numeric(share.clean$mh015_)==5  ,1,0)
mh16 <- ifelse(as.numeric(share.clean$mh016_)==3  ,1,0)
mh17 <- ifelse(as.numeric(share.clean$mh017_)==3  ,1,0)

# como hay NAS, los convierto a 0 y sumo
# creo lista (más fácil hubiera sido pasarlo a data.frame)

tmp <- data.frame(mh2, mh3, mh4,mh5, mh7, mh8 , mh10 , mh11 , mh13 , mh14 , mh15 , mh16 ,mh17)
for(i in 1:ncol(tmp)){
	perdidos <- is.na(tmp[,i])
	tmp[perdidos,i]<-0
}

share.clean$mh.count <- apply(tmp,1,sum)
share.clean$mh.presencia <- ifelse(share.clean$mh.count>0,1,0)

save(share.clean,file="tempData/share_def3.RData")
