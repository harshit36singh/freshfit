import os

BASE_URL = "http://127.0.0.1:8000"
IMAGE_PREFIX = "/images"


def build_image_url(image_path: str | None) -> str | None:
    if not image_path:
        return None

    filename = os.path.basename(image_path)
    return f"{BASE_URL}{IMAGE_PREFIX}/{filename}"
