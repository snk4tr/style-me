from backend.models.style import StyleModel


def init_all_models(config: dict) -> dict:
    return {
        'style': StyleModel(config)
    }
