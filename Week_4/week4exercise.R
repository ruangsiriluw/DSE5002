library(dplyr)
library(tidyr)
library(ggplot2)


###### Ex1

data(who)
data(population)
tail(who)

who <- who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = c('diagnostic', 'gender', 'age'),
    names_pattern = "new_?(.*)_(.)(.*)",
    values_to = 'count'
  )

tail(who)

#### Ex2

who <- who %>%
  left_join(population, by= c('country', 'year'))

head(who)
tail(who)

######## Ex3
#seperate using 'looking forward' function or reg exp
?separate

who <- separate(who, col=age, into = c('min_age', 'max_age'), 
         sep = "(?<=\\d)(?=\\d{2}$)", remove = TRUE,
         convert = FALSE, fill = "warn")

tail(who, n=10)


######## Ex 4
who <- who %>%
  mutate_at(8, ~replace_na(., 'Inf'))
tail(who, n=10)


########/////////////Test replace_na but not working://////////////////////////
#Test mutate_at, making the min_age column to NA at 65+, and Inf at max_age = 65:
who_test <- who %>%
  mutate(max_age = replace(max_age, max_age == 'Inf', 65))
who_test <- who_test %>%
  mutate(min_age = replace(min_age, min_age == 65, NA))

#####//////////////// Below doesn't work
who_test <- who_test %>%
  mutate_at(7, ~replace_na(., 65))

tail(who_test, n=10)
remove(who_test)

############//////////////////////////////////////////////////////////////////

########  Ex 5
#Find the count per diagnosis for males and females.


summary_counts <- who %>%
  group_by(diagnostic, gender) %>%
  summarise(events = sum(count, na.rm = TRUE) 
            # or set na.rm = TRUE, without changing NA to 0 first
            )
print(summary_counts)

who$diagnostic <- factor(who$diagnostic)
str(who$diagnostic)

############   Ex6


ggplot(who,aes(x=gender,y = count, fill=diagnostic)) +  
  geom_col() +
  labs(x='Gender',
       y='Count',
       title='Number of TB events found per diagnostic by gender') +
       scale_fill_discrete(name = 'Diagnostic: ',
                           labels = c('extrapulmonary', 'relapse', 'negative pulmonary smear', 
                                      'positive pulmonary smear')) +

       theme(plot.title = element_text(hjust=0.5), legend.position = 'bottom', 
             legend.text = element_text(size = 12)) +
       facet_grid(.~diagnostic)


###########   Ex7
library(scales)

#who <- who %>%
  #mutate_at('population', ~replace_na(., 0))


#pct_pop_df <- who %>%
  #mutate(percent = (count/population * 100)) %>%
  #mutate_at('percent', ~replace_na(., 0))

##### % population per diagnostics?:

#First, remove NA rows for count and population
filter_df <- who

filter_df <- filter(filter_df, population !=is.na(population), count !=is.na(count))
print(filter_df)  
tail(filter_df, n = 20)
summary(filter_df)

pct_df <- filter_df %>%
  group_by(year, gender, diagnostic) %>%
  summarise(pct_pop = sum(count / population))n %>%
  mutate(pct_format = percent(pct_pop, scale = 100, accuracy = 0.001))
print(pct_df)  


##################   Ex8

ggplot(pct_df) +
  geom_line(aes(x = year, y = pct_pop, group = gender, color = gender)) +
  labs(x='Year',
       y='Percent Population',
       title='Percent of population per diagnostic through time') +
  scale_y_continuous(labels = label_percent()) +
  facet_grid(rows = vars(diagnostic), scales = "free_y") +
  theme(plot.title = element_text(hjust=0.5))


#### Note that Year only 1 point data in yr 2013


###############  Ex9

filter_df <- filter_df %>%
  unite(col = 'age_range', 'min_age':'max_age', sep ='-')

head(filter_df)

####################### Ex10

# Count of all diagnostics:
all_count <- sum(filter_df$count)

# Count of all diagnosis by age grp

count_by_age <- filter_df %>%
  group_by(age_range) %>%
  mutate(pct_diag = count / sum(count) *100)

print(count_by_age)


#### Load viridis color palettes
library(viridis)

ggplot(count_by_age) +
  geom_col(aes(x = diagnostic, y = pct_diag, fill = age_range)) +
  labs(x='Diagnostic',
       y='Percent of Total',
       title='Percent of each age group per diagnostic',
       fill = 'Age Range (years old)') +
  scale_y_continuous(labels = label_percent(scale = 1)) +   #Format Y label as % 
  facet_grid(.~age_range) +
  theme(plot.title = element_text(hjust=0.5), legend.position = 'bottom',
       legend.text = element_text(size = 12)) +
  scale_fill_viridis(discrete = TRUE)


  





