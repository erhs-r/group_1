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
#top 3 & 5 colleges by state with highest COVID cases


top_3 <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(3)

top_5 <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(10)

top5_by_state <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(state, -cases) %>%
  slice_head(n = 10)

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

# add college population size for rate. 



### TIMESERIES DATA

#Clemson
clemson <- read_excel("clemsonDashboard.xlsx", sheet = "Daily Data") 

clemson_cases <- clemson %>%
  select(Date, Positive) %>%
  mutate(Date = week(Date)) %>%
  group_by(Date) %>%
  summarise(sum(Positive)) %>%
  slice(1:10) %>%
  rename(Week = Date, 
        Positive = `sum(Positive)`) %>%
  mutate(College = "Clemson")

#university of florida
uf <- read_excel("UF_covid_data.xlsx")

uf_cases <- uf %>%
  mutate(Week = week(Week)) %>%
  mutate(College = "UF")

#university of georgia 
u_of_g <- read_excel("UG_covid_data.xlsx")

ug_cases <- u_of_g %>%
  mutate(Week = week(`Reporting Week`)) %>%
  rename(Positive = `Total Number of Positive Student Tests*`) %>%
  mutate(College = "UG") %>%
  select(Positive:College)

#join datasets
#all_colleges %>%


#college start dates
  #Clemson: Aug 19
  #UF: Aug 31
  #UG: Aug 20


### DENSITY MAP DATA

#density map for South Carolina
county_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv")

sc_counties <- county_data %>%
  filter(state == "South Carolina") %>%
  select(date:deaths)
















