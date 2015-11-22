library(jsonlite)
library(reshape2)
library(plyr)
library(dplyr)

# load business dataset
business <- stream_in(file("data/yelp_academic_dataset_business.json"), flatten=FALSE)

# load checkin dataset
checkin <- stream_in(file("data/yelp_academic_dataset_checkin.json"), flatten=FALSE)
checkin <- flatten(checkin, recursive=TRUE)

# transpose checkin data
m.checkin <- melt(checkin[,-1], na.rm=TRUE)
colnames(m.checkin) <- c("business_id", "period", "checkin_count")

# transform period column into day of the week
m.checkin$period <- sapply(strsplit(as.character(m.checkin$period), split='.', fixed=TRUE), function(x) (x[2]))
m.checkin$period <- sapply(strsplit(as.character(m.checkin$period), split='-', fixed=TRUE), function(x) (x[2]))
m.checkin$day <- as.factor(m.checkin$period)
m.checkin$day <- revalue(m.checkin$day, c("1"="Monday", "2"="Tuesday", "3"="Wednesday", "4"="Thursday", "5"="Friday", "6"="Saturday", "0"="Sunday"))

# merge business and checkin datasets
a.checkin <- aggregate(checkin_count ~ business_id+day, data = m.checkin, FUN = sum)
bus.checkin <- inner_join(a.checkin, business[,c("business_id","name","categories","state")])
# melted <- melt(df[,c(7,3,4)], na.rm=TRUE)
# colnames(melted) <- c("state", "count_type", "total")
# mdf <- aggregate(total ~ state+count_type, data = melted, FUN = sum)

# flatten and cleanup data for business attributes
bus.attr <- flatten(business[,c(1,14)], recursive=TRUE)
bus.attr <- data.frame(lapply(bus.attr, as.character), stringsAsFactors=FALSE)
bus.attr[,-1][bus.attr[,-1] == "FALSE"] <- NA
bus.attr[,-1][bus.attr[,-1] == "NULL"] <- NA
bus.attr[,-1][bus.attr[,-1] == "none"] <- NA
bus.attr[,-1][bus.attr[,-1] == "no"] <- NA
bus.attr[,-1][bus.attr[,-1] == "list()"] <- TRUE
names(bus.attr) = sub("attributes.","",names(bus.attr))
bus.long <-  melt(bus.attr,id="business_id",variable.name="attribute",na.rm =TRUE)

# create dataframe for business attributes
bus.set1 <- bus.long[bus.long$value==TRUE,]
bus.set2 <- bus.long[bus.long$value!=TRUE,]
bus.set1$attributes <- bus.set1$attribute
bus.set2$attributes <- paste(bus.set2$attribute, bus.set2$value, sep=":")
bus.combined <- rbind(bus.set1[,c(1,4)], bus.set2[,c(1,4)])
bus.wide <- aggregate(attributes~business_id, paste, data=bus.combined)

# merge all datasets
df <- left_join(bus.checkin, bus.wide)

# save dataframe
save(df, file="data/saveddata.RData")
save(business, checkin, file="data/checkin.RData")