import random
from typing import Dict, List
from app.models.cloth import Cloth


CATEGORY_MAP = {
    "top": ["shirt", "t-shirt"],
    "bottom": ["pants", "jeans"],
    "shoes": ["shoes"],
}


COLOR_COMPATIBILITY = {
    "black": ["white", "blue", "grey", "black"],
    "white": ["black", "blue", "grey"],
    "blue": ["white", "black", "grey"],
    "grey": ["black", "white", "blue"],
}


def filter_by_category(clothes: List[Cloth], categories: List[str]) -> List[Cloth]:
    return [c for c in clothes if c.category in categories]


def is_color_compatible(base: str, candidate: str) -> bool:
    if base not in COLOR_COMPATIBILITY:
        return True
    return candidate in COLOR_COMPATIBILITY[base]


def generate_outfit(clothes: List[Cloth]) -> Dict[str, Cloth]:
    outfit = {}

    tops = filter_by_category(clothes, CATEGORY_MAP["top"])
    bottoms = filter_by_category(clothes, CATEGORY_MAP["bottom"])
    shoes = filter_by_category(clothes, CATEGORY_MAP["shoes"])

    if not tops or not bottoms or not shoes:
        raise ValueError("Not enough clothes to generate outfit")

    top = random.choice(tops)
    outfit["top"] = top

    compatible_bottoms = [
        b for b in bottoms if is_color_compatible(top.color, b.color)
    ]
    outfit["bottom"] = random.choice(compatible_bottoms or bottoms)

    compatible_shoes = [
        s for s in shoes if is_color_compatible(top.color, s.color)
    ]
    outfit["shoes"] = random.choice(compatible_shoes or shoes)

    return outfit
