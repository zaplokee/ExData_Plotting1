library(dplyr)

#Download and read source data
if(!file.exists("exdata_data_household_power_consumption.zip")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="exdata_data_household_power_consumption.zip")
    accesstime<-date()
    if(!file.exists("household_power_consumption.txt")) {
        unzip("exdata_data_household_power_consumption.zip") 
    }    
}
readedData<-read.table(file="household_power_consumption.txt", sep=";", nrows=2075259, stringsAsFactors=F, header=T, na.strings="?")

#Create new dataset with only information for the dates 2007-02-01 and 2007-02-02
powerConsumptionData<-filter(readedData, Date=="1/2/2007" | Date=="2/2/2007")

#Create new variable with full date and time of observation in POSIXlt format
powerConsumptionData<-mutate(powerConsumptionData, dateTime=paste(Date, Time, sep=" "))
powerConsumptionData$dateTime<-strptime(powerConsumptionData$dateTime, format="%d/%m/%Y %H:%M:%S")

#Check if there any missing values
print(anyNA(powerConsumptionData))



#Make plot3
png("plot3.png", height=480, width=480, units="px")

par(mar=c(4,4,2,2))
with(powerConsumptionData, plot(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering"))
with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_1, type="l", col="black"))
with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_2, col="red", type="l"))
with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_3, col="#4900FF", type="l"))
legend("topright", lwd=1, col=c("black", "red", "#4900FF"), legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), cex=.9)

dev.off()