# unir ola4 y easyshare(ola4)

library(foreign)
load("rawdata/sharew4.RData")
load("tempData/ola4.RData")
sharew4$gender <- droplevels(sharew4$female)

sharew4$recall_1[sharew4$recall_1==-15] <- NA
sharew4$recall_2[sharew4$recall_2==-15] <- NA

sharew4$cf008tot <- sharew4$recall_1
sharew4$cf016tot <- sharew4$recall_2
sel <- c("gender","cf008tot", "cf016tot")

posicion <- names(sharew4) %in% c("mergeid",sel)

ola4.un <- merge(ola4,sharew4[,posicion], by="mergeid")
ola4 <- ola4.un

# cálculo del índice de cognitive
cogn1 <- ifelse(as.numeric(ola4$cf003_)==3,1,0)
cogn1[is.na(ola4$cf003_)] <- 0

cogn2 <- ifelse(as.numeric(ola4$cf004_)==3,1,0)
cogn2[is.na(ola4$cf004_)] <- 0

cogn3 <- ifelse(as.numeric(ola4$cf005_)==3,1,0)
cogn3[is.na(ola4$cf005_)] <- 0

cogn4 <- ifelse(as.numeric(ola4$cf006_)==3,1,0)
cogn4[is.na(ola4$cf006_)] <- 0

comp1 <- cogn1+cogn2+cogn3+cogn4
comp2 <- with(ola4,cf008tot+cf016tot)
comp2[is.na(comp2)] <- 0

comp3 <- ola4$numeracy
comp3[is.na(comp3)] <- 0
cognitive <- comp1 + comp2 + comp3
cognitive[is.na(cognitive)] <- 0

ola4$cognitive <- cognitive



save(ola4,file="tempData/ola4_new.RData")

ola4$id_ola <- 4
ola4$ac035d8 <- NULL
ola4$ac035d9 <- NULL
ola4$ac035d10 <- NULL

ola4$ac036_8 <- NULL
ola4$ac036_9 <- NULL
ola4$ac036_10 <- NULL

load("tempData/ola1_2.RData")

#renombrar variables ola4 con las que corresponden en ola1_2 
names(ola4)[3:13] <- names(ola1_2)[c(6,9:14,17:20)]

sel <- names(ola1_2) %in% names(ola4)
ola1_2.red <- ola1_2[,sel]


share.def <- rbind(ola1_2.red,ola4)


share.def$id_across_wave <- paste(share.def$mergeid,share.def$id_ola,sep="_")

library(foreign)
share <- read.dta("rawdata/easySHARE_rel1-0-0_stata/easySHARE_rel1-0-0.dta")
share$id_across_wave <- paste(share$mergeid,share$wave,sep="_")

# union de share.def y share (que viene de easyShare)
share.def2 <- merge(share.def,share[,c("age","id_across_wave")],by="id_across_wave")



share.def <- share.def2

save(share.def, file="tempData/share_def.RData")

