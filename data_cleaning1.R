#Data Cleaning 1

library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)

college_raw <- 
  read_csv(
    "https://raw.githubusercontent.com/nytimes/covid-19-data/master/colleges/colleges.csv") 


#top 5 colleges by state with highest COVID cases
top_5 <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(5)

top_state <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(state, -cases) %>%
  slice_head(n = 5)

ggplot(data = top_state, mapping = aes(x = cases, y = state)) +
  geom_point(mapping = aes(x = cases))

#top 3 schools with highest cases for time series data, include reference point
#of when school started

top_3 <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(3)

# add and clean clemson's covid data
clemson <- read_excel("clemsonDashboard.xlsx", sheet = "Daily Data") 

clemson_cases <- clemson %>%
  select(Date, Positive) 

# add and clean OSU covid data
osu <- read_excel("Ohio State COVID-19 Dashboard Data Tables.xlsx", skip = 5)

osu_cases <- osu %>%
  select(`Test Date`, `Positive Tests...9`) %>%
  rename(Data = `Test Date`, 
         Positive = `Positive Tests...9`)

# add and clean penn state data
penn_state <- read_excel("PennStateCovidTables.xlsx")

#all_colleges %>%
  #join datasets

#top_3_timeseries <- top_3
  #add in data from each college's covid tracking to track # of cases by week

#clemson start date: Aug 19
#UF: Aug 31
#penn state: Aug 24

#top school with COVID for density map 

county_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv")

sc_counties <- county_data %>%
  filter(state == "South Carolina") %>%
  select(date:deaths)
















