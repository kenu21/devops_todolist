# Build stage
ARG PYTHON_VERSION=3.13
FROM python:${PYTHON_VERSION}-alpine AS base
WORKDIR /app

COPY manage.py requirements.txt ./
COPY api ./api
COPY accounts ./accounts
COPY lists ./lists
COPY todolist ./todolist

# Runtime stage
FROM python:${PYTHON_VERSION}-alpine
WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY --from=base /app .

VOLUME /app/db

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    python manage.py migrate

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080

ENTRYPOINT ["python", "manage.py", "runserver", "0.0.0.0:8080"]
