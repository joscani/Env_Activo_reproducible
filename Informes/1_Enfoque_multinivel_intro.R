
## ----carga, echo=FALSE---------------------------------------------------
load("../data/share_def4.RData")

## ----librerias, echo=FALSE, message=FALSE,warning=FALSE------------------
library(ggplot2)
library(lme4)
library(scales)


## ----glminicial----------------------------------------------------------
fit1 <- glm(participacion ~ 1, family=binomial, data=share.clean.paises.3.olas)



## ----glmer1, cache=FALSE-------------------------------------------------

fit.glmer.1 <- glmer( participacion ~  (1 | dn003_cat/mergeid) ,
									nAGQ=0,
										family=binomial, data=share.clean.paises.3.olas)


## ----message=FALSE-------------------------------------------------------
AIC(fit1, fit.glmer.1)



## ----cache=FALSE, echo=FALSE---------------------------------------------
suppressPackageStartupMessages(library(arm))
coeficientes <- coef(fit.glmer.1)
desv.tipicas <- se.coef(fit.glmer.1)


estim <- coeficientes$dn003_cat

desv <- desv.tipicas$dn003_cat


Intervalos <- data.frame(low= estim[,1] - 1.96 * desv[,1],estim= estim[,1], high= estim[,1] + 1.96  *desv[,1] )


Intervalos.prob <- invlogit(Intervalos)
Intervalos.prob$cohorte <- levels(share.clean.paises.3.olas$dn003_cat)
p <- ggplot(Intervalos.prob,aes(cohorte, estim,
  ymin = low, ymax= high, colour = cohorte))

# p + geom_errorbar(width = 0.5) + coord_flip()
p + geom_pointrange(size=rel(0.8)) + 	scale_y_continuous(labels = percent, limits=c(0.15,0.65))+ coord_flip() + labs(x="Cohorte",y="Probabilidad (en %)") + ggtitle("Porcentaje de participación estimado por cohorte\n Modelo logístico multinivel")


## ------------------------------------------------------------------------
fit2 <- glm(participacion ~ dn003_cat ,family = binomial, 
						data = share.clean.paises.3.olas )


## ----echo=FALSE----------------------------------------------------------
int.confi <- confint.default(fit2)
# el intercept corresponde a la categoria de referencia

intervalos <- as.data.frame (rbind(int.confi[1,],int.confi[-1,] + coef(fit2)[1]) )
rownames(intervalos) <- levels(share.clean.paises.3.olas$dn003_cat)


#falta calcular la estimación puntual
estim <- coef(fit2)
intervalos$estim <- c(estim[1],estim[-1] + estim[1])
colnames(intervalos) <- c("low","high","estim")
# pasando a probabilidades
intervalos.prob <- invlogit(intervalos)
intervalos.prob$cohorte <- rownames(intervalos.prob)

p <- ggplot(intervalos.prob,aes(cohorte, estim,
  ymin = low, ymax= high, colour = cohorte))

# p + geom_errorbar(width = 0.5) + coord_flip()
p + geom_pointrange(size=rel(0.8)) + 	scale_y_continuous(labels = percent, limits=c(0.15,0.55))+ coord_flip() + labs(x="Cohorte",y="Probabilidad (en %)") + ggtitle("Porcentaje de participación estimado por cohorte\n Modelo logístico clásico")



