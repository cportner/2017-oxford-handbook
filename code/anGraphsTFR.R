# Graph for changes in TFR 
# For Fertility Issues chapter in Oxford handbook
# Claus C Portner
# Begun.: 2017-02-10
# Edited: 2017-05-19

library(tidyr)
library(tidyverse)
library(ggplot2)
library(directlabels) # don't really need this

# Variable definitions
# SP.DYN.TFRT.IN	Fertility rate, total (births per woman)
# SP.DYN.WFRT	    Wanted fertility rate (births per woman)
# SP.ADO.TFRT	    Adolescent fertility rate (births per 1,000 women ages 15-19)
# SH.DYN.MORT	    Mortality rate, under-5 (per 1,000 live births)
# SH.DYN.MORT.MA	Mortality rate, under-5, male (per 1,000 live births)
# SH.DYN.MORT.FE	Mortality rate, under-5, female (per 1,000 live births)

# Country codes
# Latin America & the Caribbean (IDA & IBRD countries)	TLA
# Middle East & North Africa (IDA & IBRD countries)	TMN
# IDA & IBRD total	IBT
# Europe & Central Asia (IDA & IBRD countries)	TEC
# East Asia & Pacific (IDA & IBRD countries)	TEA
# South Asia (IDA & IBRD)	TSA
# Sub-Saharan Africa (IDA & IBRD countries)	TSS

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

tfrPlot <- ggplot(data = df, aes(x=year, y=SP.DYN.TFRT.IN, fill  = Country.Code, color = Country.Code)) + 
  geom_line(size=1.5) + # Thicker line
  scale_y_continuous(expand = c(0, 0), limits = c(0,8)) + # better way of 0 in TFR
  xlab("Year") + ylab("Total Fertility Rate") + # Pretty labels
  ggtitle("Changes in Total Fertility Rate by Region - 1967-2015") +
  scale_colour_discrete(name = "Regions",
                        labels = c("Overall", "East Asia & Pacific", "Europe & Central Asia", 
                                   "Latin America & the Caribbean", "Middle East & North Africa", 
                                   "South Asia", "Sub-Saharan Africa" )) +
  guides(color = guide_legend(ncol = 2)) +
  theme_bw() +
  theme(legend.position = c(.25, .15))
  
tfrPlot + geom_hline(aes(yintercept = 2.1), linetype = "dashed", colour = "red") # pretty line for replacement fertility

tfrPlot

ggsave(file.path(figureDir,"totalFertilityRates.pdf"), device = "pdf")

# Graph for mortality

mortalityPlot <- ggplot(data = df, aes(x=year, y=SH.DYN.MORT, fill = Country.Code, color = Country.Code)) +
  geom_line(size=1.5) + # Thicker line
  xlab("Year") + ylab("Mortality Rate, Under-5 (per 1,000 live births)") + # Pretty labels
  ggtitle("Changes in Child Mortality Rate by Region - 1967-2015") +
  scale_y_continuous(expand = c(0, 0), limits = c(0,275), breaks = c(50,100,150,200,250)) + # better way of 0 in TFR
  scale_colour_discrete(name = "Regions",
                        labels = c("Overall", "East Asia & Pacific", "Europe & Central Asia", 
                                   "Latin America & the Caribbean", "Middle East & North Africa", 
                                   "South Asia", "Sub-Saharan Africa" )) +
  guides(color = guide_legend(ncol = 2)) +
  theme_bw() +
  theme(legend.position = c(.75, .83))

mortalityPlot 
  
ggsave(file.path(figureDir,"childMortalityRates.pdf"), device = "pdf")


# Black and white TFR graph

# Need dataframe without overall and 2015 
bwDF <- filter(df, year != 2015 & Country.Code != "IBT")

theme_set(theme_bw())
bwTFR <- ggplot(data = bwDF,
                aes(x = year, y = SP.DYN.TFRT.IN, 
                    linetype = Country.Code))

bwTFR <- bwTFR + geom_line(size=1.5)

# bwTFR <- bwTFR +   xlab("Year") + ylab("Total Fertility Rate") + # Pretty labels
#   ggtitle("Changes in Total Fertility Rate by Developing Region - 1967-2015")

bwTFR <- bwTFR +   xlab("Year") + ylab("Total Fertility Rate") +
  labs(caption = "Data source: World Development Indicators 2017")  # Pretty labels

bwTFR <- bwTFR + scale_y_continuous(expand = c(0, 0), limits = c(0,8)) # better way of 0 in TFR

bwTFR <- bwTFR +  scale_linetype_discrete(name = "Regions",
                                        labels = c("East Asia & Pacific", "Europe & Central Asia", 
                                                    "Latin America & the Caribbean", "Middle East & North Africa", 
                                                    "South Asia", "Sub-Saharan Africa" ))

bwTFR <- bwTFR + guides(linetype = guide_legend(ncol = 2)) + 
  theme(legend.position = c(.28, .14), legend.key.width = unit(1.5, "cm"))

bwTFR <- bwTFR + geom_hline(aes(yintercept = 2.1), linetype = "dashed") # pretty line for replacement fertility

bwTFR

ggsave(file.path(figureDir,"totalFertilityRatesBW.pdf"), device = "pdf")


# Black and white mortality graph

theme_set(theme_bw())
bwMort <- ggplot(data = bwDF,
                aes(x = year, y = SH.DYN.MORT, 
                    linetype = Country.Code))

bwMort <- bwMort + geom_line(size=1.5)

# bwMort <- bwMort +   xlab("Year") + ylab("Total Fertility Rate") + # Pretty labels
#   ggtitle("Changes in Total Fertility Rate by Developing Region - 1967-2015")

bwMort <- bwMort +   xlab("Year") + ylab("Under-five Mortality Rate (per 1,000 live births)") +
  labs(caption = "Data source: World Development Indicators 2017")  # Pretty labels

bwMort <- bwMort +   scale_y_continuous(expand = c(0, 0), limits = c(0,275), breaks = c(50,100,150,200,250)) # better way of 0 

bwMort <- bwMort +  scale_linetype_discrete(name = "Regions",
                                          labels = c("East Asia & Pacific", "Europe & Central Asia", 
                                                     "Latin America & the Caribbean", "Middle East & North Africa", 
                                                     "South Asia", "Sub-Saharan Africa" ))

bwMort <- bwMort + guides(linetype = guide_legend(ncol = 2)) + 
  theme(legend.position = c(.73, .83), legend.key.width = unit(1.5, "cm"))

bwMort

ggsave(file.path(figureDir,"childMortalityRatesBW.pdf"), device = "pdf")

