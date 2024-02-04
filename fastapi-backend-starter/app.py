import os
#from dotenv import load_dotenv
import random

from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from propelauth_fastapi import init_auth
from propelauth_py.user import User

app = FastAPI()

origins = [
    "http://localhost:3000",
    "localhost:3000",
    "http://health-data.westeurope.cloudapp.azure.com/api"
]



app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)



# Add login and logout endpoints with Auth0 integration

auth = init_auth(os.getenv("PROPELAUTH_AUTH_URL"), os.getenv("PROPELAUTH_API_KEY"))

@app.get("/whoami")
def who_am_i(user: User = Depends(auth.require_user)):
    return {"user_id": user.user_id, "org_id": user.org_id_to_org_member_info}

# Health Metrics Endpoint
@app.get("/health-dashboard/")
async def read_health_metrics():
    # Mock data for heart rate and blood pressure
    num_data_points = 10  # Change this to the number of data points you want to return
    heart_rate_data = [{"time": f"timestamp{i}", "value": random.randint(60, 100)} for i in range(num_data_points)]
    blood_pressure_data = [{"time": f"timestamp{i}", "value": f"{random.randint(90, 120)}/{random.randint(60, 80)}"} for i in range(num_data_points)]
    
    return {
        "heart_rate": heart_rate_data,
        "blood_pressure": blood_pressure_data
    }


@app.get("/org/{org_id}")
async def view_org(org_id: str, current_user: User = Depends(auth.require_user)):
    org = auth.require_org_member(current_user, org_id)
    return {"org": org}