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
png(filename = "plot2.png")
with(plotting, plot(Global_active_power~DateTime,
                    type = "l",
                    main = "Global Active Power",
                    ylab = "Global Active Power (Kilowatts)"))
dev.off()
