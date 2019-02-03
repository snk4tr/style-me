import numpy as np
import cv2

from backend.util.validators import image_is_valid


async def prepare_image_from_request(image_bytes):
    print('type(image_bytes)', type(image_bytes))
    image = cv2.imdecode(np.frombuffer(image_bytes, np.uint8), -1)
    if await image_is_valid(image):
        return image

    raise ValueError('Image is broken')


async def prepare_image_for_sending(image: np.ndarray) -> dict:
    _, encoded_image = cv2.imencode('.jpeg', image)
    image_bytes = encoded_image.tobytes()
    return image_bytes

