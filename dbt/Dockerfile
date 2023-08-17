FROM ghcr.io/dbt-labs/dbt-postgres:1.6.0

RUN groupadd -r user && useradd -r -g user app

RUN mkdir -v /app && chown -R app /app

WORKDIR /app

COPY dbt_project.yml profiles.yml ./
COPY macros ./macros
COPY tests ./tests
COPY models ./models

# Using non-root user to reduce vulnerabilities
USER app
