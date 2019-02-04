import numpy as np
import unittest

from aiohttp.test_utils import AioHTTPTestCase, unittest_run_loop

from backend.main import setup_app
from backend.settings import config
from backend.util.codecs import decode_bytes_to_image

from tests.util.aux_functions import image_for_test, data_bytes_for_test


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
        data_bytes = data_bytes_for_test(config)

        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)
        assert resp.status == 200, f"Bad response code! Expected [200] got [{resp.status}]"

    @unittest_run_loop
    async def test_returns_correct_type(self):
        data_bytes = data_bytes_for_test(config)
        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)

        response = await resp.read()
        assert type(response) is bytes, f"This response must be of type bytes, got [{type(response)}]"

    @unittest_run_loop
    async def test_image_not_corrupted_with_stylization(self):
        data_bytes = data_bytes_for_test(config)
        resp = await self.client.request("POST", config['routes']['style'], data=data_bytes)

        response = await resp.read()

        init_image = image_for_test(config)
        stylized_image = decode_bytes_to_image(response)

        assert init_image.dtype == stylized_image.dtype, f'Dtypes of init and stylized images have to be the same, ' \
            f'got: init - [{init_image.dtype}], stylized - [{stylized_image.dtype}]'

        assert init_image.shape == stylized_image.shape, f'Init and stylized ' \
            f'images have to be the same shape, got: init - [{init_image.shape}], stylized - [{stylized_image.shape}]'

