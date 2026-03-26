# ironclaw-coolify

IronClaw + PostgreSQL + pgvector for Coolify.

## Deploy

1. Create a new Coolify resource from this repo
2. Choose the Docker Compose build pack
3. Attach your domain to the `ironclaw` service
4. Set `LLM_BACKEND`
5. Set the matching provider env vars from the table below
6. Deploy

## Main port

- IronClaw listens on internal port `3000`
- PostgreSQL stays internal to the stack

## Required idea

You must choose one backend with `LLM_BACKEND` and then set the matching env vars.

## LLM_BACKEND values

| LLM_BACKEND | Use these env vars |
| --- | --- |
| `nearai` | `NEARAI_API_KEY` or `NEARAI_SESSION_TOKEN`, optional `NEARAI_MODEL`, `NEARAI_BASE_URL`, `NEARAI_AUTH_URL`, `NEARAI_SESSION_PATH`, `NEARAI_FALLBACK_MODEL`, `NEARAI_MAX_RETRIES` |
| `openai` | `OPENAI_API_KEY`, optional `OPENAI_MODEL`, `OPENAI_BASE_URL` |
| `anthropic` | `ANTHROPIC_API_KEY` or `ANTHROPIC_OAUTH_TOKEN`, optional `ANTHROPIC_MODEL`, `ANTHROPIC_BASE_URL`, `ANTHROPIC_CACHE_RETENTION` |
| `ollama` | `OLLAMA_MODEL`, optional `OLLAMA_BASE_URL` |
| `openai_compatible` | `LLM_BASE_URL`, `LLM_MODEL`, optional `LLM_API_KEY`, `LLM_EXTRA_HEADERS` |
| `minimax` | `MINIMAX_API_KEY`, optional `MINIMAX_MODEL`, `MINIMAX_BASE_URL` |
| `github_copilot` | `GITHUB_COPILOT_TOKEN`, optional `GITHUB_COPILOT_MODEL`, `GITHUB_COPILOT_EXTRA_HEADERS` |
| `openai_codex` | optional `OPENAI_CODEX_MODEL`, `OPENAI_CODEX_CLIENT_ID`, `OPENAI_CODEX_AUTH_URL`, `OPENAI_CODEX_API_URL` |
| `gemini_oauth` | optional `GEMINI_API_KEY`, `GEMINI_MODEL`, `GEMINI_CREDENTIALS_PATH`, `GEMINI_API_KEY_AUTH_MECHANISM`, `GEMINI_SAFETY_BLOCK_NONE`, `GEMINI_CLI_CUSTOM_HEADERS`, `GEMINI_TOP_P`, `GEMINI_TOP_K`, `GEMINI_SEED`, `GEMINI_PRESENCE_PENALTY`, `GEMINI_FREQUENCY_PENALTY`, `GEMINI_RESPONSE_MIME_TYPE`, `GEMINI_RESPONSE_JSON_SCHEMA`, `GEMINI_CACHED_CONTENT` |

## OpenAI-compatible examples

Use `LLM_BACKEND=openai_compatible` for:

- OpenRouter
- Together AI
- Fireworks AI
- vLLM
- LiteLLM
- LM Studio

Set:

- `LLM_BASE_URL`
- `LLM_MODEL`
- optional `LLM_API_KEY`
- optional `LLM_EXTRA_HEADERS`

## Embeddings

Optional:

- `EMBEDDINGS_PROVIDER`
- `EMBEDDINGS_MODEL`

## Other useful vars

Optional:

- `LLM_REQUEST_TIMEOUT_SECS`
- `CIRCUIT_BREAKER_THRESHOLD`
- `CIRCUIT_BREAKER_RECOVERY_SECS`
- `RESPONSE_CACHE_ENABLED`
- `RESPONSE_CACHE_TTL_SECS`
- `RESPONSE_CACHE_MAX_ENTRIES`

## Notes

- For hosted deployments, `nearai` is better with `NEARAI_API_KEY` than browser OAuth
- Coolify will expose the env vars referenced in `docker-compose.yml`
- Postgres password and app secrets are generated with Coolify `SERVICE_*` vars
