# Generate a random sample and apply lottery logic for UP Boston

# Where the information is saved
# Is an application
# Every application will have a helper
# No rows that are not application will have a helper

# Priority Level
# UAB is calculating the priority level in excel here - "Priority number"
# Source data
# Level 1: Sibling - 'UP ID of enrolled sibling' is not anything close to missing
# Level 2: BPS student - 'Current school' is a BPS school
# Level 3: Everyone else

# Process
# (1) Generate a random number 
# (2) Generate an order by priority level and grade

options(stringsAsFactors=F)
require(dplyr)

setwd("C:/Dropbox (UP)/UP-Data Evaluation/Sacred Data/Lottery/Lotteries 2015")

raw <- read.csv("UAB Source/2015-2016 UAB Lottery L4.csv", strip.white = TRUE)

set.seed(27058) # Change to a random number from random.org on lottery night

# remove extra rows (everyone has a helper)
raw <- raw[grepl("^NO", raw$Helper), ]
# remove non-applicants
##raw <- raw %>% filter(Status == "")

raw$rand <- runif(nrow(raw), min = 1, max = 10000)

# Assert that there are no duplicate random numbers and everyone has a priority status
stopifnot( sum( duplicated(raw$rand)) == 0)
tryCatch( nrow( table( raw$Priority.number)) == 3)

raw <- raw %>% 
  arrange(rand) %>%
  mutate(random.lot = row_number())

out <- raw %>%
  group_by( X2015.2016.Grade) %>% 
  arrange(Priority.number, random.lot) %>%
  mutate(priority = row_number(),
         name = ifelse(tolower(Do.Not.Read.at.Lottery) == "x", "",
                       paste(First.name, Middle.name, Last.name, sep = " ") )) %>%
  rename(priority.number = priority, priority.level = Priority.number)


out.small <- out %>%
  select(UP.ID, name, priority.number, priority.level, X2015.2016.Grade, random.lot)


write.csv( out, "UAB Results/UAB Lottery 4 Results August 4 2015.csv", row.names = F, na = "")
write.csv( out.small, "UAB Results/UAB Lottery 4 Presentation Results August 4 2015.csv", row.names = F, na = "")

# Output small file == 
#   Grade,
# Priority Level,
# Priority Order [order within grade], 
# Applicant ID,
# Name if not confidential,
# random lot [overall random number]
# Output Large file = everything