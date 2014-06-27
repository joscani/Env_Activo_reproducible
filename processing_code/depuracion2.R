##################################
# Envejecimiento activo
# Limpieza y creacion variables desde share.clean
# Variable dep:  participacion
# Aut: José Luis Cañadas
# Fecha: junio 2014
##################################
#########################
#carga y limpieza de datos
##########################

# load("../data/share.def.clean.v2.RData")
load("tempData/share_def3.RData")


share.clean$participacion <- factor (ifelse(share.clean$participacion==1,"partic","no_partic"),
                                     levels=c("no_partic","partic"))

share.clean$age_cat <- cut(share.clean$age,c(24,50,55,60,65,70,75,80,85,90,105))
share.clean$age_cat2 <- cut(share.clean$age,c(24,55,65,75,85,105))

share.clean$eduyears_mod_cat <- cut(share.clean$eduyears_mod, c(-2,5,10,15,20,26))

share.clean$dn003_[share.clean$dn003_<0] <- NA
share.clean$dn003_cat <- cut(share.clean$dn003_, c(1900,1920,1930,1935,
                                                   1940,1945,1950,1955,1960,
                                                   1965,2013))
share.clean$dn003_cat2 <- cut(share.clean$dn003_, c(1900,1920,1930,
                                                   1940,1950, 1960,
                                                   1970,2013))
levels(share.clean$dn003_cat2) <- c("(1900-1920]", "(1920-1930]",
                                    "(1930-1940]","(1940-1950]",
                                    "(1950-1960]","(1960-1970]",
                                    "Nacidos después de 1970 ")
share.clean$ep005_ <- droplevels(share.clean$ep005_)

share.clean$ep005_cat <- 0
share.clean$ep005_cat[as.numeric(share.clean$ep005_) <=2] <- NA
share.clean$ep005_cat[as.numeric(share.clean$ep005_) ==3] <- "retired"
share.clean$ep005_cat[as.numeric(share.clean$ep005_) ==4] <- "employed"
share.clean$ep005_cat[as.numeric(share.clean$ep005_) ==5] <- "unemployed"
share.clean$ep005_cat[as.numeric(share.clean$ep005_) ==6] <- "sick_or_disabled"
share.clean$ep005_cat[as.numeric(share.clean$ep005_) ==7] <- "homemaker"
share.clean$ep005_cat[as.numeric(share.clean$ep005_) >7] <- "other"

share.clean$ep005_cat <- factor(share.clean$ep005_cat, levels=c("retired","employed",
                                                                "unemployed","sick_or_disabled",
                                                                "homemaker","other"))

# me quedo sólo con países que estén en las tres olas
(tb.paises <- with(share.clean, table(country, id_ola)))

paises.no <- c("Greece","Israel","Czechia","Poland","Ireland","Hungary","Portugal",
               "Slovenia","Estonia")

share.clean.paises.3.olas <- share.clean[!share.clean$country %in% paises.no,]

share.clean.paises.3.olas$country <- droplevels(share.clean.paises.3.olas$country)


share.clean.paises.3.olas$sphus[as.numeric(share.clean.paises.3.olas$sphus)<9] <- NA
share.clean.paises.3.olas$sphus <- droplevels(share.clean.paises.3.olas$sphus)
share.clean.paises.3.olas$adla[share.clean.paises.3.olas$adla<0] <- NA

share.clean.paises.3.olas$iadlza[share.clean.paises.3.olas$iadlza<0] <- NA
share.clean.paises.3.olas$chronic_mod[share.clean.paises.3.olas$chronic_mod<0] <- NA
share.clean.paises.3.olas$id_ola <- as.factor(share.clean.paises.3.olas$id_ola)

filtro.edad <- !is.na(share.clean.paises.3.olas$age)
share.clean.paises.3.olas <- share.clean.paises.3.olas[filtro.edad,]
rm (share.clean)
rm(paises.no)
rm(tb.paises)
rm(filtro.edad)

# eliminar cohorte más joven (1965,2013]) 
share.clean.paises.3.olas <- share.clean.paises.3.olas[as.numeric(share.clean.paises.3.olas$dn003_cat) <10 ,]
share.clean.paises.3.olas$dn003_cat <- droplevels(share.clean.paises.3.olas$dn003_cat)

# eliminar aquellos que no dicen la edad
share.clean.paises.3.olas <- share.clean.paises.3.olas[!is.na(share.clean.paises.3.olas$age),]


# eliminar menores de 50

share.clean.paises.3.olas <- share.clean.paises.3.olas[as.numeric(share.clean.paises.3.olas$age_cat)>1, ]

share.clean.paises.3.olas$age_cat <- droplevels(share.clean.paises.3.olas$age_cat)
levels(share.clean.paises.3.olas$age_cat2)[1] <- "(50,55]"
levels(share.clean.paises.3.olas$id_ola) <- c("Ola 1", "Ola 2", "Ola 4")

hyears <- read.csv2("../an_longitudinal/data/paises_olas.csv", dec=",")

share.clean.paises.3.olas <- merge(share.clean.paises.3.olas, hyears, by=c("id_ola","country","gender"))
save(share.clean.paises.3.olas,file="tempData/share_def4.RData")
