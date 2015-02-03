# Read Data to powerCon object
# Requires plyr package
library(plyr)
fileConn <- file("household_power_consumption.txt")
lines<-readLines(fileConn)
close(fileConn)

dates<-as.Date(strptime(c("2007-02-01","2007-02-02"),"%Y-%m-%d"))
powerCon <- ldply(2:2075259,function(line){
  dataLine <- strsplit(lines[line],split=";")[[1]]
  if(as.Date(strptime(dataLine[1],"%d/%m/%Y")) %in% dates){
    return (dataLine)
  }
})

names(powerCon)<-strsplit(lines[1],split=";")[[1]]
rm(lines)

powerCon$DateTime <- strptime(
  paste(powerCon$Date,powerCon$Time),"%d/%m/%Y %H:%M:%S")
powerCon[,c(3:9)]<-as.data.frame(lapply(powerCon[,c(3:9)],as.numeric))

#Plot  4
png(filename = "plot4.png",width = 480, height = 480)

par(mfrow=c(2,2))
plot(powerCon$DateTime,powerCon$Global_active_power,col="white"
     ,xlab="",ylab="Global Active Power")
lines(powerCon$DateTime,powerCon$Global_active_power)

plot(powerCon$DateTime,powerCon$Voltage,col="white"
     ,xlab="datetime",ylab="Voltage")
lines(powerCon$DateTime,powerCon$Voltage)

plot(powerCon$DateTime,powerCon$Sub_metering_1,col="white"
     ,xlab="",ylab="Energy sub meeting")
lines(powerCon$DateTime,powerCon$Sub_metering_1,col="black")
lines(powerCon$DateTime,powerCon$Sub_metering_2,col="red")
lines(powerCon$DateTime,powerCon$Sub_metering_3,col="blue")
legend("topright",col=c("black","red","blue"),lty=1,bty = "n"
       ,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       ,cex=.9)

plot(powerCon$DateTime,powerCon$Global_reactive_power,col="white"
     ,xlab="datetime",ylab="Global_reactive_power")
lines(powerCon$DateTime,powerCon$Global_reactive_power)

dev.off()
