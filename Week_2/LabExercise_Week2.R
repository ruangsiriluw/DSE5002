

library(stringr)
library(lubridate)
library(forcats)


#Ex1 and 2=========

sales <- read.delim("Week_2/Data/sales_pipe.txt"
                    ,stringsAsFactors=FALSE
                    ,sep = "|"
)
str(sales)
colnames(sales) [1] = "Row.ID"

str(sales)

#Ex3 convert Order.ID and Order.Date to date vectors

str(sales)
is.Date(sales$Order.Date)
sales$Order.Date <- as.Date(sales$Order.Date
                                ,format='%m/%d/%Y'
)

#??? lubridate convert results to year direction not possible with
#just subtraction 2 vectors.  Only can convert to days/wks with "difftime"
oldest_order <- min(sales$Order.Date)
newest_order <- max(sales$Order.Date)

#change unit of difftime to days, weeks (but no years)
day_diff <- difftime(newest_order, oldest_order,
         units = "days")
print(day_diff)

#for weeks change unit to weeks
wk_diff <- difftime(newest_order, oldest_order,
                     units = "weeks")
print(wk_diff)


# For years, redo with interval and divided by yrs
day_intv <- interval(newest_order, oldest_order)

yr_intv <- as.period(day_intv) / years(1)
print(yr_intv)

#If convert to numeric first, that can be done with "duration"
numdays <- as.numeric(newest_order - oldest_order)
numdays
str(numdays)

duration(numdays, "days")


# Ex 4==============
# convert ship date to date category 
sales$Ship.Date <- mdy(sales$Ship.Date)

# create a vector from Ship Date and Order Date
ord_date <- sales$Order.Date
shp_date <- sales$Ship.Date

shippingdays <- difftime(shp_date, ord_date, 
                         units = "days")

mean(shippingdays)

# Ex 5===========
#create matrix with customer name only and split into first and last name

cust_firstlast <- stringr::str_split_fixed(string = sales$Customer.Name
                                           , pattern = " ", n=2)
colnames(cust_firstlast) = c("first", "last")

 #Add each column [, 1] = column1,  back to sales original data frame
sales$Customer.First <- cust_firstlast[ ,1]
sales$Customer.Last <- cust_firstlast[ ,2] 

#Use string subsetting to call out Bill into a vector
bill_vector <- str_subset(string = sales$Customer.First, pattern = "Bill", negate = FALSE)
length(bill_vector)


# DO NOT NEED THIS:  Subsetting Bill into vector, then count length where 
firstname <- sales$Customer.First == "Bill"
length(firstname[firstname == TRUE])


# Ex6==================
length(str_subset(string = sales$Sub.Category
                  , pattern = "Tables"
                  , negate = FALSE))


#  Ex7=================
# call for unique element in State
unique(sales$State)
# change to Factor
sales$State <- factor(sales$State)
is.factor(sales$State)

#Order alphabetical and make a table
levels(sales$State)
statetable <- table(sales$State)

# Ex 8 ======================

#create a subset dataframe of Tx and factor Category
sales_tx_df = sales[sales$State == "Texas", ]
sales_tx_df$Category <- factor(sales_tx_df$Category)

#order alphabetically and barplot
levels(sales_tx_df$Category)
barplot(table(sales_tx_df$Category))


#Ex 9==========================
?aggregate
aggregate(x = sales$Profit, by = list(sales$Region), FUN = "mean")


# Ex 10======================
order_date = str_split_fixed(string = sales$Order.Date
                             , pattern = "-", n=3
                             )
sales$Order.Year <- order_date [ ,1] 

aggregate(x = sales$Profit, by = list(sales$Order.Year), FUN = "mean")


