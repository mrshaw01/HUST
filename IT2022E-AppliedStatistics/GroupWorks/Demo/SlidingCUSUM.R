library(reshape2)
library(lubridate) # for working with Times
library(ggplot2)  # for creating graphs
library(scales)   # to access breaks/formatting functions
library(gridExtra) # for arranging plots
library(tidyverse) # for add row

# Set Working Directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

# Get data
btcusdt <- read.csv(file = "btcusdt-1m-07-2021.csv", skip = 0, head = TRUE, sep=";")
btcusdt$Time <- as.POSIXct(btcusdt$StartTimeStamp/1000, origin="1970-01-01")

# Use small piece of data that have sidewave trend
btcusdt <- btcusdt[151:600, ]

# Plot trend line
ggplot(btcusdt, aes(Time, Close)) + geom_line(na.rm=TRUE) + stat_smooth(colour="green") + ggtitle("RAW DATA CHART")

# Init
Lw <- 50
T <- 0.01

# Pre plot
data <- data.frame(time = NA, Close = NA, Type = NA)
for (i in 1: nrow(btcusdt)){
  data <- data %>% add_row(
    time = btcusdt$Time[i], 
    Close = btcusdt$Close[i], 
    Type = "RawData")
  data <- data %>% add_row(
    time = btcusdt$Time[i] ,
    Close = mean(btcusdt$Close[max(1,(i-Lw+1)):i]), 
    Type = "Wmean")
  data <- data %>% add_row(
    time = btcusdt$Time[i], 
    Close = mean(btcusdt$Close[max(1,(i-Lw+1)):i])*(1+T), 
    Type = "Upthreshold")
  data <- data %>% add_row(
    time = btcusdt$Time[i], 
    Close = mean(btcusdt$Close[max(1,(i-Lw+1)):i])*(1-T), 
    Type = "Downthreshold")
}
data <- data[-1, ]
ggplot(data, aes(x = time, y=Close, color = Type)) + geom_line() + ggtitle("SMOOTH CHART")

# Cusum
SUPPER <- 0 
SLOWER <- 0
LMW <- c()
LDW <- c()
LMDW <- c()
LSU <- c()
LSL <- c()
for (i in Lw: nrow(btcusdt)){
  MW <- mean(btcusdt$Close[max(1,(i-Lw+1)):i])
  DW <- sqrt(var(btcusdt$Close[max(1,(i-Lw+1)):i]))  
  LMW <- c(LMW, MW)
  LDW <- c(LDW, DW)
  LMDW <- c(LMDW, mean(LDW))
  tmp <- SUPPER+MW-1.5*mean(LDW)-mean(LMW)
  SUPPER <- max(0, tmp)
  tmp <- SLOWER+MW+1.5*mean(LDW)-mean(LMW)
  SLOWER <- min(0, tmp)
  LSU <- c(LSU, SUPPER)
  LSL <- c(LSL, SLOWER)
  if (SUPPER > mean(LDW)){
    print("Upper threshold reached")
    num <- i
    print(i)
    break
  }
  if (SLOWER < -mean(LDW)){
    print("Lower theshold reached")
    num <- i
    print(i)
    break
  }
}
df1 <- data.frame(time = btcusdt$Time[(Lw+1):(num+1)], value = LMDW[1:(num-Lw+1)], flag = "UPPER THRESHOLD")
df2 <- data.frame(time = btcusdt$Time[(Lw+1):(num+1)], value = -LMDW[1:(num-Lw+1)], flag = "LOWER THRESHOLD")
df3 <- data.frame(time = btcusdt$Time[(Lw+1):(num+1)], value = LSU[1:(num-Lw+1)], flag = "CUSUM POS")
df4 <- data.frame(time = btcusdt$Time[(Lw+1):(num+1)], value = LSL[1:(num-Lw+1)], flag = "CUSUM NEG")
df <- rbind(df1 , df2, df3, df4)

# Cusum chart
ggplot(df, aes(x = time, y=value, color = flag)) + geom_line() + ggtitle("CUSUM CHART")

# Detected timestamp
ggplot(btcusdt[1:num, ], aes(Time, Close)) + geom_line(na.rm=TRUE) + stat_smooth(colour="green") + ggtitle("DETECTED TIMESTAMP CHART")

