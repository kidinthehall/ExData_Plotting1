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

# create the fourth plot in the analysis
# Four plots in a 2x2 matrix
par(mfrow=c(2,2),
        oma = c(0,0,0,0),
        mar = c(5.1,4.1,1,2.1)  # default is c(5.1,4.1,4.1,2.1) bot/l/top/r
    )

# plot the upper left plot
plot(hpc$DateTime, hpc$Global_active_power, type = "l", xlab = NA, ylab="Global Active Power")

# plot the upper right plot
plot(hpc$DateTime, hpc$Voltage, type = "l", xlab = "datetime", ylab="Voltage")

# plot the bottom left plot
plot(hpc$DateTime, hpc$Sub_metering_1, 
     type = "l", xlab = NA, ylab="Energy sub metering")
lines(hpc$DateTime, hpc$Sub_metering_2, col = "red")
lines(hpc$DateTime, hpc$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), cex = .7, bty = "n", 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# plot the bottom right plot

plot(hpc$DateTime, hpc$Global_reactive_power, type = "l", xlab = "datetime", 
     ylab="Global_reactive_power", yaxt = "n")
axis(2, at = seq(0, .5, by = .1))

# create the png file to store the plot
dev.copy(png, filename = "plot4.png", width = 480, height = 480, units = "px")
dev.off()
