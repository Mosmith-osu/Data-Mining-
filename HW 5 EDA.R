# Install first if needed
#install.packages("googledrive")
install.packages("readr")
install.packages("tidyverse")
install.packages("dplyr")
library(googledrive)
library(readr)
library(dplyr)
library(tidyverse)

###Load from Google Drive
#drive_auth(scopes = "https://www.googleapis.com/auth/drive.readonly", use_oob = TRUE)


# File ID from your shared Google Drive link
#file_id <- "19pM78O7qPJfdOD_sHbFiso5YMmW0YXyp"

# Download the ZIP file to your working directory
#drive_download(as_id(file_id), path = "data.zip", overwrite = TRUE)

#file.exists("data.zip")  # should return TRUE
#unzip("data.zip", exdir = "unzipped_data")
#list.files("unzipped_data")



#load into R

df <- read_csv("unzipped_data/Invistico_Airline.csv")

# Preview the data
head(df)
str(df)



# Load the data
#df <- read_csv("Invistico_Airline.csv")

# Fix column names to remove special characters (safe for modeling)
df <- df %>%
  rename_with(~ make.names(., unique = TRUE))

# Convert categorical variables to factors
df <- df %>%
  mutate(
    satisfaction = as.factor(satisfaction),
    Gender = as.factor(Gender),
    Customer.Type = as.factor(Customer.Type),
    Type.of.Travel = as.factor(Type.of.Travel),
    Class = as.factor(Class)
  )

# Check structure to confirm conversion
str(df)


#Find Missing values
sum(!complete.cases(df))
#View missing values (same as checking columns)
df_missing <- df[!complete.cases(df), ]
## Check for missing values in columns
colSums(is.na(df))##in original df

# Handle missing values (##Come back to use if needed)
# Drop rows with missing values (if few) #is 393 few?
#df_clean_adel <- df %>% drop_na()

#Keep missing data convert missing numeric values with median
median_delay <- median(df$Arrival.Delay.in.Minutes, na.rm = TRUE)
df_con <- df %>%
  mutate(Arrival.Delay.in.Minutes = ifelse(is.na(Arrival.Delay.in.Minutes),
                                           median_delay,
                                           Arrival.Delay.in.Minutes))

# Final check
sum(is.na(df_con$Arrival.Delay.in.Minutes))  # Should be 0
###original df cleaned (missing values) and converted to factors
#working df is df_con

