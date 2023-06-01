# This piece of code outputs the x and y positions of the point of max z-displacement as they change through time
# To use it scroll down to the 'main' function and edit the filepath and range of data
# Make sure that all you files have the same prefix and the only part of the name changing is the last 4 numbers.

import numpy as np
import os
import matplotlib.pyplot as plt
import csv



def import_data(file_path):
    # Open the CSV file
    with open(file_path, 'r', encoding='iso-8859-1') as file:
        reader = csv.reader(file, delimiter=';', quotechar='|')
        data = list(reader)  # convert to a list

    return data


def clean(data): # this decides which data to keep from the csv files
    clean_data = [[row[i] for i in range(len(row)) if i in (0, 1, 2, 3, 4, 5)] for row in data]
    clean_data.pop(0)

    return clean_data


def retrieve_and_clean(filepath):
    data = import_data(filepath)
    cleaned_data = clean(data)

    return cleaned_data


def extract_xyz(array, column):  # Extract each column from a large array as a single column

    variable = array[:, column].astype(float)
    # variable1 = variable.astype(int)

    return variable



def find_max_value(arr):
    max_value = arr[0]
    max_pos = 0

    for i in range(1, len(arr)):
        if arr[i] > max_value:
            max_value = arr[i]
            max_pos = i

    return max_pos

def save_csv(filename, data): #saves a 2D array as a csv file
    # Open the CSV file in write mode
    with open(filename, "w", newline="") as file:

        # Create a CSV writer object
        writer = csv.writer(file)

        # Write each row of the array to the CSV file
        for row in data:
            writer.writerow(row)

    print(f"CSV file '{filename}' saved successfully!")

# Main function to run the program
def main():

    max_data = []
#change the range to the largest number in your files
    for i in range(1, 3000):
        #copy the filename from file path, you may need to change the prefix for whatever the prefix is to the 4 numbers at the end of the file name
        filename = "Insert_prefix_of_datafile_names{:04d}.csv".format(i)
        if os.path.exists(filename):
            data = np.array(retrieve_and_clean(filename))
            X = extract_xyz(data, 0)
            Y = extract_xyz(data, 1)
            Z_disp = extract_xyz(data, 5)
            Z_disp_max = max(Z_disp)
            Xcoor_max = X[find_max_value(Z_disp)]
            Ycoor_max = Y[find_max_value(Z_disp)]
            xyz_max = [Xcoor_max, Ycoor_max, Z_disp_max]
            max_data.append(xyz_max)
        else:
            continue
    print(max_data)

#title your new retreived max z data
    save_csv("FILE_NAME.csv", max_data)
    col3 = [row[2] for row in max_data]  # extract third column
    plt.plot(np.arange(len(col3)), col3)  # plot against index
    plt.xlabel('Index')
    plt.ylabel('max z')
    plt.title('index')
    plt.show()


if __name__ == '__main__':
    main()

