library(tidyverse)
library(lubridate)
library(here)

#import data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, 
              destfile = here("electric_power_consumption.zip"), 
              method = "curl")
unzip("electric_power_consumption.zip")              
consumption <- read.csv("household_power_consumption.txt", sep = ";", stringsAsFactors = F)

#clean data
consumption$Date <- lubridate::dmy(consumption$Date)
plotting <- consumption %>% 
        filter(Date == "2007-02-01" | Date == "2007-02-02")

plotting <- plotting %>% 
        mutate(DateTime = paste(Date, Time)) 
plotting$DateTime <- ymd_hms(plotting$DateTime)

chars <- sapply(plotting, is.character)
plotting[ , chars] <- as.data.frame(apply(plotting[ , chars], 2, as.numeric))
rm(consumption)

#save plot as PNG
png(filename = "plot4.png")
par(mfrow = c(2,2), mar = c(4,4,2,1))
#plot 1,1
with(plotting, plot(Global_active_power~DateTime,
                    type = "l",
                    ylab = "Global Active Power",
                    xlab = ""))
#plot 1,2
with(plotting, plot(Voltage~DateTime,
                    type = "l",
                    ylab = "Voltage"))
#plot 2,1
with(plotting, plot(Sub_metering_1~DateTime,
                    type = "l",
                    ylab = "Energy sub metering",
                    xlab = ""))
with(plotting, points(Sub_metering_2~DateTime,
                      type = "l",
                      col = "red"))
with(plotting, points(Sub_metering_3~DateTime,
                      type = "l",
                      col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex = 0.50, bty = "n")
#plot 2,2
with(plotting, plot(Global_reactive_power~DateTime,
                    type = "l",
                    ylab = "Global_reactive_power"))
dev.off()
