##################################
# Envejecimiento activo
# Creación fichero desde los datos originales
# Aut: José Luis Cañadas
# Fecha: Junio 2014 (para reproducibilidad)
##################################


library(foreign)

# sigo esquema del documento, mas tarde agruparé como en 3_2.R
# variables actividad vida diaria

# adl: En fichero (physical healt) de variables  generadas

## Módulo AC 
ac <- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_ac.dta")
names(ac)
sel.id <- c("mergeid","hhid","hhid1","country","waveid")
sel1 <- paste0("ac002d",1:7)
sel2 <- paste0("ac003_",1:7)
sel3 <- expand.grid(paste0("ac004d",1:8),paste0("_",1:7))
sel3 <- paste0(sel3$Var1,sel3$Var2)

seleccion <- c(sel.id,sel1,"ac002dno",sel2,sel3,paste0("ac004dno_",1:7))

posicion <- names(ac) %in%seleccion
ac.new <- ac[,posicion]
names(ac.new)



## Módulo IV

iv <- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_iv.dta")


posicion <- names(iv)%in%c("mergeid","iv020_")
iv.new <- iv[,posicion]
names(iv.new)


unido1 <- merge(ac.new,iv.new,by="mergeid")


## Módulo DN

dn <- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_dn.dta")

posicion <- names(dn)%in%c("mergeid","dn003_","dn010_","dn014_","gender")
dn.new <- dn[,posicion]


# uno unido1 con dn.new por la variable "mergeid"
unido2 <- merge(unido1, dn.new, by="mergeid")


# borro unido1
rm(unido1)

## Módulo PH

ph <- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_ph.dta")

sel4 <- paste0("ph006d",c(1,4,5,6,10,12,14))

posicion <- names(ph)%in%c("mergeid",sel4)

ph.new <- ph[,posicion]



# uno unido2 con ph.new por la variable "mergeid"
unido3 <- merge(unido2, ph.new, by="mergeid")



# borro unido2
rm(unido2)


## variables generadas gen_ph

gen_ph <- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_generated_variables_modules/sharew1_rel2-6-0_gv_health.dta")

posicion <- names(gen_ph)%in%c("mergeid","adl", "iadl","numeracy","eurod")
gen_ph.new <- gen_ph[,posicion]


# uno unido3 con gen_ph.new por la variable "mergeid"
unido4 <- merge(unido3, gen_ph.new, by="mergeid")

# borro unido3
rm(unido3)

# Módulo CF

cf<- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_cf.dta")


posicion <- names(cf)%in%c("mergeid","cf003_","cf004_","cf005_","cf006_",
                           "cf008tot","cf012_","cf013_","cf014_","cf015_",
                           "cf016tot")
cf.new <- cf[,posicion]


# uno unido4 con cf.new por la variable "mergeid"
unido5 <- merge(unido4, cf.new, by="mergeid")



# borro unido4
rm(unido4)

# Módulo MH

mh<- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_mh.dta")
posicion <- names(mh)%in%c("mergeid",paste0(paste0("mh00",2:9),"_"),
                          paste0(paste0("mh0",10:17),"_"))
mh.new <- mh[,posicion]



# uno unido5 con mh.new por la variable "mergeid"
unido6 <- merge(unido5, mh.new, by="mergeid")


# borro unido5
rm(unido5)

# Módulo EP

ep<- read.dta("../an_longitudinal/data/wave1/stata_sharew1_rel2-6-0__all_capi_modules/sharew1_rel2-6-0_ep.dta")
posicion <- names(ep) %in% c("mergeid", "ep005_")
ep.new <- ep[,posicion]


# uno unido6 con ep.new por la variable "mergeid"
unido7 <- merge(unido6, ep.new, by="mergeid")

# borro unido6
rm(unido6)

ola1 <- unido7


# cálculo del índice de cognitive
cogn1 <- ifelse(as.numeric(ola1$cf003_)==3,1,0)
cogn1[is.na(ola1$cf003_)] <- 0

cogn2 <- ifelse(as.numeric(ola1$cf004_)==3,1,0)
cogn2[is.na(ola1$cf004_)] <- 0

cogn3 <- ifelse(as.numeric(ola1$cf005_)==3,1,0)
cogn3[is.na(ola1$cf005_)] <- 0

cogn4 <- ifelse(as.numeric(ola1$cf006_)==3,1,0)
cogn4[is.na(ola1$cf006_)] <- 0

comp1 <- cogn1+cogn2+cogn3+cogn4
comp2 <- with(ola1,cf008tot+cf016tot)
comp2[is.na(comp2)] <- 0

comp3 <- ola1$numeracy

cognitive <- comp1 + comp2 + comp3
cognitive[is.na(cognitive)] <- 0

ola1$cognitive <- cognitive


if(!file.exists("tempData")){
	dir.create("tempData")
}

if(!file.exists("tempData/ola1.RData")){
save(ola1,file="tempData/ola1.RData")
}
rm(list=ls())
