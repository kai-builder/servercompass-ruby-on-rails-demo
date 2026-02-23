# syntax=docker/dockerfile:1
# ── Stage 1: gem install ──────────────────────────────────────────────────────
FROM ruby:3.3-slim AS builder

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libsqlite3-dev \
        libyaml-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local deployment true && \
    bundle config set --local without "development test" && \
    bundle install --jobs 4 --retry 3

# ── Stage 2: runtime ─────────────────────────────────────────────────────────
FROM ruby:3.3-slim AS runtime

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        libsqlite3-0 \
        wget \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    SECRET_KEY_BASE=dummy_key_replace_in_production

WORKDIR /app

COPY --from=builder /app/vendor/bundle vendor/bundle
COPY --from=builder /usr/local/bundle/config /usr/local/bundle/config
COPY . .

RUN bundle config set --local deployment true && \
    bundle config set --local path vendor/bundle && \
    bundle config set --local without "development test"

# Create entrypoint
RUN printf '#!/bin/sh\nset -e\nbundle exec rails db:migrate 2>/dev/null || true\nexec bundle exec puma -C config/puma.rb\n' \
    > /usr/local/bin/docker-entrypoint && \
    chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["/usr/local/bin/docker-entrypoint"]
