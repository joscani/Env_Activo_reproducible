---
output:
  html_document: default
  pdf_document:
    highlight: haddock
    toc: yes
  word_document: default
---
# Explicación de ficheros de fusion

## Descargar datos desde share


## Orden de ejecución de los ficheros

* fusion1.R
* fusion2.R
* fusion4.R
* leer_easyshare.R
* unir_ola1_ola2.R
* union_sharew4_y_ola4.R
* crea_participacion.R
* depuracion1.R
* depuracion2.R



## Particularidades de los ficheros share

Hay cambios de nombres de variables entre la ola 1 y la ola 2. También con respecto a la ola 4 pero en la ola 4 hay incluso preguntas que se hacen de manera distinta (en olas 1 y 2 se pregunta por frecuencia mensual y en ola 4 anual)


Los datos originales vienen en diferentes módulos para cada ola y se han tenido que fusionar.
Un proceso delicado, ya que para cada ola había que fundir archivos por la variable
identificadora *mergeid* y luego había que unir los ficheros de las 3 olas (1,2,4). 
Otro problema añadido es que en la ola4 cambia el nombre de algunas variables u otras directamente
no están. Esto se ha solventado en parte utilizando el fichero easyshare que contiene datos relativos 
a las 3 olas

## Variables

### Participación

La variable de participación se construye a partir de 5 variables de actividades.
Las actividades son:


BD   | nombre                                                      | ola1/2  |  ola4 
:--- | :---------------------------------------------------------- | :---------------: | ------------:
act1 | Done voluntary or charity work                              | ac002d1           | ac035d1
act4 | Attended an educational or training course                  | ac002d4           | ac035d4
act5 | Gone to a sport, social or other kind of club               | ac002d5           | ac035d5
act6 | Taken part in activities of a religious organization        | ac002d6           | ac035d6
act7 | Taken part in a political or community-related organization | ac002d7           | ac035d7

Se define la variable participación como 1 (partic) si se ha realizado alguna de estas actividades. Hay que notar que en las olas 1 y 2 se pregunta por la realización de las actividades durante el último mes, mientras que en la ola4 se pregunta por el último año. Con el fin de unificar criterios, en la medida de lo posible, se ha considerado como que si participan a los encuestados en la ola4 que hayan participado frecuentemente en alguna de las actividades.

El criterio adoptado es el de considerar participación frecuente la participación diaria, semanal, mensual o en la mayoría de los meses del año. Si el encuestado contesta que durante el año ha realizado alguna de las actividades pero con menor frecuencia se le clasifica como no partipante.

## Descripción scripts

### fusion1.R

Este fichero lee los datos en formato stata de la ola1. 

Se utilizan los módulos *AC*, *IV*, *DN*, *PH*, *GEN_PH*, *CF*, *MH*, *EP* y se fusionan en un sólo fichero (para qué variables se seleccionan de cada módulo ver el script)

También se calcula el índice cognitive, de la siguiente forma y se salvan los datos en "tempData/ola1.RData"

```
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
```

## fusion2.R
Hace exactamente lo mismo que `fusion1.R` pero con los datos de la ola2


## fusion4.R

En la ola 4 algunas variables han cambiado de nombre y no se pregunta exactamente lo mismo. Tal es el caso de las variables de actividad que son en las que nos basaremos para construir la variable participación. Por lo demás hace lo mismo 


## leer_easyshare.R

Script para leer de stata easyshare. Easyshare es un fichero de stata dónde han unido todas las olas (en las variables dónde se puede). Guardo los datos en easyshare.RData. Estos datos se usarán para comprobar y completar datos en los datos unidos. 

## unir_ola1_ola2.R

Script que une ola1.RData y ola2.RData

## union_sharew4_y_ola4.R

* Añade y corrige algunas variables de ola4.RData
* Une ola1 ola2 con ola4 
* Al fichero definitivo le añade la variable age del fichero easyshare (creemos que es más fiable la variable en este fichero)
* Guarda los datos en share_def.RData

