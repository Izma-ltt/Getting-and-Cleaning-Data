run_analysis = function()
{
    install.packages( "dplyr" )
    install.packages( "reshape2")
    library( dplyr )
    library( reshape2)
    
    temp   <- tempfile()
    download.file( "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
    
    ## Reads training data
    train_full       <- read.table( unzip( temp, "UCI HAR Dataset/train/X_train.txt" ), sep = "", header = FALSE)
    train_activities <- read.table( unzip( temp, "UCI HAR Dataset/train/y_train.txt" ), sep = "", header = FALSE )
    train_subjects   <- read.table( unzip( temp, "UCI HAR Dataset/train/subject_train.txt" ), sep = "", header = FALSE )

    ## Reads test data    
    test_full       <- read.table( unzip(temp, "UCI HAR Dataset/test/X_test.txt" ), sep = "", header = FALSE )
    test_activities <- read.table( unzip(temp, "UCI HAR Dataset/test/y_test.txt" ), sep = "", header = FALSE )
    test_subjects   <- read.table( unzip(temp, "UCI HAR Dataset/test/subject_test.txt" ), sep = "", header = FALSE )
    
    ## Reads features and activity labels
    features        <- read.table( unzip(temp, "UCI HAR Dataset/features.txt" ), sep = "", header = FALSE )
    activities      <- read.table( unzip(temp, "UCI HAR Dataset/activity_labels.txt" ), sep = "", header = FALSE )
    
    unlink( temp )
    ## Sets column names, accroding to the features file    
    names(train_full) <- make.names(features[ , 2 ], unique = TRUE )
    names(test_full)  <- make.names(features[ , 2 ], unique = TRUE )

    ## Selects only columns that relate to mean and std values
    train           <- select( train_full, matches( "mean|std" ) )
    train           <- select( train, -matches( "angle" ) )
    test            <- select( test_full, matches( "mean|std" ) )
    test            <- select( test, -matches( "angle" ) )
    
    num_var         <- dim( train )[ 2 ]
    ## Adds activities and subjects columns to train and test data frames
    train$Activities <- train_activities$V1
    train$Subjects   <- train_subjects$V1
    
    test$Activities  <- test_activities$V1
    test$Subjects    <- test_subjects$V1
    
    ## Adds another column to test and train data frames, to differentiate between them before joining
    train$ExperimentalDesign <- "train"
    test$ExperimentalDesign  <- "test"
    
    ## Joins test and train matrix into one matrix
    full_list            <- full_join( train, test )
    
    ## Gives descriptive labels to activities instead of numbers    
    full_list$Activities <- activities$V2[ match(full_list$Activities, activities$V1 ) ]
    
    ## Gives more descriptive names to the columns and extracts names of the measurement variables
    new_names       <- c( "Time_Mean Body Acc_X axis",         "Time_Mean Body Acc_Y axis",
                          "Time_Mean Body Acc_Z axis",         "Time_Std Body Acc_X axis",
                          "Time_Std Body Acc_Y axis",          "Time_Std Body Acc_Z axis",
                          "Time_Mean Gravity Acc_X axis",      "Time_Mean Gravity Acc_Y axis",
                          "Time_Mean Gravity Acc_Z axis",      "Time_Std Gravity Acc_X axis",
                          "Time_Std Gravity Acc_Y axis",       "Time_Std Gravity Acc_Z axis",
                          "Time_Mean Body Jerk_X axis",        "Time_Mean Body Jerk_Y axis",
                          "Time_Mean Body Jerk_Z axis",        "Time_Std Body Jerk_X axis",
                          "Time_Std Body Jerk_Y axis",         "Time_Std Body Jerk_Z axis",
                          "Time_Mean Body Gyro_X axis",        "Time_Mean Body Gyro_Y axis",
                          "Time_Mean Body Gyro_Z axis",        "Time_Std Body Gyro_X axis",
                          "Time_Std Body Gyro_Y axis",         "Time_Std Body Gyro_Z axis",
                          "Time_Mean Body Gyro Jerk_X axis",   "Time_Mean Body Gyro Jerk_Y axis",
                          "Time_Mean Body Gyro Jerk_Z axis",   "Time_Std Body Gyro Jerk_X axis",
                          "Time_Std Body Gyro Jerk_Y axis",    "Time_Std Body Gyro Jerk_Z axis",
                          "Time_Mean Body Acc Magnitude",      "Time_Std Body Acc Magnitude",
                          "Time_Mean Gravity Acc Magnitude",   "Time_Std Gravity Acc Magnitude",
                          "Time_Mean Body Acc Jerk Magnitude", "Time_Std Body Acc Jerk Magnitude",
                          "Time_Mean Body Gyro Magnitude",     "Time_Std Body Gyro Magnitude",
                          "Time_Mean Gyro Jerk Magnitude",     "Time_Std Gyro Jerk Magnitude",
                          "Freq_Mean Body Acc_X axis",         "Freq_Mean Body Acc_Y axis",
                          "Freq_Mean Body Acc_Z axis",         "Freq_Std Body Acc_X axis",
                          "Freq_Std Body Acc_Y axis",          "Freq_Std Body Acc_Z axis",
                          "Freq_Mean Freq Body Acc_X axis",    "Freq_Mean Freq Body Acc_Y axis",
                          "Freq_Mean Freq Body Acc_Z axis",    "Freq_Mean Body Acc Jerk_X axis",
                          "Freq_Mean Body Acc Jerk_Y axis",    "Freq_Mean Body Acc Jerk_Z axis",
                          "Freq_Std Body Acc Jerk_X axis",     "Freq_Std Body Acc Jerk_Y axis",
                          "Freq_Std Body Acc Jerk_Z axis",     "Freq_MeanFreq Body Acc Jerk_X axis",
                          "Freq_MeanFreq Body Acc Jerk_Y axis","Freq_MeanFreq Body Acc Jerk_Z axis",
                          "Freq_Mean Body Gyro_X axis",        "Freq_Mean Body Gyro_Y axis",
                          "Freq_Mean Body Gyro_Z axis",        "Freq_Std Body Gyro_X axis",
                          "Freq_Std Body Gyro_Y axis",         "Freq_Std Body Gyro_Z axis",
                          "Freq_MeanFreq Body Gyro_X axis",    "Freq_MeanFreq Body Gyro_Y axis",
                          "Freq_MeanFreq Body Gyro_Z axis",    "Freq_Mean Body Acc Magnitude",
                          "Freq_Std Body Acc Magnitude",       "Freq_MeanFreq Body Acc Magnitude",
                          "Freq_Mean Body Body Acc Jerk Magnitude","Freq_Std Body Body Acc Jerk Magnitude",
                          "Freq_MeanFreq Body Body Acc Jerk Magnitude","Freq_Mean Body Body Gyro Magnitude",
                          "Freq_Std Body Body Gyro Magnitude", "Freq_MeanFreq Body Body Gyro Magnitude",
                          "Freq_Mean Body Gyro Jerk Magnitude","Freq_Std Body Gyro Jerk Magnitude",
                          "Freq_MeanFreq Body Gyro Jerk Magnitude", "Activities", "Subjects", "ExperimentalDesign" )
    variables       <- new_names[ 1: num_var ]
    names( full_list ) <- new_names
    
    ## Melts the data using the Actitivies, Subjects and ExperimentalDesign variables as measure variables
    melt_full       <- melt( full_list, id.vars = c( "Activities", "Subjects", "ExperimentalDesign" ),
                             measure.vars = variables ,na.rm = TRUE )
    
    ## Calculates mean for each of the measurement variables, by each subject and each activity.
    ## It also takes into account whether it was the test or train data
    mean_data <- dcast( melt_full, Subjects + Activities + ExperimentalDesign ~ variable, mean )
    
    ## In case we do not want to take ExperimentalDesign into account we should use the below:
    ## mean_data <- dcast( melt_full, Subjects + Activities ~ variable, mean )
    
    ## Saves the dataset to the local working directory
    write.table( mean_data, file = "Tidy dataset.txt", row.name = FALSE )
 }