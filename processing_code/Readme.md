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

Pdte: Crear script que con source los haga todos. Crear rutas relativas a los ficheros

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