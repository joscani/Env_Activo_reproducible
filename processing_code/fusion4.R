##################################
# Envejecimiento activo
# Creación fichero desde los datos originales
# Aut: José Luis Cañadas
# Fecha: Junio 2014 (para reproducibilidad)
##################################


library(foreign)

# adl: En fichero (physical healt) de variables  generadas

## Módulo AC 
ac <- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_ac.dta")
names(ac)
sel.id <- c("mergeid","country")
sel1 <- paste0("ac035d",c(1,4,5:10))
sel2 <- paste0("ac036_",c(1,4:10))

seleccion <- c(sel.id,sel1,"ac035dno",sel2)

posicion <- names(ac) %in%seleccion
ac.new <- ac[,posicion]
names(ac.new)



## Módulo IV
iv <- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_iv.dta")


posicion <- names(iv)%in%c("mergeid","iv020_")
iv.new <- iv[,posicion]
names(iv.new)



unido1 <- merge(ac.new,iv.new,by="mergeid")


## Módulo DN

dn <- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_dn.dta")

posicion <- names(dn)%in%c("mergeid","dn003_","dn010_","dn014_","gender")
dn.new <- dn[,posicion]



# uno unido1 con dn.new por la variable "mergeid"
unido2 <- merge(unido1, dn.new, by="mergeid")


# borro unido1
rm(unido1)

## Módulo PH

ph <- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_ph.dta")

sel4 <- paste0("ph006d",c(1,4,5,6,10,12,14))

posicion <- names(ph)%in%c("mergeid",sel4)

ph.new <- ph[,posicion]



# uno unido2 con ph.new por la variable "mergeid"
unido3 <- merge(unido2, ph.new, by="mergeid")



# borro unido2
rm(unido2)


## variables generadas gen_ph

  gen_ph <- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_generated_modules/sharew4_rel1-1-1_gv_health.dta")

posicion <- names(gen_ph)%in%c("mergeid","adl", "iadl","numeracy","eurod")
gen_ph.new <- gen_ph[,posicion]



# uno unido3 con gen_ph.new por la variable "mergeid"
unido4 <- merge(unido3, gen_ph.new, by="mergeid")



# borro unido3
rm(unido3)

# Módulo CF

cf<- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_cf.dta")

posicion <- names(cf)%in%c("mergeid","cf003_","cf004_","cf005_","cf006_",
                           "cf012_","cf013_","cf014_","cf015_")
cf.new <- cf[,posicion]


# uno unido4 con cf.new por la variable "mergeid"
unido5 <- merge(unido4, cf.new, by="mergeid")


# borro unido4
rm(unido4)

# Módulo MH

mh<- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_mh.dta")
posicion <- names(mh)%in%c("mergeid",paste0(paste0("mh00",2:9),"_"),
                          paste0(paste0("mh0",10:17),"_"))
mh.new <- mh[,posicion]

# uno unido5 con mh.new por la variable "mergeid"
unido6 <- merge(unido5, mh.new, by="mergeid")

# borro unido5
rm(unido5)

# Módulo EP

ep<- read.dta("../an_longitudinal/data/wave4/stata_sharew4_rel1-1-1_all_capi_modules/sharew4_rel1-1-1_ep.dta")
posicion <- names(ep) %in% c("mergeid", "ep005_")
ep.new <- ep[,posicion]

# uno unido6 con ep.new por la variable "mergeid"
unido7 <- merge(unido6, ep.new, by="mergeid")

# borro unido6
rm(unido6)

ola4 <- unido7

if(!file.exists("tempData")){
	dir.create("tempData")
}

if(!file.exists("tempData/ola4.RData")){
	save(ola4,file="tempData/ola4.RData")
}
rm(list=ls())
