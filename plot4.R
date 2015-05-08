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



#Make plot4. "Чт" for thursday, "Пт" for friday, "Сб" for saturday
png("plot4.png", height=480, width=480, units="px")

par(mfrow=c(2,2), mar=c(4,4,2,2))
with(powerConsumptionData, {
    
    plot(powerConsumptionData$dateTime, powerConsumptionData$Global_active_power, ylab="Global Active Power (kilowatts)", type="l", xlab="")
    
    plot(powerConsumptionData$dateTime, powerConsumptionData$Voltage, ylab="Voltage", type="l", xlab="datetime")
    
    with(powerConsumptionData, plot(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering"))
    with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_1, type="l", col="black"))
    with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_2, col="red", type="l"))
    with(powerConsumptionData, points(powerConsumptionData$dateTime, powerConsumptionData$Sub_metering_3, col="#4900FF", type="l"))
    legend("topright", lwd=1, col=c("black", "red", "#4900FF"), legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), cex=.9, bty="n")
    
    plot(powerConsumptionData$dateTime, powerConsumptionData$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
})

dev.off()