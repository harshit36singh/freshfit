import os

BASE_URL = "https://freshfit-backend.onrender.com"
IMAGE_PREFIX = "/images"


def build_image_url(image_path: str | None) -> str | None:
    if not image_path:
        return None

    filename = os.path.basename(image_path)
    return f"{BASE_URL}{IMAGE_PREFIX}/{filename}"