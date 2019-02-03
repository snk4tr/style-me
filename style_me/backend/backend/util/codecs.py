import numpy as np
import cv2

from backend.util.validators import image_is_valid


async def prepare_image_from_request(image_bytes: bytes):
    image = cv2.imdecode(np.frombuffer(image_bytes, np.uint8), -1)
    if image.size == 0:
        raise ValueError('Image buffer is too short or contains invalid data')

    if await image_is_valid(image):
        return image

    raise ValueError('Image is broken')


async def prepare_image_for_sending(image: np.ndarray) -> dict:
    success, encoded_image = cv2.imencode('.jpeg', image)
    if not success:
        raise ValueError('Image could not be encoded')

    image_bytes = encoded_image.tobytes()
    return image_bytes

