FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY pyproject.toml alembic.ini ./
COPY app ./app
COPY migrations ./migrations
RUN pip install --no-cache-dir .

COPY docker-entrypoint.sh /usr/local/bin/cnr-editor-entrypoint
RUN chmod 0755 /usr/local/bin/cnr-editor-entrypoint

ENTRYPOINT ["cnr-editor-entrypoint"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
