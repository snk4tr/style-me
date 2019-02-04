import sys

import numpy as np
import torch
import cv2

from PIL import Image
from torchvision import transforms


def save_torch_image(data: np.ndarray, filename: str):
    img = Image.fromarray(data)
    img.save(filename)


def convert_image_to_torch_tensor(content_image, device):
    device = torch.device(device)
    content_transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Lambda(lambda x_: x_.mul(255))
    ])

    content_image = content_transform(content_image)
    content_image = content_image.type(torch.FloatTensor)
    content_image = content_image.unsqueeze(0).to(device)

    return content_image


def convert_torch_tensor_to_image(image_tensor, img_type=np.uint8):
    """
    Convert object from PyTorch internal representation (tensor) to image with values of defined type.

    Args:
        image_tensor(torch.Tensor): tensor to be converted.
        img_type(type): type of elements in resulting np.ndarray.

    Returns:
        (np.ndarray): converted object.
    """
    img = image_tensor.clone().numpy()
    img = (img.transpose(1, 2, 0)).clip(0, 255).astype("uint8")
    return img


def load_image(img_fpath: str) -> np.array:
    img = cv2.imread(img_fpath)

    if img is None:
        raise FileNotFoundError(f'Image was not found on path [{img_fpath}]')

    assert img.shape[2] == 3, f"Img should have 3 channels, got [{img.shape[2]}]"
    return cv2.cvtColor(img, cv2.COLOR_BGR2RGB)


def get_variable_size(obj, seen=None):
    """ Recursively finds size of objects in bytes """
    size = sys.getsizeof(obj)
    if seen is None:
        seen = set()

    obj_id = id(obj)
    if obj_id in seen:
        return 0

    # Important mark as seen *before* entering recursion to gracefully handle
    # self-referential objects
    seen.add(obj_id)
    if isinstance(obj, dict):
        size += sum([get_variable_size(v, seen) for v in obj.values()])
        size += sum([get_variable_size(k, seen) for k in obj.keys()])
    elif hasattr(obj, '__dict__'):
        size += get_variable_size(obj.__dict__, seen)
    elif hasattr(obj, '__iter__') and not isinstance(obj, (str, bytes, bytearray)):
        size += sum([get_variable_size(i, seen) for i in obj])

    return size


def resize_to_standard(image: np.ndarray, config: dict):
    standard_side = config['style']['img_side']
    if any([side != standard_side for side in image.shape[:2]]):
        return cv2.resize(image, (standard_side, standard_side))

    return image


def center_crop(init_image, stylized_image):
    """
    Crops central part of stylized image in case if paddings used in Style model led
    to the fact that the shape appeared to be slightly greater than the original.

    Args:
        init_image(np.ndarray): initial image.
        stylized_image(np.ndarray): stylized image.

    Returns(np.ndarray):
        cropped styled image.
    """
    if init_image.shape == stylized_image.shape:
        return stylized_image

    height, width = stylized_image.shape[0], stylized_image.shape[1]
    new_height, new_width = init_image.shape[0], init_image.shape[1]

    left = (width - new_width) // 2
    top = (height - new_height) // 2
    right = (width + new_width) // 2
    bottom = (height + new_height) // 2

    new_stylized_image = np.zeros(init_image.shape, dtype=np.uint8)
    for i in range(stylized_image.shape[-1]):
        new_stylized_image[..., i] = stylized_image[top: bottom, left: right, i]

    return new_stylized_image
