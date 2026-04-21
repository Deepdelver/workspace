# Auto-router MVP initialization
# This module loads configuration for the auto-router and exposes a simple init hook.

import logging
from typing import Optional

LOGGER = logging.getLogger("litellm.auto_router")
LOGGER.setLevel(logging.INFO)

CONFIG = None
_CONFIG_PATHS = [
    "./litellm-configmap.yaml",
    "./configs/litellm-configmap.yaml",
    "./litellm-configmap.json",
    "./configs/litellm-configmap.json",
]


def init_auto_router(config_path: Optional[str] = None) -> dict:
    """Initialize auto-router by loading configuration. Returns loaded config dict.

    Tries a few common paths relative to this module's directory.
    """
    import os
    global CONFIG
    if CONFIG is not None:
        return CONFIG

    # Resolve likely path variants
    paths_to_try = []
    if config_path:
        paths_to_try.append(config_path)
    # default candidate paths
    for p in _CONFIG_PATHS:
        paths_to_try.append(p)

    loaded = None
    for p in paths_to_try:
        try:
            if os.path.isabs(p) and os.path.exists(p):
                with open(p, "r", encoding="utf-8") as f:
                    import yaml
                    loaded = yaml.safe_load(f)
                    LOGGER.info("Auto-router config loaded from %s", p)
                    break
            elif os.path.exists(os.path.join(os.getcwd(), p)):
                full = os.path.join(os.getcwd(), p)
                with open(full, "r", encoding="utf-8") as f:
                    import yaml
                    loaded = yaml.safe_load(f)
                    LOGGER.info("Auto-router config loaded from %s", full)
                    break
        except Exception as e:
            LOGGER.warning("Failed to load auto-router config from %s: %s", p, e)
            continue

    if loaded is None:
        LOGGER.warning("Auto-router config not found; proceeding with empty config")
        loaded = {}

    CONFIG = loaded
    return CONFIG


__all__ = ["CONFIG", "init_auto_router"]
