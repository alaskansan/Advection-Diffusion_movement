## original Nadults plotting before adjusting for capacity
for(i in strtInd:(strtInd + nRunDays)){
  Sys.sleep(time = 0.25)
  plot(HUdim:1, Nadults[, i], ylim = c(0, 5000), type = "h", lwd = 3,
       main = paste("Day", i))
  write(Nadults[,i], file = )
  abline(2000,0, col = "red")
}
