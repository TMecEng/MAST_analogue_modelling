# MAST_analogue_modelling
A collection of the codes used for analysing and processing data from geophysical experimentation. This repository in particular relates to the processing of analogue modelling data from experiments replicating surface deformation. 
# Intel realsense
please first download the sdk from the realsense website
then use the files in the following order:
1. MAST_analogue_modelling/code_for_processing_realsense_bag_file_into_csv (in terminal)
2. MAST_analogue_modelling/Averging_files.py (in python)
3.MAST_analogue_modelling/Code_for_filtering_and_animating_Real_Sense_csv_data.m (in matlab)
4.MAST_analogue_modelling/fn_gaussian.m (in matlab with previous file)
# Kinect
For the kinect please go to https://github.com/capo-urjc/KAM and use the instructions there for the KAM software (you will need the kinect sdk).
Once this is completed use the realsense MAST_analogue_modelling/Code_for_filtering_and_animating_Real_Sense_csv_data.m file for filtering however following the instructions in the kinect filtering branch
