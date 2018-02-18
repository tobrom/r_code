###Getting into ARIMA

#1. Ensure stationary

plot(share) #variance is not stabe

ndiffs(share) #result = 1 which supports a trend

dshare <- diff(share) #differencing in orderto get rid of the trend

adf.test(dshare) # p value = 0.01 suggesting it´s now stationary

#2. Identifying reasonable models based on ACF & PACF for p & q (we already know that d = 1)

par(mfrow = c(2,1))
Acf(dshare)
Pacf(dshare)

## suggests an ARIMA(1,1,1)

#3. Fit the model
###apply to the original time seris now hwn you include d = 1 (it automatically calculates d = 1)
fit <- arima(share, order = C(1,1,1))

###if you try other model, use AIC to choose

#4. Evaluate the model - 

##plot the 

qqnorm(fit$residuals)
qqline(fit$residuals)

##check the if autocorrelation

Box.test(fit$residuals, type = "Ljung-Box") # checks if autocorrelations differ from zero, p-value = 0.77 --> not significant --> no autocorrelation

#5. Make forecast

fcast <- forecast(fit)
plot(fcast)

######

fit <- auto.arima(share)





