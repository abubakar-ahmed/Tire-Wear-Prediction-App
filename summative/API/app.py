import asyncio
import uvicorn
from typing import Annotated
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib as jb
import os

# Load the tire wear model
# Load the tire wear model
base_dir = os.path.dirname(os.path.abspath(__file__))  # Get the directory of app.py
model_path = os.path.join(base_dir, "linear_regression/model/tire_wear_model.joblib")

# Load the tire wear model
try:
    with open(model_path, "rb") as file:
        tire_wear_model = jb.load(file)
except FileNotFoundError:
    raise RuntimeError(f"Model file not found at {model_path}")

# Create FastAPI instance
app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow requests from any origin
    allow_credentials=True,
    allow_methods=["GET", "POST"],  # Allow GET and POST requests
    allow_headers=["*"],  # Allow any headers
)

# Define the request model with the fields required for the tire wear prediction
class TireRequest(BaseModel):
    tire_compound_hard: int = Field(ge=0, le=1)
    tire_compound_medium: int = Field(ge=0, le=1)
    tire_compound_soft: int = Field(ge=0, le=1)
    tire_compound_wet: int = Field(ge=0, le=1)
    track_temperature: float = Field(gt=0, lt=100)
    laps_driven: int = Field(ge=0, lt=1000)
    car_weight: float = Field(gt=0, lt=2000)
    track_surface_rough: int = Field(ge=0, le=1)
    track_surface_smooth: int = Field(ge=0, le=1)
    driving_style_aggressive: int = Field(ge=0, le=1)
    driving_style_balanced: int = Field(ge=0, le=1)
    driving_style_conservative: int = Field(ge=0, le=1)
    weather_dry: int = Field(ge=0, le=1)
    weather_wet: int = Field(ge=0, le=1)

# Test endpoint
@app.get("/class")
async def get_greet():
    return {"Message": "Hello Class"}

# Health check endpoint
@app.get("/", status_code=status.HTTP_200_OK)
async def get_hello():
    return {"hello": "world"}

# Prediction endpoint
@app.post("/predict")
async def make_prediction(request: TireRequest):
    try:
        # Prepare the input data for prediction
        data = [
            [
                request.tire_compound_hard,
                request.tire_compound_medium,
                request.tire_compound_soft,
                request.tire_compound_wet,
                request.track_temperature,
                request.laps_driven,
                request.car_weight,
                request.track_surface_rough,
                request.track_surface_smooth,
                request.driving_style_aggressive,
                request.driving_style_balanced,
                request.driving_style_conservative,
                request.weather_dry,
                request.weather_wet,
            ]
        ]

        # Make a prediction
        prediction = tire_wear_model.predict(data)

        # Return the prediction as a JSON response
        return {"prediction": prediction.tolist()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")


# Main entry point
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
