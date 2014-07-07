
## ----carga, echo=FALSE---------------------------------------------------
load("../data/share_def4.RData")

## ----librerias, echo=FALSE, message=FALSE,warning=FALSE------------------
library(ggplot2)
library(lme4)
library(scales)

## ----echo=FALSE----------------------------------------------------------
edad.poly <- poly(share.clean.paises.3.olas$age,2)
share.clean.paises.3.olas$edad <- edad.poly[,1]
share.clean.paises.3.olas$edad.cuad <- edad.poly[,2]
rm(edad.poly)


## ----glmer1, cache=TRUE--------------------------------------------------

fit.glmer.1 <- glmer( participacion ~  (1 | dn003_cat/mergeid) ,
									nAGQ=0,
										family=binomial, data=share.clean.paises.3.olas)


## ----eval=FALSE----------------------------------------------------------
## edad.poly <- poly(share.clean.paises.3.olas$age,2)
## share.clean.paises.3.olas$edad <- edad.poly[,1]
## share.clean.paises.3.olas$edad.cuad <- edad.poly[,2]
## 


## ----cache=TRUE----------------------------------------------------------
fit.glmer.2 <- glmer(participacion ~ edad + (1 | dn003_cat/mergeid), data = share.clean.paises.3.olas, 
    family = binomial, nAGQ = 0)


## ------------------------------------------------------------------------
AIC(fit.glmer.1, fit.glmer.2)



## ------------------------------------------------------------------------
anova(fit.glmer.1,fit.glmer.2)



## ----cache=TRUE----------------------------------------------------------
# utilizamos la función update
fit.glmer.3 <- update(fit.glmer.2, .~.+edad.cuad)


## ------------------------------------------------------------------------
AIC(fit.glmer.1,fit.glmer.2,fit.glmer.3)



## ------------------------------------------------------------------------
anova(fit.glmer.1, fit.glmer.2, fit.glmer.3)



## ------------------------------------------------------------------------
filas <- nrow(share.clean.paises.3.olas)
# seleccionamos aleatoriamente el 60% de las filas
id.train <- sample(filas,filas*0.6)
# creamos data.frame de train
train <- share.clean.paises.3.olas[id.train,]
# creamos data.frame test con los datos no seleccionados en train
test <- share.clean.paises.3.olas[-id.train,]
nrow(train)
nrow(test)


## ----glmer_para_roc, cache=FALSE-----------------------------------------
fit.glmer.2 <- glmer(participacion ~ edad + (1 | dn003_cat/mergeid), data = train, family = binomial, nAGQ = 0)
fit.glmer.3 <- glmer(participacion ~ edad + edad.cuad + (1 | dn003_cat/mergeid), data = train, family = binomial, nAGQ = 0)


## ----warning=FALSE-------------------------------------------------------
test$pred.2 <- predict(fit.glmer.2,test,type="response",allow.new.levels=TRUE)
test$pred.3 <- predict(fit.glmer.3,test,type="response",allow.new.levels=TRUE)


## ----roc.curves,fig.width=14---------------------------------------------
library(ROCR)
# para el cálculo sólo nos quedamos con los casos donde no hay perdidos en participacion

par(mfrow=(c(1,2)))
pred.roc.2 <-  prediction(test$pred.2[!is.na(test$participacion)],test$participacion[!is.na(test$participacion)]) 

perf <- performance(pred.roc.2, "tpr", "fpr")
plot(perf,col = "orange",lty=1,lwd=2, main="Reg logística multinivel\ncon edad")
lines(c(0,1),c(0,1))


pred.roc.3 <-  prediction(test$pred.3[!is.na(test$participacion)],test$participacion[!is.na(test$participacion)]) 

perf <- performance(pred.roc.3, "tpr", "fpr")
plot(perf,col = "darkred",lty=1,lwd=2,main="Reg logística multinivel\ncon edad y edad al cuadrado")
lines(c(0,1),c(0,1))


## ------------------------------------------------------------------------
AUC2 <- performance(pred.roc.2,"auc")
AUC3 <- performance(pred.roc.3,"auc")
AUC2@y.values
AUC3@y.values


## ------------------------------------------------------------------------
summary(fit.glmer.3)



## ------------------------------------------------------------------------
coef(fit.glmer.3)$dn003_cat



## ----echo=FALSE----------------------------------------------------------
share.clean.paises.3.olas[share.clean.paises.3.olas$age<=39,c("age","edad","edad.cuad")]


## ----, echo=FALSE,warning=FALSE, error=FALSE, message=FALSE--------------
library(arm)
library(RColorBrewer)
colores <- brewer.pal(11,"Paired")
share.clean.paises.3.olas <- share.clean.paises.3.olas[!is.na(share.clean.paises.3.olas$dn003_cat),]
ficticio <- share.clean.paises.3.olas[,c("dn003_cat","age","edad","edad.cuad")]



