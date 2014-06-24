# Explicación de ficheros de fusion

## Descargar datos desde share


## Orden de ejecución de los ficheros

* fusion1.R
* fusion2.R
* fusion3.R
* fusion4.R
* unir_ola1_ola2.R
* union_sharew4_y_ola4.R
* crea_participacion.R
* depuracion1.R

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