## crea_participacion.R

Crea la variable participación partiendo de las 5 actividades teniendo en cuenta en la ola4 cambia el nombre de las variables y que  se pregunta por la frecuencia anual. En la ola 4 se considera que ha realizado la actividad si contesta que la ha realizado frecuentemente o la mayoría de los meses del año pero no si dice que la ha realizado con menor frecuencia. En las olas 1 y 2 al preguntar por frecuencia mensual se considera que realiza la actividad si contesta que si en las preguntas de actividad. 

Ejemplo: En **olas 1 y 2** para las distintas actividades


```
share.def$act1 <- ifelse(share.def$ac002d1== 'selected', 1, 0)
share.def$act4 <- ifelse(share.def$ac002d4== 'selected', 1, 0)
share.def$act5 <- ifelse(share.def$ac002d5== 'selected', 1, 0)

share.def$act6 <- ifelse(share.def$ac002d6== 'selected', 1, 0)
share.def$act7 <- ifelse(share.def$ac002d7== 'selected', 1, 0)
```

Y se considera que hay participación si ha realizado al menos una de las actividades

```
share.def$participacion <- with(share.def,ifelse(act1==1 | act4==1 | act5==1 | act6==1 | act7==1, 1,0))
```

Para la **ola 4 ** se tiene en cuenta la frecuencia, que viene data por la variable ac036_1. Así si tenemos ac_w4 que es el módulo ac para la ola 4 entonces la variable participación sería.

```
act1 <- ifelse(ac_w4$ac035d1 == 'selected' & (as.numeric(ac_w4$ac036_1)>2 & as.numeric(ac_w4$ac036_1)<6) , 1,0) 
act4 <- ifelse(ac_w4$ac035d4 == 'selected' & (as.numeric(ac_w4$ac036_4)>2 & as.numeric(ac_w4$ac036_4)<6) , 1,0) 
act5 <- ifelse(ac_w4$ac035d5 == 'selected' & (as.numeric(ac_w4$ac036_5)>2 & as.numeric(ac_w4$ac036_5)<6) , 1,0)
act6 <- ifelse(ac_w4$ac035d6 == 'selected' & (as.numeric(ac_w4$ac036_6)>2 & as.numeric(ac_w4$ac036_6)<6) , 1,0) 
act7 <- ifelse(ac_w4$ac035d7 == 'selected' & (as.numeric(ac_w4$ac036_7)>2 & as.numeric(ac_w4$ac036_7)<6) , 1,0) 

participacion <- ifelse(act1==1 | act4==1 | act5==1 | act6==1 | act7==1, 1,0)

```

Así creamos la variable participación correcta para cada ola.

Por último salva los datos en share_def2.RData

### depuracion1.R

Partiendo de share_def2.RData 
Añade las variable mar_stat y eduyears_mod  entre otras desde el fichero easyshare.
Salva fichero en share_def3.RData

### depuracion2.R

Parte de share_def3.RData

* Codifica la variable participación como *partic* si participa y *no_partic* en otro caso.
* Categoriza la variable edad.
* Crea variable categorizada de eduyears_mod por si se quisiera utilizar.
* Se crea la variale *dn003_cat* desde el año de nacimiento *dn003*. Esta variable indica la cohorte de pertenencia.
* Se crea *ep005_cat* cuyos niveles son "retired","employed",
"unemployed","sick_or_disabled","homemaker","other"

* Nos quedamos sólo con países que están en las tres olas. Son todos los países menos 
"Greece","Israel","Czechia","Poland","Ireland","Hungary","Portugal", "Slovenia","Estonia"

* Eliminamos de la BD a aquellos que no contestaron la edad
* Eliminamos los casos correspondientes a la cohorte más joven (1965,2013]
* Elminamos aquellos casos con edad < 50 

* Se añaden datos de life y healthy expectancy at 50 por país, ola y sexo

* Guardamos los datos en share_def4.RData

Este último conjunto de datos será el conjunto de datos para el análisis


