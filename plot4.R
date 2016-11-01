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


# Plot4
# Determine 2x2 graphs, fill by col
par("mfcol"=c(2,2))

# upper-left plot
with(data, plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

# bottom-left plot
with(data, plot(datetime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", col="black"))
with(data, lines(datetime, Sub_metering_2, col="red"))
with(data, lines(datetime, Sub_metering_3, col="blue"))
# draw a legend, but this time with bty="n" to disable the surrounding box
legend("topright", bty="n", lty = 1, lwd = 1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"))

# Top-right plot
with(data, plot(datetime, Voltage, type="l"))

# Bottom-right plot
with(data, plot(datetime, Global_reactive_power, type="l"))

# Store the plot
dev.copy(png, file="plot4.png") # write to png, default is 480x480 on white background
dev.off()
