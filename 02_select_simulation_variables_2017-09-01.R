n <- readline(prompt="Enter number of days to simulate: ")
nRunDays <- as.integer(n)

print(paste("Adult Migration Model will run for ", nRunDays, "days, starting on", StartDate))

strtInd <- which(Date == StartDate)
print(paste("Simulation dates are:", min(Date[strtInd:(strtInd + nRunDays)]), "to", max(Date[strtInd:(strtInd + nRunDays)])))

weekly.probs<- c(0.01571318, 2.161461102, 18.39696222, 44.00499779, 25.2802413, 9.49360827, 0.647016147)
daily.probs<- weekly.probs/7
daily.probs<- rep(daily.probs, each = 7)
length(daily.probs)

run.size <- readline(prompt = "Enter a total run size:")
run.size <- as.integer(run.size)
N0temp <- rmultinom(n = 1, size = run.size, prob = daily.probs)

#initialize the N0 vector
N0 <- rep(0, length(Date))
#insert the starting abundances at the appropriate start date
N0[strtInd:(strtInd + length(N0temp) - 1)] <- N0temp


## This matrix will hold the results of your simulation. Basically, the number
## of adults in each HU on each day.  Initialize with zeros
Nadults <- matrix(0,  nrow = HUdim, ncol = Ddim)