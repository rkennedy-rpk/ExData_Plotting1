library(tidyverse)
library(here)

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(URL, 
              destfile = here("electric_power_consumption.zip"), 
              method = "curl")
unzip("electric_power_consumption.zip")              
consumption <- read.csv("household_power_consumption.txt", sep = ";")
consumption$Date <- lubridate::dmy(consumption$Date)


plotting <- consumption %>% 
        filter(Date == "2007-02-01" | Date == "2007-02-02")
plotting$Time <- lubridate::hms(plotting$Time) #this might not have been the right call
str(plotting$Time)
