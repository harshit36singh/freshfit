from fastapi import FastAPI

app = FastAPI(title="FreshFit API")

@app.get("/")
def root():
    return {"message": "FreshFit backend is running 🚀"}
