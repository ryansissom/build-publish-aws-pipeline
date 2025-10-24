import os
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello world!"}

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8080))  # default to 8080 if not set
    uvicorn.run(app, host="0.0.0.0", port=port)
