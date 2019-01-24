import os
import cv2
import json

from aiohttp.test_utils import AioHTTPTestCase, unittest_run_loop

from main import setup_app
from style_me_backend.settings import config
from style_me_backend.util.common import load_image
from style_me_backend.util.codecs import prepare_image_for_sending
from util.common import get_variable_size


class ServerFunctionalityTest(AioHTTPTestCase):
    async def get_application(self):
        return setup_app()

    @unittest_run_loop
    async def test_view_test(self):
        resp = await self.client.request("GET", config['routes']['test'])
        assert resp.status == 200, f"Bad response code! Expected [200] got [{resp.status}]"

        text = await resp.text()
        assert type(text) is str, f"Text response must be of type str, got [{type(text)}]!"
        assert "test page" in text, f"Wrong text is returned! Returned text: [{text}]"

    @unittest_run_loop
    async def test_view_style(self):
        json_data = self.__get_data_for_style_test()
        print('Size of json data:', get_variable_size(json_data) / (1024 * 1024), 'Mb')

        resp = await self.client.request("POST", config['routes']['style'], json=json_data)
        assert resp.status == 200, f"Bad response code! Expected [200] got [{resp.status}]"

        json_resp = await resp.json()
        assert type(json_resp) is str, f"This response must be of type dict, got [{type(json_resp)}]"

        json_resp = json.loads(json_resp)
        assert len(json_resp.keys()) > 0, f"There must be several keys in this response! " \
            f"Got [{len(json_resp.keys())}] which are: [{json_resp.keys()}]"

        for val in json_resp.values():
            assert val is not None, "There must be no None values in this response!"

    @staticmethod
    def __get_data_for_style_test():
        root_folder = config['test']['root_folder']
        resources_folder = config['test']['resources_folder']
        image_fname = config['test']['style_example_image']

        example_image_fpath = os.path.join(root_folder, resources_folder, image_fname)
        test_image = load_image(example_image_fpath)

        standard_side = config['style']['img_side']
        if any([side != standard_side for side in test_image.shape[:2]]):
            test_image = cv2.resize(test_image, (standard_side, standard_side))

        jsonified_test_image = prepare_image_for_sending(test_image, description="Example image")
        return jsonified_test_image
