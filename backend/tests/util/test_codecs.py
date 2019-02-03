import unittest
import numpy as np

from backend.settings import config
from backend.util.codecs import decode_bytes_to_image, prepare_image_from_request, prepare_image_for_sending

from tests.util.aux_functions import data_bytes_for_test, image_for_test


class DecodeBytesToImageTest(unittest.TestCase):
    def test_correct_dtype_returned(self):
        sample_byte_array = bytearray([0xA2, 0x01, 0x02, 0x02, 0x03, 0x04])
        method_return_value = decode_bytes_to_image(sample_byte_array)
        expected_dtype = bytes
        observed_dtype = type(method_return_value)
        self.assertEqual(expected_dtype, observed_dtype)


class EncodingDecodingPipelineTest(unittest.TestCase):
    async def test_data_doesnt_get_corrupted(self):
        """
        This test is dedicated to check if all encoding-decoding transformations
        do not corrupt images in any way (change shape, dtype etc.).
        """
        # Let this be an image from request:
        data_bytes = data_bytes_for_test(config)

        # Then it gets decoded:
        init_image = await prepare_image_from_request(data_bytes)

        # Transformations related to DL models are skipped. Then encode back:
        encoded_image = await prepare_image_for_sending(init_image)

        restored_image = decode_bytes_to_image(encoded_image)
        test_image = image_for_test(config)

        self.assertEqual(restored_image.dtype, test_image.dtype)
        self.assertEqual(np.array(restored_image.shape), np.array(test_image.shape))
