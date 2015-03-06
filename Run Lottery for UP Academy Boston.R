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

setwd("C:/Dropbox (UP)/UP-Data Evaluation/UP Data Sources/School Data Requests/Lotteries 2015")

raw <- read.csv("UAB Lottery 2015-2016.csv")

set.seed(43412696) # Change to a random number from random.org on lottery night

raw <- raw[!is.na(raw$), ]

rand <- runif(nrow(raw), min = 1, max = 1000000)


# Output small file == 
#   Grade,
# Priority Level,
# Priority Order [order within grade], 
# Applicant ID,
# Name if not confidential,
# random lot [overall random number]
# Output Large file = everything
