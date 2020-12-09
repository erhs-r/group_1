penn_state <- read_excel("PennStateCovidTables_new.xlsx")
penn_cases <- penn_state %>%
  mutate(Week = week(Week)) %>%
  select(Week, Total_Positive) %>%
  rename(Positive = Total_Positive)

dygraph(penn_cases[,1:2], group = "cases" ) %>% 
  dySeries(c("Positive"), label = "Penn State") %>% 
  dyAxis("y", label = "Cases") %>% 
  dyAxis("x", label = "Week of Year")

week <- data.frame(WeekNumber = c(32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48))
uf <- data.frame(casesuf = c(NA, NA, NA, 569,767,416,186,161,279,420,378,267,296,237,227,131,4))
ug <- data.frame(casesug = c(NA,176,901,1490,446,170,65,68,96,87,67,86,101,89,NA,NA,NA))
clemson <- data.frame(casesclem = c(NA,NA,38,442,778,680,518,615,512,367,191,98,NA,NA,NA,NA,NA))
pennstate <- data.frame(casesps = c(0,1,16,285,575,600,666,466,419,184,218,153,217,261,379,10, NA))
cbind(week,uf,ug,clemson,pennstate)

College_Covid <- cbind(week,uf,ug,clemson,pennstate)

write.csv(College_Covid)
College_Dygrapgh <- read_csv("raw data/College_Dygrapgh.txt")

dygraph(College_Dygrapgh, main = "Cases by Top Trending Schools") %>% 
  dyOptions(colors = RColorBrewer::brewer.pal(4,"Set2")) %>% 
  dyAxis("y", label = "Cases") %>% 
  dyAxis("x", label = "Week Number (August 3,2020 - November 29,2020)") %>% 
  dySeries("casesuf", label = "U of Florida") %>% 
  dySeries("casesug", label= "U of Georgia") %>% 
  dySeries("casesclem", label = "Clemson") %>% 
  dySeries("casesps", label = "Penn State")

