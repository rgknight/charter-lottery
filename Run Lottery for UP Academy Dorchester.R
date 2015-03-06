# Generate a random sample and apply lotter logic for UAD

# Process
# (1) Generate a random number 
# (2) Generate an order by priority level and grade


# Where is this information saved?
  # Grade = Grade_GradeLevelCode
  # Priority Order
    # Level 1: Sibbling -- Applicant_HasSiblingInSchool
    # Level 2: Current BPS Student -- Applicant_CurrentDistrict
    # Level 3: Everyone else


options(stringsAsFactors=F)

setwd("C:/Dropbox (UP)/UP-Data Evaluation/UP Data Sources/School Data Requests/Lotteries 2015")

raw <- read.csv("UAD 2015-2016 Applicants.csv")

set.seed(43412696) # Change to a random number from random.org on lottery night

# All applications should have an "Applicant_ApplicantID" or they are empty rows

raw <- raw[!is.na(raw$Applicant_ApplicantID), ]

rand <- runif(nrow(raw), min = 1, max = 1000000)


