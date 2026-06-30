#The file "aa_data.csv" reports light intensity, leaf area and leaf shape for the most basal leaf of 100 Adenostyles alliariae plants measured in the area near the Passo del Pura in Ampezzo, Udine Province, Italy. Data were collected from 9-12 July 2019. Data accompanies Francis and Gilman (2019). By column, the data is:

#light - light intensity in EV
#leaf.area - leaf area in mm^2
#ls - the distance from the center vein to the widest point on the left side of the leaf
#rs - the distance from the center vein to the widest point on the right side of the leaf
#lasym - fluctuating asymmetry, measured as |ln(ls)-ln(rs)|
#day - a class variable indiating the day (of 3) on which the data was collected
#patch - a class variable indicating the site (of 4) in which the data was collected
#shade - an indicator showing whether the site was shaded by confierous forest (1) or open (0)

#Francis and Gilman (2019) used the following code to analyse the data in R:

#load packages
library(lme4)
library(car)
library(lmerTest)
library(ggplot2)
library(gridExtra)

#create function for Monte Carlo analysis to compare means
t.mc=function(a,b,sim){
	f=c(a,b)	
	min.length=min(length(a),length(b))
	if(length(a)<length(b)) {
		obs.sum=sum(a)
	} else {
		obs.sum=sum(b) 
		}
	sim.greater=0
	for (i in 1:sim){
		sim.greater=sim.greater+(sum(sample(f,min.length))>obs.sum)
	}
	p=2*min(sim.greater/sim,1-sim.greater/sim)
	return(c(mean(a),mean(b),p))
}

#load data from Francis and Gilman (2019)
aa.data=read.csv("aa_data.csv")

#calculate log leaf area
lla=log(aa.data$leaf.area)

#rescale light intensity to log(lux)
li=log(2.5*2^aa.data$light)

#convert shade to character so we can treat it as a random effect
shd=as.character(aa.data$shade)

#add rescaled variables to the data frame aa.data
aa.data=cbind(aa.data,lla,li,shd)

#create violin plot of light intensity in open and shaded sites
p1=ggplot(aa.data, aes(x=shd, y=li),ylim=c(0,12)) + 
  geom_violin(trim=FALSE,fill="grey",bw=.5)
p1=p1+geom_dotplot(binaxis='y', stackdir='center', dotsize=.75)+theme_classic()+theme(axis.text=element_text(size=10),axis.title.x=element_blank(),axis.text.x=element_text(size=10,color="black"),axis.ticks.x=element_blank())+labs(y="light intensity in log(lx)")+scale_x_discrete(labels=c("0" = "open", "1" = "shaded"))
p1

#calculate summary statistics

#find mean light intensity at open and shaded sites, and assess difference using Monte Carlo randomisation
t.mc(li[which(shd=="0")],li[which(shd=="1")],100000)

#find standard error for logged light intensity in open and shaded sites
sd(li[which(shd=="0")])/sqrt(50-1)
sd(li[which(shd=="1")])/sqrt(50-1)

#find mean and se for logged leaf area in open and shaded sites
t.mc(lla[which(shd=="0")],lla[which(shd=="1")],100000)
sd(lla[which(shd=="0")])/sqrt(50-1)
sd(lla[which(shd=="1")])/sqrt(50-1)

#find mean and se for FA in open and shaded sites
t.mc(aa.data$lasym[which(shd=="0")],aa.data$lasym[which(shd=="1")],100000)
sd(aa.data$lasym[which(shd=="0")])/sqrt(50-1)
sd(aa.data$lasym[which(shd=="1")])/sqrt(50-1)

#regress log leaf area on light intensity in lme4
lla.lme=lmer(lla~li+(1|day)+(1|patch)+(1|shade),data=aa.data)

#examine residuals
hist(resid(lla.lme))

#Box-Cox transform log leaf area
powerTransform(lla.lme, family="bcPower")
lam.la=2.216367
lla.bc=(lla^lam.la-1)/lam.la

#refit lla.lme
lla.lme=lmer(lla.bc~li+(1|day)+(1|patch)+(1|shade),data=aa.data)
summary(lla.lme)
b.la=100.2226
m.la=-4.2284

#calculate slope at mean-centered light intensity
xm=mean(li)
m.la*(1+b.la*lam.la+m.la*xm*lam.la)^(-1+1/lam.la)

#regress FA area on light intensity in lme4
fa.lme=lmer(lasym~li+(1|day)+(1|patch)+(1|shd),data=aa.data)

#examine residuals
hist(resid(fa.lme))

#Winsorise and Box-Cox transform FA
lasym.w=aa.data$lasym
lasym.w[which(lasym.w==0)]=min(lasym.w[which(lasym.w>0)])
fa.lme=lmer((lasym.w)~li+(1|day)+(1|patch)+(1|shd),data=aa.data)
powerTransform(fa.lme, family="bcPower")
lam.fa=0.2041794
lasym.bc=((lasym.w)^lam.fa-1)/lam.fa

#refit lla.lme
fa.lme=lmer(lasym.bc~li+(1|day)+(1|patch)+(1|shd),data=aa.data)
summary(fa.lme)
b.fa=-1.78837
m.fa=-0.04261

#calculate slope at mean-centered light intensity
m.fa*(1+b.fa*lam.fa+m.fa*xm*lam.fa)^(-1+1/lam.fa)

#test for effect of of leaf area on fluctuating assymetry while controlling for light intensity
fa.lme=lmer(lasym~li+lla+(1|day)+(1|patch)+(1|shd),data=aa.data)

#examine residuals
hist(resid(fa.lme))

#Box-Cox transform FA
fa.lme=lmer(lasym.w~li+lla+(1|day)+(1|patch)+(1|shd),data=aa.data)
powerTransform(fa.lme, family="bcPower")
lam.fl=0.2085141
lasym.bc.fl=(lasym.w^lam.fl-1)/lam.fl

#refit lla.lme
fa.lme=lmer(lasym.bc.fl~li+lla+(1|day)+(1|patch)+(1|shd),data=aa.data)
summary(fa.lme)

#plot fitted models
par(mfrow=c(2,1),mar=c(2,4,2,2),mgp=c(0,0.5,0))

plot(li,lla,xlab="",ylab="",tck=-0.02)
text(9.9,10.5,"A",cex=1.5)
title(ylab=expression('leaf area in log(mm'^2*")"),line=2.5)
points(li[which(aa.data$shade==1)],lla[which(aa.data$shade==1)],pch=19)
curve(exp(log(lam.la*(b.la+m.la*x)+1)/lam.la),3,11,add=TRUE)

par(mar=c(4,4,0,2),mgp=c(0,.5,0))

plot(li,aa.data$lasym,xlab="",ylab="",tck=-0.02)
points(li[which(aa.data$shade==1)],aa.data$lasym[which(aa.data$shade==1)],pch=19)
title(ylab="fluctuating asymmetry",line=2.5)
title(xlab="light intensity in log(lx)",line=2)
text(9.9,.1875,"B",cex=1.5)
curve(exp(log(lam.fa*(b.fa+m.fa*x)+1)/lam.fa),3,11,add=TRUE,lty=2)

#check for directional asymmetry
d=log(aa.data$ls)-log(aa.data$rs)
t.test(d,mu=0)
