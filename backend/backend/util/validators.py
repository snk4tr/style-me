import numpy as np


async def image_is_valid(image: np.ndarray):
    return image.shape[2] == 3 and image.dtype == np.uint8
