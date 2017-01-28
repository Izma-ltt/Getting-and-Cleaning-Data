# Getting-and-Cleaning-Data
## Assignment for the Coursera course Getting and Cleaning Data

This Github repository contains my work on the assignment for the Week 4 of the Getting and Cleaning Data course.

At the bottom of this ReadMe file you can find the R script, while the rest of the text explains the code in detail and explains why this approach of tidying dataset has been chosen.

1. The script first reads the URL containing the zip file (so everybody should be able to run the script in full)
2. Using the temporary zip file it reads and saves training and test data (measurement, subject and activity data) into separate variables ( train_full, tran_subject, train_activities respectively )
3. Further, it saves activities labels and features (names of the measurement variables) files
4. Using features files it renames the columns of the test and training data
    = renaming is done before joining training and test data, so the joining process can be done by all columns
5. After renaming, only "mean" and "std" variables are chosen by using select function from dplyr package, this is saved in new train and set variables
6. To the smaller train and test variables (only 86 vs. initial 561 variables) activities and subject columns are added. These variables were read directly from the zip file ( "y_train.txt" for activities, "subject_train.txt" for subjects, for both train and test ) as per ReadMe file
7. Another column is added to both train and test datasets - ExperimentalDesign, which should perserve the information about whether the measurement was taken for training or test
8. Training and test datasets are then fully joined as they contain the same column set
9. Activities column is relabelled to a more descriptive naming convention, using the activity_labels.txt file
10. Data is then melted:
    = ID variables are defined as Activities, Subjects and Experimental Design
    = Measures variables are all other variables, coming from the X_train.txt file (only mean and std)
    this approach is in line with one variable one column approach and one row one observation
    -> each subject doing one activity in either test or training set up measured one of the 86 variables
11. After melting final dataset can be obtained, by reshaping the melted structure into Subject + Activity vs. all measurements matrix, where each input represents the mean of all possible inputs for this combination of variables (Subject, Activity, ExperimentalDesign, measurement variable )

As Hadley Wickham mentions in his article, depending on the purpose of the dataset dataset can be tidied in different way. 

The first two main tidy data rules are in place:
1. Each variable forms a column
2. Each observation forms a row

In the case of the third on
3. Each type of observational unit forms a table.
ExperimentalDesign variable is an example of his "variables are stored in both rows and column" tidy data issue, however given that we have 86 columns for both designs, instead of creating two tables I decided to use one indicator variable (ExperimentalDesign), so this data can be easily used for ANOVA for example to check whether these two are statistically differnt.
The rest of the variables are in line with this rule. Also, the original task does not include taking ExperimentalDesign into account.


