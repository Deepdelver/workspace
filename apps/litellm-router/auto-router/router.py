# Lightweight auto-router router placeholder

from typing import Any, Dict

# This is a placeholder to be wired into litellm-router

def route_request(model_candidates: Dict[str, Any], request: Dict[str, Any]) -> Dict[str, Any]:
    """Decide which model to route to for a given request.

    Simple deterministic strategy: pick the first available candidate.
    Return a routing directive dict.
    """
    if not model_candidates:
        return {"error": "no_candidates"}
    first_key = next(iter(model_candidates))
    return {"route_to_model": first_key, "proxy": None}


__all__ = ["route_request"]
