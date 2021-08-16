########################################################################
#                                                                      #
# Filename    : run_analysis.R                                         #
# Author      : Robert Muwanga                                         #
# Date        : 16 August 2021                                         #
# Purpose     : To create two tidy data sets - one that merges the     #
#             : sensor / activity data and the other that summarizes   #
#             : the sensor / activity data.                            #
# Output      : df - Final tidy dataset.                               #
#             : summary_data - Average of values by                    #
#                              activity and subject.                   #
########################################################################

library(dplyr)
library(tidyr)
library(here)
library(stringr)

uri <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

### Download and extract file ----------------------------------------------

if(!file.exists(here('data', 'Dataset.zip'))) {
  download.file(uri, here('data', 'Dataset.zip'))
}

extract_files <- c('UCI HAR Dataset/README.txt', 
                   'UCI HAR Dataset/features_info.txt', 
                   'UCI HAR Dataset/features.txt', 
                   'UCI HAR Dataset/activity_labels.txt', 
                   'UCI HAR Dataset/train/X_train.txt',
                   'UCI HAR Dataset/train/y_train.txt',
                   'UCI HAR Dataset/test/X_test.txt', 
                   'UCI HAR Dataset/test/y_test.txt', 
                   'UCI HAR Dataset/train/subject_train.txt',
                   'UCI HAR Dataset/test/subject_test.txt')

unzip(zipfile = here('data', 'Dataset.zip'), 
      exdir = here('data'), 
      files = extract_files,
      junkpaths = TRUE)

### Get the data files of interest ----------------------------------------

# List of data files
data_files <- c('X_train.txt', 'X_test.txt')
activity_files <- c('y_train.txt', 'y_test.txt')
subject_files <- c('subject_train.txt', 'subject_test.txt')

# Load the header, activity and subject information for the combined data frame
headers <- read.csv(
  here('data', 'features.txt'), sep = "", header = FALSE) %>% .$V2

activity_labels <- read.table(
  here('data', 'activity_labels.txt'))$V2

subject_data <- lapply(subject_files, function(x) {
  read.delim(here('data', x), header = FALSE, sep = '\n')
}) %>% bind_rows()

names(subject_data) <- 'subject'

### Create helper function for row binding

load_data_frame <- function(full_file_path) {
  as_tibble(
    read.delim(full_file_path, header = FALSE, sep = ""))
}

### Load the data of interest into a single data frame --------------------

# Merge data files
df <- bind_rows(
  purrr::map(data_files, function(x) {
    load_data_frame(here('data', x))
  })
)

activities <- bind_rows(
  purrr::map(activity_files, function(x) {
    load_data_frame(here('data', x))
  })
)

# Add header information
names(df) <- headers

# Extract columns that have mean() and std() information and add activities
df <- df %>% select(matches('mean\\(\\)|std\\(\\)'))
df$activity <- activities$V1

# Add subject information
df$subject <- subject_data[[1]]

# Add a reference column so that its easier to pivot
# df$id <- seq(1:nrow(df))

### Create tidy data sets ---------------------------------------------------

# Pivot along 'subject' and 'activity'
df <- df %>% pivot_longer(
  cols = -c(activity,subject), 
  names_to = 'measure', 
  values_to = 'value')

# Split the 'measure' column to the signal type, statistic (mean/std) 
# and axis (X, Y or Z)

# Change the '-' to '_' against the axis to aid the splitting
df$measure <- df$measure %>% str_replace_all('-X', '_X')
df$measure <- df$measure %>% str_replace_all('-Y', '_Y')
df$measure <- df$measure %>% str_replace_all('-Z', '_Z')

# Split column by the axis prefix '-'
df <- df %>% separate(
  col = measure, 
  into = c('measure', 'dimension'), 
  sep = '-')

# Split the dimension column by the axis prefix '_'
df <- df %>% separate(
  col = dimension, 
  into = c('statistic', 'axis'), 
  sep = '_', 
  fill = 'right') # Fill axis with no values with NA

# Clean up the values in the statistic column
df$statistic <- df$statistic %>% str_remove_all(pattern = '\\(|\\)')

# Substitute the values of activity with the labels
df$activity <- activity_labels[df$activity]

# Reorder data frame
df <- df %>% 
  select(subject, measure, activity, axis, statistic, value)

### Summary statistics ---------------------------------------------------

# Averages each variable for each activity and subject
summary_data <- df %>% 
  group_by(activity, subject) %>% 
  summarize('average' = mean(value)) %>% 
  ungroup()
  
### Save file and cleanup ------------------------------------------------

# Remove unneeded values
rm(list = ls()[!grepl('df|summary_data', ls())])

# Save files in the output folder
write.table(x = summary_data, 
            file = here('output', 'tidy_data.txt'), 
            row.name=FALSE)
