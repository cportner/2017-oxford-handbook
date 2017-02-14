# Graph for changes in TFR 
# For Fertility Issues chapter in Oxford handbook
# Claus C Portner
# Begun.: 2017-02-10
# Edited: 2017-02-10

library(tidyr)
library(reshape2)

# short file paths - assuming work directory is "code"
dataDir <- "../data/Data_Extract_From_World_Development_Indicators"
figureDir <- "../figures"

# Data - extracted from World Bank WDI 2017-02-09 - need to reshape
# .. is missing in the original data
df <- read.csv(
  file.path(dataDir,"2017-02-09-wdi-extract.csv"),
  na.strings=c(".."))
df$Country.Name <- NULL
df$Series.Name <- NULL

# Tidying up data (need tidyr for that) - multistep process
test <- gather(df, key, value, -Country.Code, -Series.Code)
test1 <- separate(test, key, into = c("y1","y2"), sep = 1)
test2 <- separate(test1, y2, into = c("year","x2"), sep = 4)
test2$y1 <- NULL
test2$x2 <- NULL
test3 <- spread(test2, Series.Code, value)
df <- test3
df$year <- as.numeric(df$year)
df$SH.DYN.MORT <- as.numeric(df$SH.DYN.MORT)
df$SH.DYN.MORT.FE <- as.numeric(df$SH.DYN.MORT.FE)
df$SH.DYN.MORT.MA <- as.numeric(df$SH.DYN.MORT.MA)
df$SP.ADO.TFRT <- as.numeric(df$SP.ADO.TFRT)
df$SP.DYN.TFRT.IN <- as.numeric(df$SP.DYN.TFRT.IN)
df$SP.DYN.WFRT <- as.numeric(df$SP.DYN.WFRT)

# Doh - using ts does not work because this data has years as variables
tsdata <- ts(df,start=c(1967,1),frequency=1)

# Time series graph 1967-2015 (no data avaiable yet for 2016)
ts.plot(tsdata[,'totrev'],ylab="Total Revenue",xlab="Year")
ts.plot(tsdata[,'revpassmiles'],ylab="Revenue Passenger Miles",xlab="Year")




