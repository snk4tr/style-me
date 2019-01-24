import pathlib
import yaml

BASE_DIR = pathlib.Path(__file__).parent.parent
config_path = BASE_DIR / 'config' / 'config.yaml'
template_path = BASE_DIR / 'config' / 'config_template.yaml'


def get_configs(conf_path, temp_path):
    with open(conf_path) as f, open(temp_path) as g:
        config = yaml.load(f)
        template = yaml.load(g)

    return config, template


config, template = get_configs(config_path, template_path)
