import unittest

from style_me_backend.settings import config, template


class ConfigCorrectTest(unittest.TestCase):
    def test_keys_match(self):
        self.assertListEqual(list(config.keys()), list(template.keys()),
                             "Config and its template must have the same keys!")

    def test_config_values_filled(self):
        config_values = self.__get_nested_dict_values(config)
        for val in config_values:
            if val is None:
                self.fail("Empty values are not allowed in config!")

    @staticmethod
    def __get_nested_dict_values(d):
        for v in d.values():
            if isinstance(v, dict):
                yield from ConfigCorrectTest.__get_nested_dict_values(v)
            else:
                yield v

