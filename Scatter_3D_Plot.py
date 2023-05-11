import numpy as np
import matplotlib.pyplot as plt
import csv



def import_data(file_path):
    # Open the CSV file
    with open(file_path, 'r', encoding='iso-8859-1') as file:
        reader = csv.reader(file, delimiter=';', quotechar='|')
        data = list(reader)  # convert to a list

    return data


def clean(data):
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


def smooth(y, box_pts):
    box = np.ones(box_pts)/box_pts
    y_smooth = np.convolve(y, box, mode='same')
    return y_smooth

# Main function to run the program
def main():
    # file path
    file_path = 'Add_file_path_here.csv'
    data = np.array(retrieve_and_clean(file_path))

    # define X, Y and Z
    X = extract_xyz(data, 0)
    Y = extract_xyz(data, 1)
    Z = extract_xyz(data, 5)
    Z1hat = smooth(Z, 5)
    Z1_3dp = np.around(Z, decimals=1) #use this to round the data to a determind decimal place


    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    cmap = plt.cm.get_cmap('cool')
    ax.scatter(X, Y, Z1hat, c=Z, marker='o')
    ax.set_zlim(0, 2)
    ax.set_xlabel('X Label')
    ax.set_ylabel('Y Label')
    ax.set_zlabel('Z Label')

    plt.show()


if __name__ == '__main__':
    main()

