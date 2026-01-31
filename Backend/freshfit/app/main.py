from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.routes import auth
from app.api.routes import wardrobe
from app.api.routes import upload
from fastapi.staticfiles import StaticFiles
from app.api.routes import outfit
from app.models.user import User
from app.models.cloth import Cloth
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.responses import HTMLResponse
from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.db.session import engine
from app.db.base import Base

@asynccontextmanager
async def lifespan(app: FastAPI):
    
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="FreshFit API",
    docs_url=None,
    redoc_url=None,
    lifespan=lifespan,
)


app.mount(
    "/images",
    StaticFiles(directory="uploads/clothes"),
    name="images",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(wardrobe.router)
app.include_router(upload.router)
app.include_router(outfit.router)


@app.get("/docs", include_in_schema=False)
def custom_swagger_ui():
    html = get_swagger_ui_html(
        openapi_url="/openapi.json",
        title="FreshFit API Docs",
    ).body.decode("utf-8")

    toggle_code = """
<style>
    :root {
        --bg: #ffffff;
        --fg: #111827;
        --border: #d1d5db;
    }

    body.dark {
        --bg: #0b0b0b;
        --fg: #e5e7eb;
        --border: #374151;
    }

    body {
        background-color: var(--bg);
        color: var(--fg);
    }

    body.dark .swagger-ui {
        filter: invert(1) hue-rotate(180deg);
    }

    body.dark .swagger-ui img {
        filter: invert(1) hue-rotate(180deg);
    }

    #theme-toggle {
        position: fixed;
        top: 14px;
        right: 20px;
        z-index: 9999;
        background: transparent;
        color: var(--fg);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 4px 10px;
        font-size: 13px;
        cursor: pointer;
    }

    #theme-toggle:hover {
        opacity: 0.85;
    }
</style>

<button id="theme-toggle"></button>

<script>
    const btn = document.getElementById("theme-toggle");
    const saved = localStorage.getItem("swagger-theme");

    if (saved === "dark") {
        document.body.classList.add("dark");
    }

    btn.textContent = document.body.classList.contains("dark") ? "Light" : "Dark";

    btn.onclick = () => {
        document.body.classList.toggle("dark");
        const dark = document.body.classList.contains("dark");
        localStorage.setItem("swagger-theme", dark ? "dark" : "light");
        btn.textContent = dark ? "Light" : "Dark";
    };
</script>
"""

    return HTMLResponse(html.replace("</body>", f"{toggle_code}</body>"))


@app.get("/")
def root():
    return {"status": "FreshFit backend running"}


@app.get("/health")
def health_check():
    return {"ok": True}
