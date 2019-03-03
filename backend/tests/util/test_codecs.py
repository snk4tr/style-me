import pytest

from backend.settings import config
from backend.util.codecs import decode_bytes_to_image, prepare_image_from_request, prepare_image_for_sending

from tests.util.aux_functions import data_bytes_for_test, image_for_test


@pytest.mark.asyncio
async def test_data_doesnt_get_corrupted():
    """
    This test is dedicated to check if all encoding-decoding transformations
    do not corrupt images in any way (change shape, dtype etc.).
    """
    # Let this be an image from request:
    data_bytes = data_bytes_for_test(config)

    # Then it gets decoded:
    init_image = await prepare_image_from_request(data_bytes, config)

    # Transformations related to DL models are skipped. Then encode back:
    encoded_image = await prepare_image_for_sending(init_image)

    restored_image = decode_bytes_to_image(encoded_image)
    test_image = image_for_test(config)

    assert restored_image.dtype == test_image.dtype, 'Image dtype must stay the same!'


