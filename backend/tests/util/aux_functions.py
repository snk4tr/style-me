import os

from backend.util.common import load_image
from backend.util.codecs import encode_image_to_bytes


def data_bytes_for_test(config: dict) -> bytes:
    test_image = image_for_test(config)
    image_bytes = encode_image_to_bytes(test_image)
    return image_bytes


def image_for_test(config: dict):
    root_folder = config['test']['root_folder']
    resources_folder = config['test']['resources_folder']
    image_fname = config['test']['style_example_image']

    example_image_fpath = os.path.join(root_folder, resources_folder, image_fname)

    test_image = load_image(example_image_fpath)
    return test_image
