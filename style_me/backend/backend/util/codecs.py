import json
import numpy as np
import cv2


class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()

        return json.JSONEncoder.default(self, obj)


def prepare_image_from_request(json_dump):
    if type(json_dump) == dict:
        vectorized_image = np.asarray(json_dump["image"])
        img_side = int(np.sqrt(len(vectorized_image) / 3))
        needed_img_length = img_side ** 2 * 3
        vectorized_image = vectorized_image[:needed_img_length]
        image = vectorized_image.reshape(img_side, img_side, 3)
        image = image.astype(np.uint8)
        return image

    json_dump = json.loads(json_dump)
    restored_image = np.asarray(json_dump["image"])
    return restored_image


def prepare_image_for_sending(image: np.ndarray, description: str) -> dict:
    json_dump = json.dumps({'image': image,
                            'description': description}, cls=NumpyEncoder)

    return json_dump
