# Graph for changes in TFR 
# For Fertility Issues chapter in Oxford handbook
# Claus C Portner
# Begun.: 2017-02-10
# Edited: 2017-02-13

library(tidyr)
library(ggplot2)
library(directlabels)

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

# Graph for TFR
# This is a pretty good start, but need legends fixed
p <- ggplot(data = df, aes(x=year, y=SP.DYN.TFRT.IN, group  = Country.Code, color = Country.Code)) + 
  geom_line(size=1.5) + # Thicker line
  scale_y_continuous(expand = c(0, 0), limits = c(0,8)) + # better way of 0 in TFR
  xlab("Year") + ylab("Total Fertility Rate") + # Pretty labels
  ggtitle("Changes in Total Fertility Rate by Region - 1967-2015") +
  scale_colour_hue(name = "Region") + # Set legend title
  theme_bw() +
  theme(legend.position = c(.2, .2))


# Labels at end of lines, problem is very difficult to see
p1 <- ggplot(data = df, aes(x=year, y=SP.DYN.TFRT.IN, group  = Country.Code, color = Country.Code)) + 
  geom_line(size=1.5) + # Thicker line
  scale_y_continuous(expand = c(0, 0), limits = c(0,8)) + # better way of 0 in TFR
  xlab("Year") + ylab("Total Fertility Rate") + # Pretty labels
  ggtitle("Changes in Total Fertility Rate by Region - 1967-2015")

p1 <- p1 + geom_dl(aes(label = Country.Code), 
                   method = "last.points", cex = 0.8)
  
p1


