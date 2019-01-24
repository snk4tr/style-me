from aiohttp import web

from style_me_backend.settings import config
from style_me_backend.routes import setup_routes
from style_me_backend.util.initializers import init_all_models


def setup_app():
    max_post_request_size = 5 * 1024 ** 2  # 5Mb
    app = web.Application(client_max_size=max_post_request_size)

    setup_routes(app)
    app['models'] = init_all_models(config)
    app['config'] = config
    return app


def main():
    app = setup_app()
    web.run_app(app)


if __name__ == '__main__':
    main()
