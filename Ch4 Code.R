## Linear Regression Model with Dummy Variables
```{r}
setwd("C:\\Users\\Shivakumar Panuganti\\Documents\\R")
df= read.csv("Salary.csv")
head(df)
dim(df)
```

```{r}
salary= df[,2]
age=df[,3]
gender=as.factor(df[,4]) #it converts to dummy
```

```{r}
reg= lm(salary~age+gender)
summary(reg)
```

```{r}
park_data<- read.csv("http://goo.gl/HKnl74")
head(park_data)
```

```{r}
park_data$num.child.factor<- factor(park_data$num.child)
park_data$logdistance<- log(park_data$distance)
head(park_data)
```

```{r}
data_std<-park_data[,-3]
data_std[,3:7]<-scale(data_std[,3:7]) #Normalization
data_std$has.child<-factor(data_std$num.child>0)
```
### Interaction Terms
```{r}
m1<- lm(overall~wait+has.child+wait:has.child, data= data_std)
summary(m1)
```
### Let's choose random interaction terms has.child, weekend
```{r}
m2<- lm(overall~ rides+games+wait+clean+weekend+has.child+rides:has.child+games:has.child+wait:has.child+clean:has.child+ rides:weekend+games:weekend+wait:weekend+clean:weekend, data=data_std)
summary(m2)
```
#### which ha s better AIC and BIC score?
```{r}
AIC(m1);AIC(m2)
BIC(m1);BIC(m2)
```
## Regression with variable selection
```{r}
#Loading discover data
discover_df= read.csv("Discover_step.csv", head= TRUE)
dim(discover_df)

```

```{r}
summary(discover_df)
```

```{r}
target<- discover_df[,2]
features<-as.matrix(discover_df[,3:15])
```

```{r}
library(Hmisc)
rcorr(features)
```

```{r}
library(ggcorrplot)
corr<- round(cor(features),1)
ggcorrplot(corr)
ggcorrplot(corr, lab= TRUE)
```
```{r}
mul_reg<- lm(target~features)
summary(mul_reg)
```

```{r}
library(MASS)
step_both<- stepAIC(mul_reg,direction = "both")
summary(step_both)
```
```{r}
step_back<-stepAIC(mul_reg, direction="backward")
summary(step_back)
```
## Ridge Regression
```{r}
## Using the Salary Data
lm.ridge(salary~age+gender, df, lambda=10)
```

```{r}
lm(salary~age+gender)
```

```{r}
plot(lm.ridge(salary~age+gender, df, lambda=seq(0,10,0.001)))
```
### Using Discover Data
```{r}
lm(q4~., data= discover_df[,-1])
```
```{r}
lm.ridge(q4~., data=discover_df[,-1],lambda = 1)
```

```{r}
fit<- lm.ridge(q4~., data=discover_df[,-1], lambda = seq(0,500,by=1))
plot(fit$GCV) #Generalized Cross Validation
```

```{r}
lm.ridge(q4~.,data=discover_df[,-1],lambda = 120)
```

```{r}
#Weak shrinkage
plot(lm.ridge(q4~., data=discover_df[,-1],lambda = seq(0,10,0.1)))
```
```{r}
#Strong shrinkage
plot(lm.ridge(q4~., data=discover_df[,-1],lambda = seq(0,100,0.1)))
```
## Lasso Regression
```{r}
library(lars)
las_reg= lars(features, target, type= "lasso")
plot(las_reg)
```
### Coefficients are shrinking into zero values depending on alpha parameter in the lasso formula
```{r}
dim(las_reg$beta)
```

```{r}
las_reg$lambda
```

```{r}
las_reg$beta[1,]
```

```{r}
las_reg$lambda[1]
```

```{r}
las_reg$beta[6,] #Five significant Variables