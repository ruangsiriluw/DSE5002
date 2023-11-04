

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

#========Ex3 convert Ship.Date and Order.Date to date vectors


sales$Order.Date <- as.Date(sales$Order.Date
                                ,format='%m/%d/%Y'
)

sales$Ship.Date <- as.Date(sales$Ship.Date
                            ,format='%B %d %Y'
)



#??? lubridate convert results to year direction not possible with
#just subtraction 2 vectors.  Only can convert to days/wks with "difftime"
oldest_order <- min(sales$Order.Date)
newest_order <- max(sales$Order.Date)

#change unit of difftime to days, weeks (but no years)
difftime(newest_order, oldest_order,
         units = "days")


#for weeks change unit to weeks
difftime(newest_order, oldest_order,
                     units = "weeks")


# For years, redo with interval and divided by yrs
day_intv <- interval(newest_order, oldest_order)

yr_intv <- as.period(day_intv) / years(1)
print(yr_intv)


#If convert to numeric first, that can be done with "duration"
numdays <- as.numeric(newest_order - oldest_order)
numdays

duration(numdays, "days")

#Or use the time_length and format for number of years
time_length(difftime(oldest_order,newest_order), "years")


# Ex 4==============

# create a vector from Ship Date and Order Date
ord_date <- sales$Order.Date
shp_date <- sales$Ship.Date

shippingdays <- difftime(shp_date, ord_date, 
                         units = "days")

mean(shippingdays)


# Ex 5===========
#create matrix with customer name only and split into first and last name
sales$Customer.Name <- tolower(sales$Customer.Name)

#or use stringr,
sales$Customer.Name <- str_to_lower(string = sales$Customer.Name
                                    , locale = "en")

uniq_customer <- unique(sales$Customer.Name)

cust_firstlast <- str_split_fixed(string = uniq_customer
                                           , pattern = " ", n=2)

length(which(cust_firstlast == "bill"))



#DO NOT NEED__Add each column [, 1] = column1,  back to sales original data frame
sales$Customer.First <- cust_firstlast[ ,1]
sales$Customer.Last <- cust_firstlast[ ,2] 


#--- Fixing------need to pull out 'table', but need to lower case first Ex6====
sales$Product.Name <- str_to_lower(sales$Product.Name)

#is this counting rows only?
match_table <- str_match_all(string = sales$Product.Name, pattern = "table")
length(which(match_table == "table"))

test <- grep(pattern = "table", sales$Product.Name)
length(test)


#is this counting occurrences from individual word?
split_table <- str_split(string = sales$Product.Name, pattern = " ")

sum(str_count(split_table, pattern = "table"))


#  Ex7=================
# DO NOT NEED, Factor already call for a unique element in State 
unique(sales$State)

# change to Factor
sales$State <- factor(sales$State)
is.factor(sales$State)
levels(sales$State)
str(sales$State)

#Order alphabetical and make a table
levels(sales$State)
statetable <- table(sales$State)
statetable

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

#If the Order.Date is already in as.Date format, just pull out into a new
# column then format out only Year by regex.
sales$Order.Year <- format(sales$Order.Date, "%Y")

aggregate(x = sales$Profit, by = list(sales$Order.Year), FUN = "mean")


