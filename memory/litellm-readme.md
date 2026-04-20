# LiteLLM

LiteLLM is an open source AI Gateway that provides a unified interface to call 100+ LLM providers (including OpenAI, Anthropic, Gemini, Bedrock, Azure, and more) using the OpenAI format. It can be used as a Python SDK or deployed as a Proxy Server (AI Gateway) for centralized access, featuring virtual keys, spend tracking, guardrails, load balancing, and an admin dashboard. LiteLLM simplifies LLM integration by offering drop-in OpenAI compatibility, allowing developers to swap providers without rewriting code.

Key features:
- Unified API for 100+ LLMs
- Drop-in OpenAI compatibility
- Production-ready gateway with virtual keys, spend tracking, guardrails, load balancing, and admin dashboard
- Low latency (8ms P95 at 1k RPS)
- Support for Python SDK and AI Gateway (Proxy Server) deployment modes
- Includes routing, fallback, and retry logic across multiple deployments
- Provides observability callbacks (Lunary, MLflow, Langfuse, etc.)
- Supports virtual keys for secure access control and multi-tenant cost tracking

The LiteLLM Proxy Server acts as a centralized API gateway for LLM requests, enabling authentication, authorization, and detailed analytics.

## Getting Started

### Python SDK
```shell
uv add litellm
```

```python
from litellm import completion
import os

os.environ["OPENAI_API_KEY"] = "your-openai-key"
os.environ["ANTHROPIC_API_KEY"] = "your-anthropic-key"

# OpenAI
response = completion(model="openai/gpt-4o", messages=[{"role": "user", "content": "Hello!"}])

# Anthropic  
response = completion(model="anthropic/claude-sonnet-4-20250514", messages=[{"role": "user", "content": "Hello!"}])
```

### AI Gateway (Proxy Server)
```shell
uv tool install 'litellm[proxy]'
litellm --model gpt-4o
```

```python
import openai

client = openai.OpenAI(api_key="anything", base_url="http://0.0.0.0:4000")
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello!"}]
)
```

## Supported Providers
LiteLLM supports 100+ LLM providers including:
- OpenAI (GPT-4, GPT-3.5, etc.)
- Anthropic (Claude series)
- Google (Gemini, Palm)
- Azure OpenAI
- AWS Bedrock
- Hugging Face
- Replicate
- Ollama (local)
- And many more

## Features
- **Routing**: Intelligent model selection based on cost, latency, or custom logic
- **Fallbacks**: Automatic retry on failed deployments
- **Load Balancing**: Distribute requests across multiple instances
- **Cost Tracking**: Monitor spending per user, team, or project
- **Guardrails**: Input validation and output filtering
- **Virtual Keys**: Secure API key management
- **Admin Dashboard**: UI for monitoring and management
- **Observability**: Integration with Lunary, MLflow, Langfuse, etc.

## Use Cases
- Centralized LLM gateway for enterprises
- Multi-provider LLM applications
- Development and testing with different models
- Cost optimization through intelligent routing
- Secure LLM access with key management

For more information, visit the official documentation at https://docs.litellm.ai/