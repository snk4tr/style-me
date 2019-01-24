from style_me_backend.views import style, test


def setup_routes(app):
    # GET routes:
    app.router.add_get('/test', test)

    # POST routes:
    app.router.add_post('/style', style)

