# load saved data
load("data/saveddata.RData")

# Define filter functions for common business categories
excludeairport <- function(x) {
  result <- x[-grep("Airport", x$name),]
  return(result)
}

excludehotel <- function(x) {
  airports <- x[grep("Airport", x$name),]
  nonhotels <- x[-grep("Hotels", x$categories),]
  result <- rbind(airports, nonhotels)
  result <- result[!duplicated(result),]
  return(result)
}

excluderestaurant <- function(x) {
  result <- x[-grep("Restaurants", x$categories),]
  return(result)
}