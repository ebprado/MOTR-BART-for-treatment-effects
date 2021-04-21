# MOTR-BART-for-treatment-effects
This repository contains R scripts and synthetic data sets that can be used to fit the MOTR-BART (Prado et al., 2021) for treatment effects.

## Installation
``` r
library(devtools)
install_github("ebprado/MOTR-BART-for-treatment-effects/BARTreatEff")
```
## Example
``` r
library(BARTreatEff)
library(policytree)
library(BART)
n = 500
p = 10

data <- gen_data_mapl(n, p)
data.test <- gen_data_mapl(n, p)

temp_treats_train <- as.character(data$action)

xtrain_with_t <- cbind(model.matrix(~ temp_treats_train - 1), data$X)

xtest_with_1 <- cbind(rep(1,n), rep(0,n), rep(0,n)  , data.test$X)
xtest_with_2 <- cbind(rep(0,n), rep(1,n), rep(0,n)  , data.test$X)
xtest_with_3 <- cbind(rep(0,n), rep(0,n), rep(1,n)  , data.test$X)

xtest_all <- rbind(xtest_with_1, xtest_with_2, xtest_with_3)

## MOTR-BART
x = as.data.frame(xtrain_with_t)
y = data$Y

motr_bart_fit = BARTreatEff::motr_bart(x,
                                       x_binary = c('temp_treats_train0',
                                                    'temp_treats_train1',
                                                    'temp_treats_train2'),
                                       y = y,
                                       var_linear_pred = 'covariates + binary treatment',
                                       # var_linear_pred = 'binary treatments',
                                       npost = 1000)
yhat = apply(motr_bart_fit$y_hat,2,mean) # predicted y
plot(yhat, y);abline(0,1)
cor(yhat, y)
motr_bart_fit$trees[[100]] # tree structure of 100th MCMC iteration (post burn-in)
yhat_pred = predict_motr_bart(motr_bart_fit, x, type='mean') # predict function

# train BART
post <- wbart(xtrain_with_t,
              data$Y,
              xtest_all,
              ndpost = 2000)
plot(post$yhat.train.mean, data$Y);abline(0,1)
cor(post$yhat.train.mean, data$Y)
```
