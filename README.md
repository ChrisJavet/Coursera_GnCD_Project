Getting & Cleaning Data
=======================

This is my implementation of the project from the Coursera Training - Getting and Cleaning Data.  This project contains the following deliverables:
* run_analysis.R; this is the R script that will merge the various datasets provided by Coursera. The script also transform and produces a tidy dataset as per the specifications provided
* CodeBook.md; this is a markdown file that modifies and updates the codebooks contained in the original datasets provided; it indicates all the variables and summaries calculated, along with units, and any other relevant information 
* tidy_dataset.csv; this is the resulting dataset.

The remaining of this document will describe the [run_analysis.R](run_analysis.R) script.

Pre-Requisites
--------------
In order for the script to read and produce the tidy_dataset file, the directory containing the data `UCI HAR Dataset` downloaded from [the URL provided in Coursera Project page](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) should be located in the same directory as the script.

Overall Structure
-----------
The overall structure of the script is as follows:
1. Import the activity labels and the features descriptions
2. Identify the columns and feature names that corresponds to mean() and std()
3. Import test datasets (measurements, subjects, activities), and name the columns 
4. Same as 3. but with training datasets
5. Merge test and training datasets, by using `rbind()` the training datasets rows after the test datasets rows
6. Create a new dataset containing the measurements, subjects and activites, by using the `cbind()` to append the datasets as columns
7. Add a new column containing the activity name, by using `merge()` and joining on the `Activity.number` column name defined in 1. and 3.
8. Create a new dataset that list for each Subject and Activity the `mean()` value of the measurements; this is computed with a `melt()` function to have id and variables separated, and then using the `dcast()` function to apply the `mean()` function on the resulting measurement.
9. Write the tidy dataset to disk

Additional Notes
------------
The feature names contain `-` and `()` characters that cannot be used within column names. Therefore I have removed this punctuations symbols; in order to remove all punctuations I have used the function `gsub("[[:punc:]]", "", features$Feature.name)`.
