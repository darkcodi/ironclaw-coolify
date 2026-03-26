FROM rust:1.92-slim-bookworm AS builder

ARG IRONCLAW_REF=v0.20.0
ARG IRONCLAW_REPO=https://github.com/nearai/ironclaw.git

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev cmake gcc g++ git \
    && rm -rf /var/lib/apt/lists/* \
    && rustup target add wasm32-wasip2 \
    && cargo install wasm-tools

WORKDIR /app

RUN git clone --depth 1 --branch ${IRONCLAW_REF} ${IRONCLAW_REPO} /app

RUN cargo build --release --bin ironclaw

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl3 bash \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/ironclaw /usr/local/bin/ironclaw
COPY --from=builder /app/migrations /app/migrations
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && useradd -m -u 1000 -s /bin/bash ironclaw

USER ironclaw
WORKDIR /home/ironclaw

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
