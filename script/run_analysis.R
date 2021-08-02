###
#
# Filename: run_analysis.R
# Author  : Robert Muwanga
# Date    : 02 August 2021
# Purpose : Refer to README file for steps
#
###

library(tidyverse)
library(here)

uri <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

### Download and extract file

if(!file.exists(here('data', 'Dataset.zip'))) {
  download.file(uri, here('data', 'Dataset.zip'))
}

unzip(zipfile = here('data', 'Dataset.zip'), 
      exdir = here('data'), 
      junkpaths = TRUE)

### Get the list of data files of interest

all_files <- dir(path = here('data'))

omit_files <- c('Dataset.zip', # Files to ignore
                'activity_labels.txt', 
                'features.txt', 
                'features_info.txt',
                'README.txt', 
                'subject_test.txt', 
                'y_test.txt',
                'subject_train.txt',
                'y_train.txt', 
                'X_test.txt',
                'X_train.txt')

data_files <- all_files[-which(all_files %in% omit_files)] # Files of interest

## Create helper function for row binding

load_data_frame <- function(full_file_path) {
  as_tibble(
    read.delim(full_file_path, header = FALSE, sep = "")) %>%
    mutate(filename = basename(full_file_path)) # add file names
}

### Load the data of interest into a single data frame
df <- bind_rows(
  purrr::map(data_files, function(x) {
    load_data_frame(here('data', x))
  })
)

### Create tidy datasets

# Capture the mean and sd only from the first six variables
df <- df %>% select(1:6, filename)

# Update filename values to signal names
df$filename <- df$filename %>%
  str_split(pattern = '_') %>% 
  map(function(x) paste(x[1], x[2], sep = '_')) %>% 
  unlist

# Rename the variables
variable_names <- c('mean_x', 'mean_y', 'mean_z', 
                    'sd_x', 'sd_y', 'sd_z', 'signal')
names(df) <- variable_names

# Create the tidy dataset
tidy_data <- df %>% pivot_longer(cols = -signal, 
                    names_sep = '_', 
                    names_to = c('statistic', 'axis'), 
                    values_to = 'value')

# Create the summary dataset containing average of each value 
# by signal, statistic and axis
summary_data <- tidy_data %>% 
  group_by(signal, statistic, axis) %>% 
  summarize(mean(value))