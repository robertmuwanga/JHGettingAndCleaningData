# CodeBook for the Getting and Cleaning Data Assingment

## Purpose

This CodeBook provides a description of the values and variables used for this exercise. It also outlines the steps that was taken to produce the tidy (df) and summary (summary_data) datasets.

## About the data

The data originates from the [Univeristy of California Irvine's Machine Learning Repository](http://archive.ics.uci.edu/ml), Dua, D. and Graff, C. (2019), and the write-up below from the same source.

The dataset is a collection of experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

Using the phone's embedded accelerometer and gyroscope, the authors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded and the data manually labelled. 

The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force was assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The data can be acquired either from the Machine Learning repository or by following this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). *This link was used to complete this exercise.*

## Data used for this exercise

From the zipped file obtained from the link above, the following datasets were used:

- 'features.txt': List of all features that serve as header information.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'X_train.txt': Training set.

- 'y_train.txt': Training labels.

- 'X_test.txt': Test set.

- 'y_test.txt': Test labels.

- 'subject_train.txt' : The unique subject's identification number in the training set.

- 'subject_test.txt': The unique subject's identification number in the testing set.

Reference to the 'README.txt' file was made in order to understand the datasets of interest.

## Creation of the tidy data set

Reference should be mad to the **run_analysis.R** file that can be found in the *script/* folder.

To create the tidy data set, the following activities were performed:

*1. Unzip the data of interest from the zipped file*

The data archive was downloaded following the link provided above and the files of interest were extracted to the **data/** folder.

*2. Load the data files*

A helper function was created to help load the training and testing data sets into data frames that were subsequently merged using the **bind_rows()** function. Header information was subsequently applied. 

Given that the interest was to extract measurements represent the *mean()* and *std()* information for each observation, we selected only features that have these unique constructs.

We also add the two measurements - **subject** and **activity** features.

*3. Tidy the merged dataset into a tidy data set**

- Pivot the data frame from a **wide** format to a **long** format around the **subject** and **activity** features.

- Split the new **measure** feature as a result from the pivot into 3 new features by first identifying and converting the hyphen character in the **'-X', '-Y', '-Z'** sub-strings in the measure values to an underscore **'_'**, splitting the *measure* feature so that we have the mean()/std() statistic and X,Y and Z axis in a separate variable (**dimension**), and finally splitting the **dimension** feature again so that we have the statistic and the axis in their own variables.

- Removing the curly brackets from the values in the **statistic** variable so that we just have the type of statistic (e.g. from 'mean()' to 'mean').

- Changing the numerals values in the **activity** feature to their respective character labels.

- Remove the **id** variable as its no longer needed, and reorder the data frame although this reordering is not essential.

These steps produce the tidy data set *df* that shall be used to create the summary dataset.

*4. Create the summary dataset*

Create a summary of the data by grouping the data set by **activity** and **measure** and finding the average against **value** to produce the *summary_data* dataset.

## Save file and cleanup

Finally, unused variables are removed from in order to reclaim space by removing all objects except the *df* and *summary_data* objects from the R environment.

We also go ahead and print the output of the *summary_data* data object into a file '**tidy_data.txt**' in the **output/** folder.
