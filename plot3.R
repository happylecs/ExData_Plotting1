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

#Plot  3
png(filename = "plot3.png",width = 480, height = 480)
plot(powerCon$DateTime,powerCon$Sub_metering_1,col="white"
     ,xlab="",ylab="Energy sub meeting")
lines(powerCon$DateTime,powerCon$Sub_metering_1,col="black")
lines(powerCon$DateTime,powerCon$Sub_metering_2,col="red")
lines(powerCon$DateTime,powerCon$Sub_metering_3,col="blue")
legend("topright",col=c("black","red","blue"),lty=1,
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
