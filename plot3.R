#############################################################
# The goal of this script is to represent the data from the file 
###############################################################


###############################
# Step 1 : reading of the file. 
###############################

# Stores the columns as characters. Then easier to convert to atomic types (conversion from factor to numeric is based on the modalities)
# No explicit conversion to appropriate types in read.table as it generates a scan error (presence of ? chars on some lines)
library(readr)
library(lubridate)
df_power_cons <- read.table("household_power_consumption.txt",header=TRUE,sep=";",as.is=TRUE, dec=".")

# Conversion of column from character type to appropriate type; Dates are hours are concatenated to build a single field 
DateTime <- dmy_hms(paste(df_power_cons$Date,df_power_cons$Time))
Global_active_power_Num <-  as.numeric(df_power_cons$Global_active_power)
Global_reactive_power_Num <- as.numeric(df_power_cons$Global_reactive_power)
Voltage_Num <- as.numeric(df_power_cons$Voltage)
Global_Intensity_Num <- as.numeric(df_power_cons$Global_intensity)
Sub_metering_1_Num <- as.numeric(df_power_cons$Sub_metering_1)
Sub_metering_2_Num <- as.numeric(df_power_cons$Sub_metering_2)
Sub_metering_3_Num <- as.numeric(df_power_cons$Sub_metering_3)

# Create Data Frame with the previous vectors, and get the complete lines. This will avoid to wonder if, on a given line, some columns are set and others not.
DF_Power_Cons <- data.frame(DateTime, Global_active_power_Num, Global_reactive_power_Num, Voltage_Num, Global_Intensity_Num, Sub_metering_1_Num, Sub_metering_2_Num, Sub_metering_3_Num)
Power_Cons_Compl <- complete.cases(DF_Power_Cons)

# Build a new data frame with complete lines
DF_Power_Cons_Compl <- DF_Power_Cons[Power_Cons_Compl,]

# Filter data to get only dates from Feb 1st 2007 to Feb 2nd 2007
DF_Final <- subset(DF_Power_Cons_Compl,DateHour >=dmy_hms("1/2/2007 00:00:00") & DateHour <dmy_hms("3/2/2007 00:00:00"))

################################
#Step 2 : Creation of the graph
################################

# Plot 3  : create graph giving the scattering of Global Active Power by day on the given period
#Define the ouput device
png("plot3.png", width = 480, height = 480, units = "px")
with(DF_Final,plot(DateTime,Sub_metering_1_Num,type='l',xlab="",ylab="Energy Sub metering"))
with(DF_Final,points(DateTime,Sub_metering_2_Num,type='l',col="red"))
with(DF_Final,points(DateTime,Sub_metering_3_Num,type='l',col="blue"))
legend("topright",col=c("black","red","blue"), legend=paste("Sub_metering",seq("1":"3"),sep="_"),lty=1)

# Close of device
dev.off()