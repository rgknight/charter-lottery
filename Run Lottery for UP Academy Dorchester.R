# Generate a random sample and apply lotter logic for UAD

# Process
# (1) Generate a random number 
# (2) Generate an order by priority level and grade


# Where is this information saved?
  # Is an application = Applicant_ApplicantID is not missing
  # Grade = Grade_GradeLevelCode
  # Priority Order
    # Level 1: Sibling -- UserCheck1 == "TRUE"
    # Level 2: Current BPS Student -- UserCheck2 == "TRUE"
    # Level 3: Everyone else (should also be reflected by UserCheck3=="TRUE" )


options(stringsAsFactors=F)
require(dplyr)

setwd("C:/Dropbox (UP)/UP-Data Evaluation/Sacred Data/Lottery/Lotteries 2015")

raw <- read.csv("UAD Source/Final 2015-2016 Lottery L2 (All Fields).csv")

set.seed(524291) # Change to a random number from random.org on lottery night

# remove extra rows 
raw <- raw[ !is.na(raw$Applicant_ApplicantID), ]
#filter out non-applicants
raw <- raw %>% filter(Applicant_CandidateCategory == "Application")

raw$rand <- runif(nrow(raw), min = 1, max = 10000)

# Some checking 
stopifnot( sum( duplicated(raw$rand)) == 0)
table(raw$UserCheck1)
table(raw$UserCheck2)
table(raw$Grade_GradeLevelCode)

raw$priority.level <- with(raw,
                           ifelse(UserCheck1 == "TRUE", 1,
                           ifelse(UserCheck2 == "TRUE", 2, 3)))

table(raw$priority.level)

raw <- raw %>% 
  arrange(rand) %>%
  mutate(random.lot = row_number())

out <- raw %>%
  group_by( Grade_GradeLevelCode) %>% 
  arrange(priority.level, random.lot) %>%
  mutate(priority.number = row_number(),
         name = ifelse(UserCheck4 == "TRUE", "",Applicant_FullName)) 


out.small <- out %>%
  select(Applicant_ApplicantID, name, priority.number, priority.level, Grade_GradeLevelCode, random.lot)


write.csv( out, "UAD Results/UP Dorchester Lottery Full Results L2 April 29 2015.csv", row.names = F, na = "")
write.csv( out.small, "UAD Results/UP Dorchester Lottery Presentation Results L2 April 29 2015.csv", row.names = F, na = "")
