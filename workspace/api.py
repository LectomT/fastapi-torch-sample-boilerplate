import uvicorn
import torch
import math, time
from fastapi import FastAPI, status, Path, Query, File, UploadFile, Form, Request
from pydantic import BaseModel
from fastapi.responses import HTMLResponse
from app import *

app = FastAPI()

class HealthCheck(BaseModel):
    """Response model to validate and return when performing a health check."""
    global request_id
    status: str = "OK"
    timestamp: int = math.floor(time.time())

@app.get(
    "/health",
    tags=["healthcheck"],
    summary="Perform a Health Check",
    response_description="Return HTTP Status Code 200 (OK)",
    status_code=status.HTTP_200_OK,
    response_model=HealthCheck,
)
async def get_health() -> HealthCheck:
    """
    ## Perform a Health Check
    Endpoint to perform a healthcheck on. This endpoint can primarily be used Docker
    to ensure a robust container orchestration and management is in place. Other
    services which rely on proper functioning of the API service will not deploy if this
    endpoint returns any other HTTP status code except 200 (OK).
    Returns:
        HealthCheck: Returns a JSON response with the health status
    """
    global request_id
    return HealthCheck(status="OK", timestamp=math.floor(time.time()))


@app.get("/")
def read_root():
    return {"hello":"world!"}