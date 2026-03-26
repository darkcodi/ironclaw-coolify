# Multi-stage Dockerfile for IronClaw with a local Caddy wrapper.
#
# Build:
#   docker build --platform linux/amd64 -t ironclaw:latest .
#
# Run:
#   docker run --env-file .env -p 8080:8080 ironclaw:latest

# Stage 1: Build
FROM rust:1.92-slim-bookworm AS builder

ARG IRONCLAW_REF=v0.20.0
ARG IRONCLAW_REPO=https://github.com/nearai/ironclaw.git

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev cmake gcc g++ git \
    && rm -rf /var/lib/apt/lists/* \
    && rustup target add wasm32-wasip2 \
    && cargo install wasm-tools

WORKDIR /app

# Clone source since local source files are not available
RUN git clone --depth 1 --branch ${IRONCLAW_REF} ${IRONCLAW_REPO} /app

RUN cargo build --release --bin ironclaw

# Stage 2: Build caddy
FROM caddy:2.10.2-builder AS caddy_builder
RUN xcaddy build

# Stage 3: Runtime
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl3 bash curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/ironclaw /usr/local/bin/ironclaw
COPY --from=builder /app/migrations /app/migrations
COPY --from=caddy_builder /usr/bin/caddy /usr/bin/caddy

COPY Caddyfile /etc/caddy/Caddyfile
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && useradd -m -u 1000 -s /bin/bash ironclaw

USER ironclaw
WORKDIR /home/ironclaw

EXPOSE 8080

ENV RUST_LOG=ironclaw=info
ENV SANDBOX_ENABLED=false

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
