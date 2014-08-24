best <- function(state, outcome) {
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
  y <- sort(x[,id])
  d <- subset(x, x[,id] == y[1])
  d$Hospital.Name[1]
}