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

?separate

who <- separate(who, col=age, into = c('min_age', 'max_age'), 
         sep = "(?<=\\d)(?=\\d{2}$)", remove = TRUE,
         convert = FALSE, fill = "warn")

tail(who, n=10)


######## Ex 4
who <- who %>%
  mutate_at(8, ~replace_na(., 'Inf'))
tail(who, n=10)


######################################Test replace_na but not working:
#Test mutate_at, making the min_age column to NA at 65+, and Inf at max_age = 65:
who_test <- who %>%
  mutate(max_age = replace(max_age, max_age == 'Inf', 65))
who_test <- who_test %>%
  mutate(min_age = replace(min_age, min_age == 65, NA))

##### Below doesn't work
who_test <- who_test %>%
  mutate_at(7, ~replace_na(., 65))

tail(who_test, n=10)
remove(who_test)

############################################################

########  Ex 5
#Find the count per diagnosis for males and females.

who <- who %>%
  mutate_at('count', ~replace_na(., 0))
tail(who)
head(who)

summary_counts <- who %>%
  group_by(diagnostic, gender) %>%
  summarise(events = sum(count, na.rm = FALSE) 
            # or set na.rm = TRUE without changing NA to 0 first
            )
print(summary_counts)

who$diagnostic <- factor(who$diagnostic)
str(who$diagnostic)

############   Ex6


ggplot(who,aes(x=gender,y = count, fill=diagnostic)) +  
  geom_col() +
  labs(x='Gender',
       y='Count',
       title='Number of TB events found per diagnostic') +
       labs(y = 'Counts') +
       theme(plot.title = element_text(hjust=0.5)) +
       facet_grid(.~diagnostic)

###########   Ex7
who <- who %>%
  mutate_at('population', ~replace_na(., 0))
tail(who)
head(who)

pct_pop_df <- who %>%
  mutate(percent = (count/population * 100)) %>%
  mutate_at('percent', ~replace_na(., 0))

head(pct_pop_df)
tail(pct_pop_df)  
remove(pct_pop_df)


summary_pct <- pct_pop_df %>%
  group_by(year, gender, diagnostic) %>%
  summarise(pct_pop = mean(population / sum(population)) *100) %>%
  drop_na(pct_pop)

print(summary_pct)

##################  Ex8

ggplot(summary_pct, aes(x = year, y = pct_pop)) +
  geom_line() +
  labs(x='Year',
       y='Percent Population',
       title='Percent of population per diagnostic through time') +
  theme(plot.title = element_text(hjust=0.5)) +
  facet_grid(rows = vars(diagnostic))




