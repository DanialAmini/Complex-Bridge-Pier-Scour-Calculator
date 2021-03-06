
rm(list=ls())


graphics.off()   


setwd("E:/scour_main/complex/softpaper/NN_SVM")




pushd %~d1%~p1
R --vanilla < "%1"

setwd("E:/scour_main/complex/comments beheshti 2019.6.11/drbeheshti/github files/Complex-Bridge-Pier-Scour-Calculator-master/NN_train_val_test")

#case_=2345; cost_=2; gamma_=.7; epsilon_=.1

#case_=4; cost_=64; gamma_=.05; epsilon_=.1

#case_=3; cost_=32; gamma_=.25; epsilon_=.1

#case_=2; cost_=512; gamma_=.2; epsilon_=.2

#case_=5; cost_=512; gamma_=.4; epsilon_=.2


library(e1071)


rmse <- function(error)
{
  sqrt(mean(error^2))
}



print_SVM <- function()
{
	sink(paste("SVM_res/SVM_FUNC_case",case_,"outfile.txt"))
	cat('\n\'rmse_train=',rmse1,'\n')
	cat('\n\'rmse_val=',rmse2,'\n')
	cat('\n\'rmse_test=',rmse3,'\n')
	cat('\'correlation=',cor(data__$z,predictedZ),'\n')
	cat('\'SVM - number of support vectors =',length(model$SV[,2]),'\n')
	cat('\'kernel No. = ',model$kernel,' (kernel Nos: 0=linear,2=radial)\n')
	cat('\'cost = ',model$cost,'\n')
	cat('\'gamma = ',model$gamma,'\n')
	cat('\'epsilon = ',model$epsilon,'\n')
	cat("'vars=",names_vec,"\n")
	cat('\'scaling X with mean and stdev\n')
	cat("'''''''''''''''''''''")
	str='\n'
	for (i in 1:vars){
		str=paste(str,names_vec[i],'s=(',names_vec[i],'-',mean(MyData[,i]),')/',sd(MyData[,i]),'\n',sep='')
	}
	cat(str,'')
	cat("''''''''''''''''''''''''''''''\n")

	cat('z=-',model$rho,'\n')
	for (i in 1:length(model$SV[,2])){
		cat('z=z+',model$coefs[i],'*exp(-',model$gamma,'*(',sep='')
		for (j in 1:vars){
			cat('(',names_vec[j],'s-',model$SV[i,j],') ^ 2',sep='')
			if(j<vars){cat('+',sep='')}
		}
		cat(')) \'index=',model$index[i],sep='')
		if(i<length(model$SV[,2])){cat('\n')}
	}
	cat("\n'''''''''''''''''''''''''''''''''''''''")
	cat(paste('\nz=z*',sd(MyData[,vars+1]),'+',mean(MyData[,vars+1]),'\n\n',sep=''))
	sink()
}


#for the first time you have to instal e1071
#install.packages("e1071")




write_ = function(name_,data_){

	write(model$index,paste0(name_,"_index.txt"),ncolumns=1)
	write(model$coefs,paste0(name_,"_coefs.txt"),ncolumns=1)
	write(model$rho,paste0(name_,"_rho.txt"),ncolumns=1)
	write(model$gamma,paste0(name_,"_gamma.txt"),ncolumns=1)
	write(t(model$SV),paste0(name_,"_SV.txt"),ncolumns=ncol_)
	write(length(model$SV[,2]),paste0(name_,"_size.txt"),ncolumns=8)
	write(length(model$SV[,2]),paste0(name_,"_size.txt"),ncolumns=8)
	write.svm(model,svm.file=paste0(name_,"_Rdata.svm.txt"),scale.file=paste0(name_,"_xscale.txt"),yscale.file=paste0(name_,"_yscale.txt"))
	length(model$SV[,2])
	predictedZ <- predict(model, data_)
	plot(data_$z, predictedZ)
	rmse(data_$z-predictedZ)

	write(rmse(data_$z-predictedZ),paste0(name_,"_rmse.txt"))

}

write2_ = function(name_,data_){
	length(model$SV[,2])
	predictedZ <- predict(model, data_)
	rmse(data_$z-predictedZ)

	write(rmse(data_$z-predictedZ),paste0(name_,"_rmse.txt"))
	plot(data_$z, predictedZ)
}










