import numpy as np
import cv2

from functools import reduce

from backend.util.validators import image_is_valid
from backend.util.common import resize_to_standard


async def prepare_image_from_request(image_bytes: bytes, config: dict):
    transformations_to_apply = [
        decode_bytes_to_image,
        lambda img: cv2.cvtColor(img, cv2.COLOR_BGR2RGB),
        lambda img: resize_to_standard(img, config)
    ]

    image = reduce(lambda im, func: func(im), transformations_to_apply, image_bytes)

    if image.size == 0:
        raise ValueError('Image buffer is too short or contains invalid data')

    if not await image_is_valid(image):
        raise ValueError('Image is broken')

    return image


def decode_bytes_to_image(image_bytes: bytes) -> np.ndarray:
    return cv2.imdecode(np.frombuffer(image_bytes, np.uint8), -1)


async def prepare_image_for_sending(image: np.ndarray) -> bytes:
    image_bytes = encode_image_to_bytes(image)
    return image_bytes


def encode_image_to_bytes(image: np.ndarray) -> bytes:
    # For some weird reason IOS encodes images in RGB, but decodes in BGR so to actually represent image
    # on device exactly as it looks after stylization it has to be converted to BGR.
    bgr_image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    success, encoded_image = cv2.imencode('.jpeg', bgr_image)
    if not success:
        raise ValueError('Image could not be encoded')

    image_bytes = encoded_image.tobytes()
    return image_bytes
