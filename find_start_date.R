years <- c(1964:2011)
plot.dir<-("/Users/emilykc/Documents/thesis/R_move/Emily/Aug15/PLOTS")
my.labels <- c("08/01", "08/15", "09/01", "09/15", "09/30")
temp.x<- c(1, 15, 30, 45, 61)

##find first day of increase in Q
for(i in years){
  Q.sim.Aug1<- which(Date == (as.Date(paste(i,"-08-01", sep=""))))
  subset.Q<- Qmatrix[1678,Q.sim.Aug1:(Q.sim.Aug1 +61)]
  first.freshette<- min(which(diff(subset.Q) > 0))
  print(first.freshette)
}

for(i in years){
  Q.sim.Aug1<- which(Date == (as.Date(paste(i,"-08-01", sep=""))))
  subset.Q<- Qmatrix[1678:1706,Q.sim.Aug1:(Q.sim.Aug1 +61)]
  i<- min(which(diff(subset.Q) > 0))
  print(i)
  mean.Q <-apply(subset.Q, 2, mean)  ## actually unnecessary because all values for lower segment of river in QMatrix are the same 
  mypath <- file.path(plot.dir, paste("klamath_lower_section_temperatures_", i, ".pdf", sep=""))
  pdf(file=mypath)
  plot.title = paste("Lower 6km Klamath River Mean Discharge, ", i)
  plot(mean.Q, xaxt = "n", ylim = c(0,15000),type = "b", main = plot.title, ylab = "Discharge in CFS", xlab = paste("Dates from 8-1 to 9-30 ", i,sep=""))
  axis(1, at = temp.x, labels=my.labels)
  dev.off()
}

## user input for year of simulation
d <- readline(prompt="Enter a year for simulation (format as YYYY):")
Aug1.Sim.Year <- as.Date(paste(d,"-08-01", sep=""))
## subset Qmatrix for that year
Q.sim.Aug1<- which(Date == Aug1.Sim.Year)
## find the lowest river segment flows for Aug 1 to end of September
subset.Q<- Qmatrix[1678:1706,Q.sim.Aug1:(Q.sim.Augt1 +61)]
dim(subset.Q)

## plot mean flow for each date
mean.Q<- apply(subset.Q, 2, mean)
plot(mean.Q)
## take a closer look
plot(mean.Q[100:184])


min(which(diff(u) > 0))



## find the mean of flows to a certain point, then find the first max above this amount, basically find the first significant freshet
median.of.mean.Q <- median (mean.Q)
median.of.mean.Q
freshette <- min(which(mean.Q > median.of.mean.Q))
freshette

StartDate <- Q.sim.Sept1 + freshette


StartDate<-which(Date == StartDate)

## to delete all vars:
rm(Q.sim.Sept1, Sept1.Sim.Year, freshette, mean.Q, median.of.mean.Q, subset.Q, d)