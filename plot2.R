### Preparation

setwd("~/ExploratoryDataAnalysis/Exploratory Data Analysis/Week 1")
library(dplyr)
library(lubridate)

### 0. Properly read the source files

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "Dataset.zip")
unzip("Dataset.zip")

data <- tbl_df(read.csv("household_power_consumption.txt", header=TRUE, sep=";"))

### 1. Subset to only two days: 2007-02-01 and 2007-02-02

# Transform the Date column into proper date type
data <- mutate(data, Date=dmy(Date))

# Filter to the selected two-day period
period <- interval(ymd("2007-02-01"),ymd("2007-02-02"))
data <- filter(data, Date %within% period)
rm(period) # Cleanup

# Give columns a proper data type
data <- mutate_each(data, funs(as.character), -Date) %>% mutate_each(funs(as.numeric), -Date, -Time)

# Introduce combined datetime column
data <- mutate(data, datetime=ymd_hms(paste(Date, Time)))

### Plots


# Plot2
with(data, plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

dev.copy(png, file="plot2.png") # write to png, default is 480x480 on white background
dev.off()
