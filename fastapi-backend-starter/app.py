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
async def read_health_metrics(user: User = Depends(auth.require_user)):
    # Mock data for heart rate and blood pressure
    heart_rate = random.randint(60, 100)
    blood_pressure = f"{random.randint(90, 120)}/{random.randint(60, 80)}"
    
    return {
        "heart_rate": heart_rate,
        "blood_pressure": blood_pressure
    }


@app.get("/org/{org_id}")
async def view_org(org_id: str, current_user: User = Depends(auth.require_user)):
    org = auth.require_org_member(current_user, org_id)
    return {"org": org}