import csv
import numpy as np
from sklearn.neighbors import NearestNeighbors
# import time
import sys

def find_nearest_neighbors(file_path, n_neighbors=2):
    # Start timer
    # start_time = time.time()

    # Read CSV file
    data = []
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)  # Skip header row if present
        for row in csv_reader:
            data.append([float(x) for x in row])

    # Convert data to numpy array
    data = np.array(data)

    # Create and fit NearestNeighbors model
    nn = NearestNeighbors(n_neighbors=n_neighbors+1, algorithm='auto', metric='euclidean')
    nn.fit(data)

    # Find nearest neighbors for each point
    distances, indices = nn.kneighbors(data)

    # Find the pair with the smallest distance
    min_distance = float('inf')
    nearest_pair = None

    for i in range(len(data)):
        for j in range(1, n_neighbors+1):
            if distances[i][j] < min_distance:
                min_distance = distances[i][j]
                nearest_pair = (i, indices[i][j])

    # End timer
    # end_time = time.time()

    # Print results
    print(f"Nearest neighbors: Point {nearest_pair[0]} and Point {nearest_pair[1]}")
    print(f"Distance: {min_distance}")
    # print(f"Time taken: {end_time - start_time:.2f} seconds")

    return nearest_pair, min_distance

if __name__ == "__main__":
    # Check if file path is provided as command-line argument
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <path_to_csv_file>")
        sys.exit(1)

    # Get file path from command-line argument
    file_path = sys.argv[1]

    # Run the function
    find_nearest_neighbors(file_path)
