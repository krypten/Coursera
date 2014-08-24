rankhospital <- function(state, outcome, rank) {
  ## Read outcome data
  f <- file(file.path(getwd() , "outcome-of-care-measures.csv"))
  outcomes <- read.csv(f, colClasses = "character")
  
  ## Check that state and outcome are valid
  x <- subset(outcomes,outcomes[,7] == state)
  if (!(nrow(x) > 0)) {
    stop(" invalid state")
  }
  id <- NULL
  if(outcome == "heart attack") {
    id <- 11
  } else if (outcome == "pneumonia") {
    id <- 23
  } else if (outcome == "heart failure") {
    id <- 17
  } else {
    stop(" invalid outcome")
  }
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  x[, id] <- as.numeric(x[, id])
  
  if (rank == "worst") {
    y <- sort(x[,id], decreasing = TRUE)
    rank <- 1
  } else {
    if (rank == "best") {
      rank <- 1
    }
    y <- sort(x[,id])
  }
  
  d <- subset(x, x[,id] == y[rank])
  d <- sort(d$Hospital.Name)
  d[1]
}