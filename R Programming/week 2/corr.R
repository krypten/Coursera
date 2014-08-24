corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  data <- complete(directory)
  d <- subset(data, data[,2] >= threshold)
  id <- d[,1]
  
  
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
    dt <- read.csv(f)
    
    good <- complete.cases(dt)
    tmp <- subset(dt , good)
    x <- rbind(x, c(cor(tmp["sulfate"], tmp["nitrate"])))
  }
  
  x <- c(x[,1])
  x[!is.na(x)]
}