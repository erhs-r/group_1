#Data Cleaning 1

library(tidyverse)
library(dplyr)
library(ggplot2)

college_raw <- 
  read_csv(
    "https://raw.githubusercontent.com/nytimes/covid-19-data/master/colleges/colleges.csv") 

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