printLM <- function(model)
{
	str1='z='
	str1=paste(str1,model$coeff[[1]],sep='')
	for (i in 2:length(model$coeff))
	{
		str1=paste(str1,' +',model$coeff[[i]],"*",names_vec[i-1],sep='')
	}
	cat("\n")
	cat("'linear model,rmse_training=",rmse1,"\n")	
	cat("'vars=",names_vec,"\n")
	cat(str1,"\n")
	cat("\n")
}

for (case_ in c(2,3,4,5,2345)){



rmse2N=100
if (case_==2){
	names_vec=c('x1','x3','x6')  #case2

	MyData = read.csv("case2-train.csv",header=TRUE)
	MyData2 = read.csv("case2-trainVal.csv",header=TRUE)
	MyData3 = read.csv("case2-test.csv",header=TRUE)

	MyData$x2=NULL
	MyData$x4=NULL
	MyData$x5=NULL
	MyData$x7=NULL

	MyData2$x2=NULL
	MyData2$x4=NULL
	MyData2$x5=NULL
	MyData2$x7=NULL

	MyData3$x2=NULL
	MyData3$x4=NULL
	MyData3$x5=NULL
	MyData3$x7=NULL

} else if (case_==3){
	names_vec=c('x1','x2','x3','x4','x5','x6','x7')  #case 3

	MyData = read.csv("case3-train.csv",header=TRUE)
	MyData2 = read.csv("case3-trainVal.csv",header=TRUE)
	MyData3 = read.csv("case3-test.csv",header=TRUE)

} else if (case_==4){
	MyData = read.csv("case4-train.csv",header=TRUE)
	MyData2 = read.csv("case4-trainVal.csv",header=TRUE)
	MyData3 = read.csv("case4-test.csv",header=TRUE)

	names_vec=c('x1','x2','x3','x4','x5','x6','x7')

} else if (case_==5){
	MyData = read.csv("case5-train.csv",header=TRUE)
	MyData2 = read.csv("case5-trainVal.csv",header=TRUE)
	MyData3 = read.csv("case5-test.csv",header=TRUE)

	MyData$x1=NULL
	MyData$x3=NULL

	MyData2$x1=NULL
	MyData2$x3=NULL

	MyData3$x1=NULL
	MyData3$x3=NULL

	names_vec=c('x2','x4','x5','x6','x7')
} else if (case_==2345){
	MyData = read.csv("c2-5_train.csv",header=TRUE)
	MyData2 = read.csv("c2-5_val.csv",header=TRUE)
	MyData3 = read.csv("c2-5_test.csv",header=TRUE)

	names_vec=c('x1','x2','x3','x4','x5','x6','x7')
}


data__=MyData

ncol_=length(MyData)-1
vars=ncol_

kernel_="radial"
#kernel_="linear"
#kernel_="polynomial"
#kernel_="sigmoid"


#x1 (bpg/bpc)	x2 (bcol/bpc)	x3 (h0/y)	x4 (h1/y)	
#x5 (T/y)	x6 (bpc/y)	x7 (f1/bcol)	z (be/b*)



a <- as.formula(paste('z ~ ' ,paste(names_vec,collapse='+')))



#for sensitivity
#del_var='x7'
#names_vec_NEW=names_vec[!is.element(names_vec, c(del_var))]
#if (length(names_vec_NEW)!=vars){vars=vars-1}
#names_vec=names_vec_NEW
#MyData[which( colnames(MyData)==del_var )] <- NULL
#MyData2[which( colnames(MyData2)==del_var )] <- NULL
#a <- as.formula(paste('z ~ ' ,paste(names_vec,collapse='+')))
#data__=MyData



model=lm(a,data=MyData)
predictedZ <- predict(model, data__)
rmse1=rmse(data__$z-predictedZ)
rmse1
#write2_("razie",data__)

printLM(model)


for (cost_ in 2^(1:12)){
for (epsilon_ in .1*(15:1)){
for (gamma_ in .05*(1:20)){

model <- svm(a,data=MyData, kernel  = kernel_, cost = cost_, gamma = gamma_, epsilon = epsilon_)

#cat('sv = ',length(model$SV[,2]),'\n')




predictedZ <- predict(model, data__)
rmse1=rmse(data__$z-predictedZ)
rmse1

predictedZ2=predict(model,MyData2)
rmse2=rmse(MyData2$z-predictedZ2)
rmse2

predictedZ3=predict(model,MyData3)
rmse3=rmse(MyData3$z-predictedZ3)
rmse3

if (rmse2N>rmse2){
	graphics.off()   

	rmse2N=rmse2

	dev.new(width=10,height=4,main="hii")
	par(mfrow=c(1,3),oma = c(0, 0, 2, 0))

	plot(data__$z, predictedZ,main=paste("rmse_train=",round(rmse1,3)))
	lines(c(0,10),c(0,10))
	lines(c(0,10),c(0,8))
	lines(c(0,10),c(0,12))
	lines(c(0,10),c(0,0))
	lines(c(0,0),c(0,10))

	plot(MyData2$z, predictedZ2,main=paste("rmse_val=",round(rmse2,3)))
	lines(c(0,10),c(0,10))
	lines(c(0,10),c(0,8))
	lines(c(0,10),c(0,12))
	lines(c(0,10),c(0,0))
	lines(c(0,0),c(0,10))


	plot(MyData3$z, predictedZ3,main=paste("rmse_test=",round(rmse3,3)))
	lines(c(0,10),c(0,10))
	lines(c(0,10),c(0,8))
	lines(c(0,10),c(0,12))
	lines(c(0,10),c(0,0))
	lines(c(0,0),c(0,10))

	mtext(paste("case=",case_,",SVMcount=",length(model$SV[,2]),",kernel=",kernel_,",cost=",cost_,",gamma=",gamma_,",epsilon=",epsilon_), side = 3, line = -1, outer = TRUE)
	costN_=cost_;gammaN_=gamma_;epsilonN_=epsilon_;
}

cat("SVMcount=",length(model$SV[,2]),",kernel=",kernel_,",cost=",cost_,",gamma=",gamma_,",epsilon=",epsilon_,"rmse_train=",round(rmse1,3),",rmse_val=",round(rmse2,3),",rmse_test=",round(rmse3,3),"\n")

}}}


cat("\n final model\n")
cost_=costN_;gamma_=gammaN_;epsilon_=epsilonN_;
cat("SVMcount=",length(model$SV[,2]),",kernel=",kernel_,",cost=",cost_,",gamma=",gamma_,",epsilon=",epsilon_,"rmse_train=",round(rmse1,3),",rmse_val=",round(rmse2,3),",rmse_test=",round(rmse3,3),"\n")


model <- svm(a,data=MyData, kernel  = kernel_, cost = cost_, gamma = gamma_, epsilon = epsilon_)


predictedZ <- predict(model, data__)
rmse1=rmse(data__$z-predictedZ)
rmse1

predictedZ2=predict(model,MyData2)
rmse2=rmse(MyData2$z-predictedZ2)
rmse2

predictedZ3=predict(model,MyData3)
rmse3=rmse(MyData3$z-predictedZ3)
rmse3


name_=paste("SVM_res/SVM_case",case_,"_")
#write2_(name_,MyData)
#write_(name_,MyData)

graphics.off()   
dev.new(width=10,height=4,main="hii")
par(mfrow=c(1,3),oma = c(0, 0, 2, 0))

plot(data__$z, predictedZ,main=paste("rmse_train=",round(rmse1,3)),xlab="observed be/b*3",ylab="predicted be/be*")
lines(c(0,10),c(0,10))
lines(c(0,10),c(0,8))
lines(c(0,10),c(0,12))
lines(c(0,10),c(0,0))
lines(c(0,0),c(0,10))

plot(MyData2$z, predictedZ2,main=paste("rmse_val=",round(rmse2,3)),xlab="observed be/b*3",ylab="predicted be/be*")
lines(c(0,10),c(0,10))
lines(c(0,10),c(0,8))
lines(c(0,10),c(0,12))
lines(c(0,10),c(0,0))
lines(c(0,0),c(0,10))


plot(MyData3$z, predictedZ3,main=paste("rmse_test=",round(rmse3,3)),xlab="observed be/b*3",ylab="predicted be/be*")
lines(c(0,10),c(0,10))
lines(c(0,10),c(0,8))
lines(c(0,10),c(0,12))
lines(c(0,10),c(0,0))
lines(c(0,0),c(0,10))

mtext(paste("case=",case_,",SVMcount=",length(model$SV[,2]),",kernel=",kernel_,",cost=",cost_,",gamma=",gamma_,",epsilon=",epsilon_), side = 3, line = -1, outer = TRUE)
dev.print(pdf, paste('SVM_res/SVM_res,case',case_,'.pdf'))

print_SVM()



}