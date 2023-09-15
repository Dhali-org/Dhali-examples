import requests
from fastapi import FastAPI, File

app = FastAPI()

@app.get("/some_endpoint/")
async def infer():

   return "Hello, world!"
