from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn

app = FastAPI()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#  inputs  with enforced data types
class PredictionRequest(BaseModel):
    age: int
    bmi: float
    children: int
    sex: str
    smoker: str
    region: str

# Load the model 
model = joblib.load('../summative/linear_regression/best_model.pkl')

@app.post('/predict')
def predict(request: PredictionRequest):
    # Convert categorical variables to the format expected by the model
    features = [
        request.age,
        request.bmi,
        request.children,
        1 if request.sex == 'male' else 0,
        1 if request.smoker == 'yes' else 0,
        1 if request.region == 'southeast' else 0,
        1 if request.region == 'southwest' else 0,
        1 if request.region == 'northeast' else 0,
        
    ]
    X = np.array(features).reshape(1, -1)
    prediction = model.predict(X)
    return {"prediction": prediction.tolist()}

