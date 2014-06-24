# depuracion 1

# completar con datos de easyshare


load("tempData/share_def2.RData")

load("../an_longitudinal/data/easyshare.RData")

###################################
# Cargo easyshare con las variables que quiero unir
tmp <- easyshare[,c("id_across_wave","sphus","chronic_mod","casp",
						  "adla","iadlza","mar_stat","eduyears_mod")]


# uno 
share  <- merge(share.clean,tmp,by="id_across_wave")

# lo llamo share.clean
share.clean <- share
rm(share)

share.clean$mar_stat <- droplevels(share.clean$mar_stat)
Encoding(levels(share.clean$mar_stat)) <- "latin1"
share.clean$eduyears_mod[share.clean$eduyears_mod<0] <- NA 

share.clean <- subset(share.clean, is.na(iv020_))

##################################
# Crear variable incapacidad , que vale 1 si contesta al menos un 1 en las p006d
# son la ph006d1, ph006d4, ph006d5, ph006d6, ph006d10, ph006d12, ph006d14 

# crear variables que valen 1 si hace actividad y 0 si no
share.clean$incap1 <- ifelse(share.clean$ph006d1=="selected",1,0 )
share.clean$incap4 <- ifelse(share.clean$ph006d4=="selected",1,0 )
share.clean$incap5 <- ifelse(share.clean$ph006d5=="selected",1,0 )

share.clean$incap6 <- ifelse(share.clean$ph006d6=="selected",1,0 )
share.clean$incap10 <- ifelse(share.clean$ph006d10=="selected",1,0 )

share.clean$incap12 <- ifelse(share.clean$ph006d12=="selected",1,0 )
share.clean$incap14 <- ifelse(share.clean$ph006d14=="selected",1,0 )

share.clean$n.incap <- with(share.clean, incap1 + incap4 + incap5 + incap6 +
								  	incap10 + incap12 + incap14)
share.clean$incapacidad <- as.factor(ifelse(share.clean$n.incap>=1,"incap_SI","incap_NO"))

share.clean$age[share.clean$age<0] <- NA
share.clean$gender[share.clean$gender=="0. male"]<- "male"
share.clean$gender[share.clean$gender=="1. female"]<- "female"
share.clean$gender <- droplevels(share.clean$gender)

##############################################################




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
