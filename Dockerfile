# syntax=docker/dockerfile:1.7
# Multi-service Dockerfile - build target can be specified via --target flag
# Default builds the api service

# ============ API Service ============
FROM golang:1.26.2 AS builder-api

WORKDIR /app

COPY go.mod ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -o go-app ./services/api

# Final stage for API
FROM alpine:latest AS api

WORKDIR /app

COPY --from=builder-api /app/go-app .

CMD ["/app/go-app"]

# ============ Frontend Service (placeholder) ============
FROM golang:1.26.2 AS builder-frontend

WORKDIR /app

COPY go.mod ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

# Frontend service would be built here (when created)
# RUN go build -o frontend-app ./services/frontend

# For now, use a placeholder image
FROM alpine:latest AS frontend

WORKDIR /app

# Placeholder - replace with actual frontend service when ready
RUN echo "Frontend service not yet implemented" > message.txt

CMD ["cat", "message.txt"]

# Default to API service
FROM api