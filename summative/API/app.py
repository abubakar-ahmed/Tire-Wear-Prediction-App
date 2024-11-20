import os

base_dir = os.path.dirname(os.path.abspath(__file__))
print("Base directory contents:", os.listdir(base_dir))
print("Parent directory contents:", os.listdir(os.path.join(base_dir, "..")))
print("Linear regression model directory contents:", os.listdir(os.path.join(base_dir, "../linear_regression/model")))
