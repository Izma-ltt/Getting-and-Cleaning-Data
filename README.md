# Getting-and-Cleaning-Data
## Assignment for the Coursera course Getting and Cleaning Data

This Github repository contains my work on the assignment for the Week 4 of the Getting and Cleaning Data course.

At the bottom of this ReadMe file you can find the R script, while the rest of the text explains the code in detail and explains why this approach of tidying dataset has been chosen.

1.	The script first reads the URL containing the zip file (so everybody should be able to run the script in full)
2.	Using the temporary zip file it reads and saves training and test data (measurement, subject and activity data) into separate variables ( train_full, tran_subject, train_activities respectively )
3.	Further, it saves activities labels and features (names of the measurement variables) files
4.	Using features files it renames the columns of the test and training data
   *	Renaming is done before joining training and test data, so the joining process can be done by column names in full
5.	After renaming, only "mean" and "std" variables are chosen by using select function from dplyr package, this is saved in new train and set variables
   * Variables with mean in the name, but which are angle() estimators where excluded from the list. MeanFreq was not excluded as the instructions were not cleat whether mean refers to meanFrq as well
6.	To the smaller train and test variables (only 79 vs. initial 561 variables) activities and subject columns are added. These variables were read directly from the zip file ( "y_train.txt" for activities, "subject_train.txt" for subjects, for both train and test ) as per ReadMe file
7.	Another column is added to both train and test datasets - ExperimentalDesign, which should preserve the information about whether the measurement was taken for training or test
8.	Training and test datasets are then fully joined as they contain the same columns set
9.	Activities variable values are then relabelled to a more descriptive naming convention, using the activity_labels.txt file
10. Columns are renamed to be more descriptive:
    * t and f in the names are renamed to describe they denote time and frequency domains
    * Mean, Std and MeanFreq derivations have been moved to the front of the name, for an easier distinction between similar variables
    * Body, Acc, Gyro and Jerk are left as they are, since they represent words "body", "accelerometer", "gyroscope" and "jerk movement" sufficiently, given the length constraints
    * Mag is renamed to Magnitude, to better emphasize that it represent magnitude of the signals
11.	Data is then melted in line with one variable one column and one row one observation approach - each subject performed one activity in either test or training set up; and measured one of the 86 features:
    *	ID variables are defined as Activities, Subjects and Experimental Design
    *	Measures variables are all other variables, coming from the features.txt file (only mean and std)
12.	After melting final dataset can be obtained, by reshaping the melted structure into Subject + Activity vs. all measurements matrix, where each input represents the mean of all possible inputs for this combination of variables (Subject, Activity, ExperimentalDesign, measurement variable )

As Hadley Wickham mentions in his article, depending on the purpose of the dataset, a dataset can be tidied in different ways.
The first two main tidy data rules are in place:

 1.   Each variable forms a column
 2.   Each observation forms a row

In the case of the third:

 3.   Each type of observational unit forms a table

ExperimentalDesign variable is an example of his "variables are stored in both rows and column" tidy data issue, however given that we have 79 columns for both designs, instead of creating two tables I decided to use one indicator variable (ExperimentalDesign), so this data can be easily used for ANOVA for example - to check whether these two are statistically different. The rest of the variables are in line with this rule. Also, the original task does not include taking ExperimentalDesign into account.

The final tidy dataset is a 180 x 82 matrix:
  * 30 subjects x 6 activities = 180 rows; since each subject did all 6 activities
  * 82 rows; 79 measurement variables and 3 ID variables (Activities, Subjects and ExperimentalDesign)
  Note that there are 2 levels of ExperimentalDesign and even though it's defined as an ID variable we do not have 360 rows. This is because each subject was either in training or testing group.
