# If the subsetted file doesn't exist in the unzipped subdirectory, create it
if (!file.exists("./exdata-data-household_power_consumption/household_power_consumption_subset.csv") == TRUE)
{
        library(lubridate)
        
        # import the txt file
        f      <- file("./exdata-data-household_power_consumption/household_power_consumption.txt")
        x      <- read.table(f, sep = ";", header = TRUE, na.strings = "?")
        
        # create a DateTime column
        x$DateTime <- strptime(paste(x$Date, x$Time, sep=" "), 
                               format="%d/%m/%Y %H:%M:%S")
        
        # Convert the date 
        x$Date <- as.Date(dmy(x$Date))
        
        # Subset the data using the ranges required for the analysis
        x      <- (subset(x, Date >= "2007-02-01" & Date <= "2007-02-02"))
        
        # Create a subset file to speed up future analysis
        write.csv(x, file = "./exdata-data-household_power_consumption/household_power_consumption_subset.csv")
}

# read in the subsetted csv file
hpc <- read.csv("./exdata-data-household_power_consumption/household_power_consumption_subset.csv")
hpc$DateTime <- strptime(hpc$DateTime, format="%Y-%m-%d %H:%M:%S")

# create the second plot in the analysis
par(mfrow=c(1,1))
plot(hpc$DateTime, hpc$Sub_metering_1, 
        type = "l", xlab = NA, ylab="Energy sub metering")
lines(hpc$DateTime, hpc$Sub_metering_2, col = "red")
lines(hpc$DateTime, hpc$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# create the png file to store the plot
dev.copy(png, filename = "plot3.png", width = 480, height = 480, units = "px")
dev.off()
