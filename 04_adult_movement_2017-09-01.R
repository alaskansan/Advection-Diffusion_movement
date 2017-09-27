print ("Adult Movement")

library(truncnorm)
print("truncnorm library loaded")

library(matrixStats)
print("matrixstats library loaded")

## define the function
MoveAdultsR <- function(distmat, nfish, r, std.dev, TBup, TBdown){
   HUdim = nrow(distmat)
   if(is.vector(nfish)) nfish <- as.matrix(nfish)
   SRCdim <- ncol(nfish)
   pmove <- array(0, dim <- c(HUdim, HUdim, SRCdim))
   distmat <- rbind(distmat, "0" = (distmat[HUdim, ] - 2*distmat[HUdim, HUdim]))
   for(i in 1:SRCdim){
      trncUp <- pmin(distmat[1, ], r[, i] + std.dev[, i] * 3, TBup)
      trncDown <- pmax((distmat[HUdim, ] - 2 * distmat[HUdim, HUdim]),(r[, i] - std.dev[, i] * 3))
      trncUp <- matrix(trncUp, nrow = nrow(distmat), ncol = HUdim, byrow = T)
      trncDown <- matrix(trncDown, nrow = nrow(distmat), ncol = HUdim, byrow = T)
      r.temp <- matrix(r[, i], nrow =nrow(distmat), ncol = HUdim, byrow = T)
      std.dev.temp <- matrix(std.dev[, i], nrow = nrow(distmat), ncol = HUdim, byrow = T)
      nfish.temp <- matrix(nfish[, i], nrow = nrow(distmat), ncol = HUdim, byrow = T)
      doCalc <- nfish.temp > 0
      cumProb <- matrix(0, nrow = nrow(distmat), ncol = HUdim)
      cumProb[doCalc] <- ptruncnorm(q = distmat[doCalc],
                          a <- trncDown[doCalc],
                          b <- trncUp[doCalc],
                          mean <- r.temp[doCalc],
                          sd <- std.dev.temp[doCalc])
      cumProb[NaN] <- 0.0001
      cumProb <- matrix(cumProb, nrow = nrow(distmat), ncol = HUdim)
      pmove[,,i] <- colDiffs(cumProb[(HUdim+1):1,])[HUdim:1,]
   }
   return(pmove)
}



## ****** create population of fish entering by date *******
# weekly.probs<- c(0.01571318, 2.161461102, 18.39696222, 44.00499779, 25.2802413, 9.49360827, 0.647016147)
# daily.probs<- weekly.probs/7
# daily.probs<- rep(daily.probs, each = 7)
# length(daily.probs)

# #initialize the N0 vector
# N0 <- rep(0, length(Date))
# #insert the starting abundances at the appropriate start date
# N0[strtInd:(strtInd + length(N0temp) - 1)] <- N0temp
#N0[1:4000]

# ## This matrix will hold the results of your simulation. Basically, the number
# ## of adults in each HU on each day.  Initialize with zeros
# Nadults <- matrix(0,  nrow = HUdim, ncol = Ddim)

## Run movement model for each day
# Note the loop counter is selecting the appropriate date indices

for(i in strtInd:(strtInd + nRunDays)){
  # add incoming fish (N0) to fish already in first habitat unit of Nadults
  Nadults[HUdim, i] = Nadults[HUdim, i] + N0[i]
  MR = MoveAdultsR(distmat = Dist, nfish = Nadults[, i], r = mig.rate,
            std.dev = sigma, TBup = UpperBarr[, i], TBdown = LowerBarr[, i])
  MR = MR[,,1]
  # Now move them
  Nadults[, i+1] = MR %*% Nadults[, i]
}
# colSums(Nadults)

## create plots
## uncomment line below when not running in RStudio
# windows(); bringToTop(stay = T)

for(i in strtInd:(strtInd + nRunDays)){
   Sys.sleep(time = 0.25)
   plot(HUdim:1, Nadults[, i], ylim = c(0, 5000), type = "h", lwd = 3,
      main = paste("Day", i))
   write(Nadults[,i], file = )
   abline(2000,0, col = "red")
}
