import csv
import numpy as np
from sklearn.neighbors import NearestNeighbors
import sys

def find_nearest_neighbors(file_path, n_neighbors=2):
    # Read CSV file
    data = []
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)  # Skip header row if present
        for row in csv_reader:
            data.append([float(x) for x in row])

    # Convert data to numpy array
    data = np.array(data)
    # Get the first point
    first_point = data[0]

    # Get the first point
    first_point = data[0]

    # Create and fit NearestNeighbors model
    nn = NearestNeighbors(n_neighbors=n_neighbors+1, algorithm='auto', metric='euclidean')
    nn.fit(data)

    # Find nearest neighbors for the first point
    distances, indices = nn.kneighbors([first_point])

    # The first neighbor will be the point itself, so we take the next two
    nearest_neighbors = [data[indices[0][1]], data[indices[0][2]]]
    distances = [distances[0][1], distances[0][2]]

    # Print results
    # print(f"First point: {first_point.tolist()}")
    # print(f"Nearest neighbors:")
    print(f"1: {nearest_neighbors[0].tolist()}, Distance: {distances[0]}")
    print(f"2: {nearest_neighbors[1].tolist()}, Distance: {distances[1]}")

    return first_point, nearest_neighbors, distances

if __name__ == "__main__":
    # Check if file path is provided as command-line argument
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <path_to_csv_file>")
        sys.exit(1)

    # Get file path from command-line argument
    file_path = sys.argv[1]

    # Run the function
    find_nearest_neighbors(file_path)
