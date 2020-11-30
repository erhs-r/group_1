library(readr)
library(readxl)
library(dplyr)
college_admission <- read_excel("~/Desktop/practiceR_part2/college_admission.xlsx")

college_admission %>% 
  select(`School Name`, `Admission number 2020`)
