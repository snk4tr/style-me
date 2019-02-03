import aiohttp

from aiohttp import web

from backend.util.codecs import prepare_image_from_request, prepare_image_for_sending


async def style(request: aiohttp.web.web_request.Request):
    data = await request.read()
    init_image = await prepare_image_from_request(data)
    print(f"Init image with shape [{init_image.shape}] was loaded!")

    model = request.app['models']['style']
    styled_image = model.stylize_image(init_image)
    print('styled_image.shape', styled_image.shape)
    data = await prepare_image_for_sending(styled_image)
    return web.Response(body=data, content_type='image/jpeg')


async def test(request: aiohttp.web_request.Request):
    return web.Response(text="I'm a test page!")
