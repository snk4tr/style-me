import torch
import os
import re
import pytz

from datetime import datetime

from backend.architectures.style import TransformerNet
from backend.util.common import convert_image_to_torch_tensor, save_torch_image, convert_torch_tensor_to_image


class StyleModel:
    def __init__(self, config):
        self.name = self.name = self.__class__.__name__.lower()[:-5]  # remove postfix 'model' from name.

        self.__config = config
        self.__model = self.__init_model()

    def predict(self, content_image):
        with torch.no_grad():
            output = self.__model(content_image).cpu()

        return output[0]

    def stylize_image(self, content_image):
        device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
        content_image = convert_image_to_torch_tensor(content_image, device=device)

        stylized_image = self.predict(content_image)
        stylized_image = convert_torch_tensor_to_image(stylized_image)

        save_path = self.__save_path()
        save_torch_image(data=stylized_image, filename=save_path)
        return stylized_image

    def __init_model(self):
        device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

        weights_to_use_path = self.__weights_path()
        with torch.no_grad():
            style_model = TransformerNet()
            state_dict = torch.load(weights_to_use_path)

            # remove saved deprecated running_* keys in InstanceNorm from the checkpoint
            for k in list(state_dict.keys()):
                if re.search(r'in\d+\.running_(mean|var)$', k):
                    del state_dict[k]

            style_model.load_state_dict(state_dict)
            style_model.to(device)

        return style_model

    def __weights_path(self):
        root_folder = self.__config['general']['weights_root_folder']
        model_folder = self.name
        weights_name = self.__config['style']['weights_name']

        weights_path = os.path.join(root_folder, model_folder, weights_name)
        assert os.path.exists(weights_path), f"There is not weights for style model! " \
            f"Expected to have weights in path: [{weights_path}]"
        assert os.path.isfile(weights_path), f"Found weights are not file! (Folder? O_o)"

        return weights_path

    def __save_path(self):
        out_folder = self.__config['general']['output_folder']
        os.makedirs(out_folder, exist_ok=True)

        today = datetime.now(pytz.utc)
        out_fname = f'{self.name}_{today.day}_{today.month}_{today.year}_{today.hour}_{today.minute}_{today.second}.jpg'
        out_fpath = os.path.join(out_folder, out_fname)
        return out_fpath


