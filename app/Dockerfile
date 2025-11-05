# Stage 1: Build
FROM python:3.12-slim AS builder
WORKDIR /app
COPY src/ /app/src/
RUN pip install --no-cache-dir flask

# Stage 2: Runtime
FROM python:3.12-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/src /app/src
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
ENV SYS_ENV=helloworld
USER 1000 
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/healthz || exit 1
CMD ["python", "-m", "src.main"]
