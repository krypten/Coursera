source("rankhospital.R")

rankall <- function( outcome, num = "best") {
  ## Read outcome data
  f <- file(file.path(getwd() , "outcome-of-care-measures.csv"))
  outcomes <- read.csv(f, colClasses = "character")
  
  
  dt <- data.frame(hospital=NA, state=NA)
  states <- unique(outcomes$State)
  states <- sort(states)
  for (i in 1:length(states)) {
    dt[i,] <- c(rankhospital(states[i], outcome, num), states[i])
  }
  dt
}