## ----,fig.width=10, echo=FALSE, warning=FALSE, error=FALSE, message=FALSE----
tmp1 <- ficticio[,c("dn003_cat","age","edad","edad.cuad")]
tmp2 <- unique(tmp1[,c("age","edad","edad.cuad")])
tmp3 <- rbind(tmp2,tmp2,tmp2,tmp2,tmp2,tmp2,tmp2,tmp2,tmp2)
tmp3$dn003_cat <- factor (rep(levels(ficticio$dn003_cat),each=607),levels=levels(ficticio$dn003_cat))
rm(tmp1,tmp2)

pred <- matrix(nrow=nrow(tmp3),ncol=9)
for (i in 1:9){
  pred[,i] <- invlogit(coef(fit.glmer.3)$dn003_cat[i,1]+ coef(fit.glmer.3)$dn003_cat[i,2]*tmp3$edad + coef(fit.glmer.3)$dn003_cat[i,3]*tmp3$edad.cuad)
}

pred.general <- invlogit(fixef(fit.glmer.3)[1]+fixef(fit.glmer.3)[2]*tmp3$edad + fixef(fit.glmer.3)[3]*tmp3$edad.cuad)
tmp3 <- cbind(tmp3,pred,pred.general)
colnames(tmp3)[5:13] <- paste0("pred",1:9)

library(reshape)

tmp4 <- tmp3[,c("dn003_cat","age",paste0("pred",1:9),"pred.general")]
tmp.melt <- melt(tmp4,id=c("dn003_cat","age"))


tmp.melt$size <-"pred.cohor"
tmp.melt$size[tmp.melt$variable=="pred.general"] <- "pred.global" 

p1 <- ggplot(tmp.melt,aes(age,value))
p1 + geom_line(aes(group=variable, color = variable, size=size)) + 
# 	scale_size(range=c(0.6,2),guide = FALSE) +
	# otra forma d
	scale_size_manual(values=c(0.6,2),guide = FALSE) +
	scale_y_continuous(limits=c(0,0.8)) +
 
# 	scale_color_discrete()
 	labs(colour= "Estimación según cohorte",y="probability")




## ----echo=FALSE,fig.width=10, warning=FALSE, error=FALSE, message=FALSE----
tmp.melt[ (tmp.melt$variable!="pred1" & as.numeric(tmp.melt$dn003_cat)==1) |
          (tmp.melt$variable=="pred1" & tmp.melt$age<80),"value"] <- NA

tmp.melt[(tmp.melt$variable!="pred2" &  as.numeric(tmp.melt$dn003_cat)==2) | 
				 (tmp.melt$variable=="pred2" & tmp.melt$age<70),"value"] <- NA

tmp.melt[(tmp.melt$variable!="pred3" & as.numeric(tmp.melt$dn003_cat)==3) |
				(tmp.melt$variable=="pred3" & (tmp.melt$age<65 | tmp.melt$age>85 )),"value"] <- NA
tmp.melt[(tmp.melt$variable!="pred4" & as.numeric(tmp.melt$dn003_cat)==4 ) |
			  (tmp.melt$variable=="pred4" &(tmp.melt$age<60 | tmp.melt$age>80)  ),"value"] <- NA
tmp.melt[(tmp.melt$variable!="pred5" & as.numeric(tmp.melt$dn003_cat)==5 ) |
				(tmp.melt$variable=="pred5" & (tmp.melt$age<55 | tmp.melt$age>75)),"value"] <- NA
tmp.melt[(tmp.melt$variable!="pred6" &  as.numeric(tmp.melt$dn003_cat)==6) |
				(tmp.melt$variable=="pred6" & (tmp.melt$age<50 | tmp.melt$age>70)),"value"] <- NA

tmp.melt[(tmp.melt$variable!="pred7" &  as.numeric(tmp.melt$dn003_cat)==7) |
				(tmp.melt$variable=="pred7" & (tmp.melt$age<45 | tmp.melt$age>65)),"value"] <- NA

tmp.melt[ (tmp.melt$variable!="pred8" &  as.numeric(tmp.melt$dn003_cat)==8) |
				(tmp.melt$variable=="pred8" & (tmp.melt$age<40 | tmp.melt$age>60)),"value"] <- NA

tmp.melt[( tmp.melt$variable!="pred9" & as.numeric(tmp.melt$dn003_cat)==9 ) |
				(tmp.melt$variable=="pred9" & (tmp.melt$age<35 | tmp.melt$age>55)),"value"] <- NA


tmp.melt <- tmp.melt[!is.na(tmp.melt$value),]
tmp.melt <- tmp.melt[tmp.melt$variable!="pred.general",]
tmp.melt$variable <- droplevels(tmp.melt$variable)
p1 <- ggplot(tmp.melt,aes(age,value))
p1 + geom_line(aes( color = dn003_cat, size=size)) + 
# 	scale_size(range=c(0.6,2),guide = FALSE) +
	# otra forma d
	scale_size_manual(values=c(0.6,2),guide = FALSE) +
	scale_y_continuous(limits=c(0,0.8)) +
 
# 	scale_color_discrete()
 	labs(colour= "Estimación según cohorte",y="probability")



