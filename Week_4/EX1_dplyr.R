library(dplyr)
sales <- read.csv("Week_4/Data/sales.csv", stringsAsFactors=FALSE)

names(sales)

### Using the Pipe
sales %>% # the pipe  (%>%) allows you to write multi-line functions passing the same data to each line of code
   #rename(Row.ID = ?..Row.ID) %>%
   slice_max(Row.ID) %>% #slice the rows with the maximum Row.ID (should be one row)
   select(Row.ID) # select the single column Row.ID


#### Aggregation

#EX1
#simple aggregation, giving Tibble (dataframe)
sales %>% 
 group_by(Segment) %>%
 summarize(sales = sum(Sales, na.rm = TRUE))

#EX2
#multiple groups & multiple metrics
sales %>%
 group_by(Segment,Category) %>%
 summarize(sales=sum(Sales),
             transactions = n(),  #count number of transactions, rows, observations
             distinct_products = n_distinct(Product.Name), # use distinct prod name
             average_transaction_sale = sum(sales) / n()
           )  


### Mutate to change types
name_mat <- stringr::str_split_fixed(sales$Customer.Name, ' ', n=2)

# To keep the last name Van Hoff and not cutting off

sales <- sales %>%
 mutate(Order.Date = as.Date(Order.Date,'%m/%d/%Y'),
          Ship.Date = as.Date(Ship.Date, '%m/%d/%Y'),
          First.Name = name_mat [,1], 
          Last.Name = name_mat [,2] 
   )


sales$First.Name[1:5]
inherits(sales$Order.Date, 'Date')  #check if Order.Date is date

###Joins and Unions
# data frame 1
df1 = data.frame(CustomerId = c(1:6), Product = c("Oven","Television","Mobile","WashingMachine","Lightings","Ipad"))
df1 

# data frame 2
df2 = data.frame(CustomerId = c(2, 4, 6, 7, 8), State = c("California","Newyork","Santiago","Texas","Indiana")) 
df2 


#left join, all keys on the left table, combines with matches on right 
left_df <- df1 %>%   #take keys of df2 join with df1, to the left table = df1
  left_join(df2,by='CustomerId')
left_df

right_df <- df1 %>%  #Take keys of df2 right table, join right table = df1
   right_join(df2,by='CustomerId')
right_df

#full join, all keys returned
full_df <- df1 %>%
   full_join(df2,by='CustomerId')
full_df

#inner join, ***only matches on both returned
  inner_df <- df1 %>%
  inner_join(df2,by='CustomerId')
inner_df

#binding columns and rows (unions) combine everything regardless of common ID
#Need to have the same # of rows
df1 %>% bind_cols(left_df)

#stacking data frames ( bind rows), Stacking on top
   left_df %>% bind_rows(right_df)

