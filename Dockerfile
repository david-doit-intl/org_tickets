FROM python:3.9-slim-buster

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

WORKDIR /app

COPY pdm.lock pyproject.toml /app/

RUN pip -q install pdm

RUN pdm sync --prod > /dev/null

COPY generate.py .

CMD pdm run gunicorn --bind :$PORT --workers 1 --threads 1 --timeout 0 generate:app
