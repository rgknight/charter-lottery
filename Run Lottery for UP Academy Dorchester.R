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

# remove extra rows 
raw <- raw[ !is.na(raw$Applicant_ApplicantID), ]

raw$rand <- runif(nrow(raw), min = 1, max = 10000)

# Some checking 
stopifnot( sum( duplicated(raw$rand)) == 0)
table(raw$Applicant_HasSiblingInSchool)
table(raw$Applicant_CurrentDistrict)
table(raw$Grade_GradeLevelCode)

raw$priority.level <- with(raw,
                           ifelse(Applicant_HasSiblingInSchool == "TRUE", 1,
                           ifelse(Applicant_CurrentDistrict == "BPS", 2, 3)))

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


write.csv( out, "UAD Results/UP Dorchester Lottery Full Results March 11 2015.csv", row.names = F, na = "")
write.csv( out.small, "UAD Results/UP Dorchester Lottery Presentation Results March 11 2015.csv", row.names = F, na = "")
