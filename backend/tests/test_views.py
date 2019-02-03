import os
import json
import numpy as np

from aiohttp.test_utils import AioHTTPTestCase, unittest_run_loop

from backend.main import setup_app
from backend.settings import config
from backend.util.common import load_image
from backend.util.codecs import encode_image_to_bytes, decode_bytes_to_image


class TestViewTest(AioHTTPTestCase):
    async def get_application(self):
        return setup_app()

    @unittest_run_loop
    async def test_view_test(self):
        resp = await self.client.request("GET", config['routes']['test'])
        assert resp.status == 200, f"Bad response code! Expected [200] got [{resp.status}]"

        text = await resp.text()
        assert type(text) is str, f"Text response must be of type str, got [{type(text)}]!"
        assert "test page" in text, f"Wrong text is returned! Returned text: [{text}]"


class StyleViewTest(AioHTTPTestCase):
    async def get_application(self):
        return setup_app()

    @unittest_run_loop
    async def test_response_status(self):
        data_bytes = self.__data_for_style_test()

        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)
        assert resp.status == 200, f"Bad response code! Expected [200] got [{resp.status}]"

    @unittest_run_loop
    async def test_returns_correct_type(self):
        data_bytes = self.__data_for_style_test()
        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)

        response = await resp.read()
        assert type(response) is bytes, f"This response must be of type bytes, got [{type(response)}]"

    @unittest_run_loop
    async def test_image_not_corrupted_with_stylization(self):
        data_bytes = self.__data_for_style_test()
        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)

        response = await resp.read()

        init_image = self.__image_for_style_test()
        stylized_image = decode_bytes_to_image(response)

        assert init_image.dtype == stylized_image.dtype, f'Dtypes of init and stylized images have to be the same, ' \
            f'got: init - [{init_image.dtype}], stylized - [{stylized_image.dtype}]'

        assert np.array_equal(np.array(init_image.shape), np.array(stylized_image.shape)), f'Init and stylized ' \
            f'images have to be the same shape, got: init - [{init_image.shape}], stylized - [{stylized_image.shape}]'

    @staticmethod
    def __data_for_style_test() -> bytes:
        test_image = StyleViewTest.__image_for_style_test()
        image_bytes = encode_image_to_bytes(test_image)
        return image_bytes

    @staticmethod
    def __image_for_style_test():
        root_folder = config['test']['root_folder']
        resources_folder = config['test']['resources_folder']
        image_fname = config['test']['style_example_image']

        example_image_fpath = os.path.join(root_folder, resources_folder, image_fname)

        test_image = load_image(example_image_fpath)
        return test_image
