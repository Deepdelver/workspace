## Crawled Content from https://docs.litellm.ai/

### Installation
```bash
uv add litellm
```

### Basic Usage
```python
from litellm import completion

response = completion(
    model="openai/gpt-5",
    messages=[{"content": "Hello!", "role": "user"}]
)
```

### Key Features
- Call 100+ LLMs with consistent OpenAI format
- Built-in router for fallback logic
- Cost tracking via proxy server

---
*Source crawled on 2026-04-19 via crawl4ai-skill*