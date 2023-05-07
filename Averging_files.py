import os
import csv

input_dir = r"A:Location\of\realsense\csvfiles"

#this will store the averaged files in a foldernamed average
output_dir = os.path.join(input_dir, "Averaged")
if not os.path.exists(output_dir):
    os.mkdir(output_dir)

#n sets the number of files avewraged together
n = 5
#please name the files for averaging by the convention 
#A:Location\of\realsense\csvfiles\nameoffile (1), A:Location\of\realsense\csvfiles\nameoffile (2) etc
files = sorted([f for f in os.listdir(input_dir) if f.startswith('nameoffile ')],
               key=lambda x: int(x.split('(')[-1].split(')')[0]))
num_files = len(files)
num_groups = num_files // n

for i in range(num_groups):
    group_files = files[i*n : (i+1)*n]
    data = None
    for f in group_files:
        with open(os.path.join(input_dir, f), 'r') as csvfile:
            reader = csv.reader(csvfile)
            rows = [row for row in reader]
            if data is None:
                data = rows
            else:
                for j in range(len(rows)):
                    for k in range(len(rows[j])):
                        data[j][k] = str(float(data[j][k]) + float(rows[j][k]))
    for j in range(len(data)):
        for k in range(len(data[j])):
            data[j][k] = str(float(data[j][k]) / n)
    output_filename = f'Averaged_{i*n+1}_{(i+1)*n}.csv'
    with open(os.path.join(output_dir, output_filename), 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(data)
        #this will open a terminal window and tell you, for the first five averaged, the files exactly which were used to create them
    if i < 5:
        file_names = ", ".join(group_files)
        print(f"Files processed in Averaged_{i*n+1}_{(i+1)*n}.csv: {file_names}")



