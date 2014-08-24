complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  x <- NULL 
  for(i in id) {
    if (i < 10) {
      filename <- paste("00", i, ".csv", sep="")
    } else if (i < 100) {
      filename <- paste("0", i, ".csv", sep="")
    } else {
      filename <- paste(i, ".csv", sep="")
    }
    
    f <- file(file.path(getwd() , paste(directory, "/", filename , sep="")))
    dt <- data.frame(read.csv(f))
    
    good <- complete.cases(dt)
    tmp <- subset(dt , good)
    x <- rbind(x, c(i , nrow(tmp)))
  }
  data.frame(id = x[,1], nobs = x[,2])
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
}