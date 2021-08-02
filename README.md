# Johns Hopkins' Getting and Cleaning Data Course

This repo holds my assignment solution for this course. 

This project demonstrates my ability to collect, work with, and clean a data set, i.e., preparing a tidy data that can be used for later analysis.

This assignment is based off this (article)[http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/], with the data linked to the course available (here)[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones] and the data for the project available (here)[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip].

The walkthrough of the assignment can be found by accessing the codebook in this repo -  **CodeBook.md**. An R script has been developed as well called **run_analysis.R**  that executes all the steps in the *CodeBook.md* file end-to-end. These steps include:

1. Merging the training and the test sets to create one data set.
2. Extracting only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set.
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
