# creacion de variables de actividades y participación
# correccion de participación para ola 4


load("tempData/share_def.RData")

share.def$act1 <- ifelse(share.def$ac002d1== 'selected', 1, 0)
share.def$act4 <- ifelse(share.def$ac002d4== 'selected', 1, 0)
share.def$act5 <- ifelse(share.def$ac002d5== 'selected', 1, 0)

share.def$act6 <- ifelse(share.def$ac002d6== 'selected', 1, 0)
share.def$act7 <- ifelse(share.def$ac002d7== 'selected', 1, 0)

share.def$participacion <- with(share.def,ifelse(act1==1 | act4==1 | act5==1 | act6==1 | act7==1, 1,0))

with(share.def, prop.table( table(id_ola, participacion),1))

# corrección de participación en ola 4
## Corregimos participación de la ola4 
# cargamos datos originales de ac
library(foreign)
ac_w4 <- read.dta(file="../an_longitudinal/data/wave4//stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_ac.dta")
names(ac_w4)
# creamos variable id_across_wave para poder unir
ac_w4$id_across_wave <- paste(ac_w4$mergeid,4,sep="_")
ac_w4$id_ola <- 4
head(ac_w4$id_across_wave)

act1 <- ifelse(ac_w4$ac035d1 == 'selected' & (as.numeric(ac_w4$ac036_1)>2 & as.numeric(ac_w4$ac036_1)<6) , 1,0) 
act4 <- ifelse(ac_w4$ac035d4 == 'selected' & (as.numeric(ac_w4$ac036_4)>2 & as.numeric(ac_w4$ac036_4)<6) , 1,0) 
act5 <- ifelse(ac_w4$ac035d5 == 'selected' & (as.numeric(ac_w4$ac036_5)>2 & as.numeric(ac_w4$ac036_5)<6) , 1,0)
act6 <- ifelse(ac_w4$ac035d6 == 'selected' & (as.numeric(ac_w4$ac036_6)>2 & as.numeric(ac_w4$ac036_6)<6) , 1,0) 
act7 <- ifelse(ac_w4$ac035d7 == 'selected' & (as.numeric(ac_w4$ac036_7)>2 & as.numeric(ac_w4$ac036_7)<6) , 1,0) 

participacion <- ifelse(act1==1 | act4==1 | act5==1 | act6==1 | act7==1, 1,0)

tmp <- data.frame(id_across_wave=ac_w4$id_across_wave,
						participacion=participacion,act1,act4,act5,act6,act7)

tmp2 <- merge(share.def,tmp,by="id_across_wave", all.x=T)

tmp2$participacion <- 0

tmp2$act1 <- 0
tmp2$act4 <- 0 
tmp2$act5 <- 0
tmp2$act6 <- 0
tmp2$act7 <- 0

tmp2$participacion[tmp2$id_ola<3] <- tmp2$participacion.x[tmp2$id_ola<3]
tmp2$participacion[tmp2$id_ola>3] <- tmp2$participacion.y[tmp2$id_ola>3]

tmp2$act1[tmp2$id_ola<3] <- tmp2$act1.x[tmp2$id_ola<3]
tmp2$act1[tmp2$id_ola>3] <- tmp2$act1.y[tmp2$id_ola>3]

tmp2$act4[tmp2$id_ola<3] <- tmp2$act4.x[tmp2$id_ola<3]
tmp2$act4[tmp2$id_ola>3] <- tmp2$act4.y[tmp2$id_ola>3]

tmp2$act5[tmp2$id_ola<3] <- tmp2$act5.x[tmp2$id_ola<3]
tmp2$act5[tmp2$id_ola>3] <- tmp2$act5.y[tmp2$id_ola>3]

tmp2$act6[tmp2$id_ola<3] <- tmp2$act6.x[tmp2$id_ola<3]
tmp2$act6[tmp2$id_ola>3] <- tmp2$act6.y[tmp2$id_ola>3]

tmp2$act7[tmp2$id_ola<3] <- tmp2$act7.x[tmp2$id_ola<3]
tmp2$act7[tmp2$id_ola>3] <- tmp2$act7.y[tmp2$id_ola>3]

tmp2$participacion.x <- NULL
tmp2$participacion.y <- NULL

tmp2$act1.x <- NULL
tmp2$act4.x <- NULL
tmp2$act5.x <- NULL
tmp2$act6.x <- NULL
tmp2$act7.x <- NULL

tmp2$act1.y <- NULL
tmp2$act4.y <- NULL
tmp2$act5.y <- NULL
tmp2$act6.y <- NULL
tmp2$act7.y <- NULL

share.def2 <- tmp2

with(share.def2, prop.table(table(id_ola, participacion),1))

# Salvar fichero 

save(share.def2, file="tempData/share_def2.RData")
