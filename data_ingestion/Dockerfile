# Fetch a compatible version with 3.10.* including the latest patch release
FROM python:3.10

RUN groupadd -r user && useradd -r -g user app

RUN pip install pip -U && pip install pip-tools

RUN mkdir -v /app && chown -R app /app

WORKDIR /app

# Install requirements.txt in new instruction to benefit from the layer caching system.
COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY populate_csv_into_db.py ./
COPY data ./data

# Using non-root user to reduce vulnerabilities
USER app

ENTRYPOINT ["python", "-m", "populate_csv_into_db"]
