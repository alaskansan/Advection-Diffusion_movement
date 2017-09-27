## Setup working directory ##
input.working.directory <- readline(prompt="Enter working directory path: ")
setwd(as.character(input.working.directory))
print(paste("Working directory has been set to", getwd()))
## create a directory to hold all plots
plot.dir<- dir.create("PLOTS")

## read in habitat data and S3 Klamath Q and T data ##
habitats <- read.csv("habitat18APR16.csv", stringsAsFactors = F)
habitats = habitats[habitats$UnitNum >= 930, ]
print("habitat data loaded and subsetted from ocean to IGH")

load("S3 Klamath Q and T historical 29Jan2017.Rdata")
print("Klamath Q & T data loaded")

## create Distance matrix (Dist) ##
rkm.mid <- habitats$rkm.up + diff(c(habitats$rkm.up, 0))/2
Dist <- as.matrix(outer(habitats$rkm.up, rkm.mid, "-"))
colnames(Dist) = rkm.mid
rownames(Dist) = habitats$rkm.up
print("Distance Matrix created")

## set up other variables that may change with more complexity to model but not in my thesis ##
HUdim = nrow(Dist)
Ddim = length(Date)
SRCdim = 1
print("HUdim, Ddim and SRCdim set")

## create temperature barrier matrix ##
tempbarrier <- readline(prompt="Enter temperature barrier: ") ##I will constrain to numeric format and default to 23 ##
print(paste("Temperature barrier set to", tempbarrier))
TBarr <- matrix(0, nrow = nrow(Tmatrix), ncol(Tmatrix))
TBarr<- as.logical(TBarr)
TBarr <- matrix(TBarr, nrow = nrow(Tmatrix), ncol(Tmatrix))
dimnames(TBarr)<- list(habitats$UnitNum,colnames(Tmatrix))
#tempbarrier<- 21
barrier<- Tmatrix > tempbarrier
TBarr[barrier]<-TRUE
UpperBarr <- matrix(Dist[1,], nrow = nrow(Tmatrix), ncol = ncol(Tmatrix))
dimnames(UpperBarr)<-list(habitats$UnitNum,colnames(Tmatrix))   
LowerBarr<-matrix(Dist[HUdim, ], nrow = nrow(Tmatrix), ncol = ncol(Tmatrix))
dimnames(LowerBarr)<-list(habitats$UnitNum, colnames(Tmatrix))
TB.idx = which(TBarr==TRUE, arr.ind = T)  ##looks for TRUE in TBlock and return row (location/HU) and col(date) index of all TRUE, in 2 columns which is a little confusing
TBDate.idx <- unique(TB.idx[,2])
#-- Loop over all dates with a temp barrier and insert into TBarr
for(i in TBDate.idx){
  TBidx.temp <- TB.idx[TB.idx[,2] == i, ]
  Dist2TB <- Dist[TBidx.temp[,1], ]
  Dist2TBdown <- Dist2TB
  Dist2TBdown[Dist2TBdown > 0] <- -9999
  closestTBdown <- apply(Dist2TBdown, 2, max)
  # uncomment line below to double check that it's working as intended.
  #cbind(closestTBdown, LowerBlock[, i], pmax(closestTBdown, LowerBlock[, i]))
  LowerBarr[, i] <- pmax(closestTBdown, LowerBarr[, i])
  Dist2TBup <- Dist2TB
  Dist2TBup[Dist2TBup < 0] <- 9999
  closestTBup <- apply(Dist2TBup, 2, min)
  # uncomment line below to double check that it's working as intended.
  #cbind(closestTBup, UpperBarr[, i], pmin(closestTBup, UpperBarr[, i]))
  UpperBarr[, i] <- pmin(closestTBup, UpperBarr[, i])
}
rm(closestTBdown, closestTBup)
print("Temperature barrier matrix created")

# refuge.unit.nums <-c(2205,2235,2252,2257,2275,2326,2340,2382,2392,2440,2509)
# segment.1 <- (2607:2635)
# segment.2 <- (2507:2606)
# segment.3 <- (2312:2506)
# segment.4 <- (930:2311)
# salmon.river <- (2132)
# scott.river <- (1436)
# shasta.river <- (1060)
# bogus.creek <- (932)

## Determine movement rates based on habitat unit
## Need to make these vary with each simulation run for model calibration

unit.num <- sort(habitats$UnitNum, decreasing=TRUE) ### the backward math was confusing me
segment.rates <- unit.num

segment.rates <- ifelse(unit.num>2606 & unit.num<2636,1.0,
                        ifelse (unit.num>2506 & unit.num<2607,9.0,
                                ifelse(unit.num>2311 & unit.num<2507 ,3.8, 14.0)))
mig.rate = matrix(segment.rates, nrow = nrow(Dist), ncol = SRCdim)
sigma.rates <- ifelse(unit.num>2606 & unit.num<2636,1.0,
                      ifelse (unit.num>2506 & unit.num<2607,9.0,
                              ifelse(unit.num>2311 & unit.num<2507 ,3.8, 14.0)))
sigma <- matrix(sigma.rates, nrow = HUdim, ncol = SRCdim)