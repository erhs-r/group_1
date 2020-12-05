#Data Cleaning 1

library(tidyverse)
library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)
library(stringr)
library(tigris)

college_raw <- 
  read_csv(
    "https://raw.githubusercontent.com/nytimes/covid-19-data/master/colleges/colleges.csv")

state_names <- read_csv("csvData_state_names.csv")
colnames(state_names)


college_raw <- college_raw %>%
  semi_join(y = state_names, 
            by = c("state" = "State"))
### Beth
#top 5 schools with highest cases for time series data, include reference point
#of when school started

top_5_overall <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(desc(cases)) %>%
  head(10)

top5_by_state <- college_raw %>%
  select(state, county, city, college, cases) %>%
  group_by(state) %>%
  arrange(state, -cases) %>%
  slice_head(n = 10)

ggplot(data = top5_by_state, mapping = aes(x = cases, y = state)) +
  geom_point(mapping = aes(x = cases))

# Adding lat/long to each college to map into flexdashboard

city_location <- read_csv("uscities.csv") %>%
  rename(state = "state_name",
         county = "county_name")

college_location <- top5_by_state %>%
  left_join(y = city_location,
            by = c("city", "state"))

college_location <- college_location %>%
  select(state:city_ascii, state_id:county_fips, lat:lng)

geo_code <- read_excel("EDGE_GEOCODE_POSTSEC_1920.xlsx")

geo_code <- geo_code %>%
  select(NAME, CITY, STATE, LAT, LON)

college_location <- college_location %>%
  left_join(y = geo_code,
            by = c("college" = "NAME"))

college_location <- college_location %>%
  unite(col = latitude,
        c(lat, LAT),
        na.rm = TRUE) %>%
  separate(col = latitude,
           into = c("lat_1", "lat_del"),
           sep = "_")

college_location <- college_location %>%
  unite(col = longitude,
        c(lng, LON),
        na.rm = TRUE) %>%
  separate(col = longitude,
           into = c("long_1", "long_del"),
           sep = "_")

college_location_final <- college_location %>%
  select(state:cases, state_id:lat_1, long_1)

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
  mutate(rate = cases/`Total Enrollment `) %>%
  write_delim(file = "college_location", delim = ",", col_names = TRUE)











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
















