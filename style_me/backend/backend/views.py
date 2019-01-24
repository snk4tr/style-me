import aiohttp

from aiohttp import web

from style_me_backend.util.codecs import prepare_image_from_request, prepare_image_for_sending


async def style(request: aiohttp.web_request.Request):
    json_request = await request.json()
    init_image = prepare_image_from_request(json_request)
    print(f"Init image with shape [{init_image.shape}] was loaded!")

    model = request.app['models']['style']
    styled_image = model.stylize_image(init_image)
    description = "Image, stylized be Style Transfer model."

    data = prepare_image_for_sending(styled_image, description)
    return web.json_response(data)


async def test(request: aiohttp.web_request.Request):
    return web.Response(text="I'm a test page!")
