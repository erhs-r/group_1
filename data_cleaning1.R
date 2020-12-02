#Data Cleaning 1

library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)
library(stringr)

college_raw <- 
  read_csv(
    "https://raw.githubusercontent.com/nytimes/covid-19-data/master/colleges/colleges.csv")

### Beth
#top 5 schools with highest cases for time series data, include reference point
#of when school started

top_5_overall <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(5)

top5_by_state <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(state, -cases) %>%
  slice_head(n = 5)

ggplot(data = top_state, mapping = aes(x = cases, y = state)) +
  geom_point(mapping = aes(x = cases))

# Adding lat/long to each college to map into flexdashboard

city_location <- read_csv("uscities.csv") %>%
  rename(state = "state_name",
         county = "county_name")

college_location <- top5_by_state %>%
  left_join(y = city_location,
            by = c("city", "state"))

college_location <- college_location %>%
  select(state:cases, state_id:county_fips, lat:lng)

# add college enrollment size for rate. 

admission <- read_excel("college_admission.xlsx")

college_location <- college_location %>%
  left_join(y = admission,
            by = c("college" = "School Name"))

admission2 <- read_excel("college_enrollement.xlsx")

admission2 <- admission2 %>%
  rename(school = `School Name `)
 
college_location <- college_location %>%
  left_join(y = admission2,
            by = c("college" = "school"))

admission3 <- read_excel("top_10_enrollment.xlsx", skip = 1)

college_location <- college_location %>%
  left_join(y = admission3,
            by = c("college" = "University"))

college_location <- college_location %>%
  select(state, county.x, city, college, cases, state_id, county_fips,
         lat, lng, `Total Enrollment `, Enrollment) %>%
  mutate(rate = cases/`Total Enrollment `)
  

### Val

## done
# add and clean clemson's covid data
clemson <- read_excel("clemsonDashboard.xlsx", sheet = "Daily Data") 

clemson_cases <- clemson %>%
  select(Date, Positive) %>%
  mutate(Date = week(Date)) %>%
  group_by(Date) %>%
  summarise(sum(Positive)) %>%
  slice(1:10) %>%
  rename(Week = Date)

# add and clean OSU covid data
osu <- read_excel("Ohio State COVID-19 Dashboard Data Tables.xlsx", skip = 5)

#just noticed that the data we got from their website actually is only for November
# need to try to get data since the start of semester
osu_cases <- osu %>%
  select(`Test Date`, `Positive Tests...9`) %>%
  rename(Week = `Test Date`, 
         Positive = `Positive Tests...9`) %>%
  mutate(Week = week(Week)) %>%
  group_by(Week) %>%
  summarise(sum(Positive))

## done but data only goes until Nov. 1
# add and clean penn state data
penn_state <- read_excel("PennStateCovidTables_new.xlsx")

penn_cases <- penn_state %>%
  mutate(Week = week(Week)) %>%
  select(Week, Total_Positive) %>%
  rename(Positive = Total_Positive)

#join datasets
#all_colleges %>%
  
#top_3_timeseries <- top_3
  #add in data from each college's covid tracking to track # of cases by week

#clemson start date: Aug 19
#OSU: Aug 25
#penn state: Aug 24

#density map for South Carolina

county_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv")

sc_counties <- county_data %>%
  filter(state == "South Carolina") %>%
  select(date:deaths)
















