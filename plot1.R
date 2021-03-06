# Requires plyr package

# Read Data to powerCon object
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
# End of data processing

# Plot 1
png(filename = "plot1.png",width = 480, height = 480)
par(mfrow=c(1,1))
hist(powerCon$Global_active_power,main="Global Active Power"
     ,xlab="Global Active Power (kilowatts)"
     ,col="red")
dev.off()
