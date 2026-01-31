import cv2
import numpy as np


def extract_dominant_color(image_path: str) -> str:
    image = cv2.imread(image_path)

    if image is None:
        return "unknown"

    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    image = cv2.resize(image, (64, 64), interpolation=cv2.INTER_AREA)

    # Flatten and convert once
    pixels = image.reshape(-1, 3).astype(np.float32)

    # KMeans (fewer clusters + fewer iterations)
    k = 3
    criteria = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_MAX_ITER, 8, 1.0)

    _, labels, centers = cv2.kmeans(
        pixels,
        k,
        None,
        criteria,
        5,
        cv2.KMEANS_PP_CENTERS
    )

    # Most frequent cluster
    dominant = centers[np.bincount(labels.ravel()).argmax()]

    return rgb_to_color_name(*dominant.astype(int))


def rgb_to_color_name(r: int, g: int, b: int) -> str:
    if r > 200 and g < 100 and b < 100:
        return "red"
    if g > 200 and r < 100 and b < 100:
        return "green"
    if b > 200 and r < 100 and g < 100:
        return "blue"
    if r > 200 and g > 200 and b < 100:
        return "yellow"
    if r < 80 and g < 80 and b < 80:
        return "black"
    if r > 200 and g > 200 and b > 200:
        return "white"
    return "unknown"
