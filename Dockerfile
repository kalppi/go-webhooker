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

# ============ Frontend Service ============
FROM node:22-alpine AS builder-frontend-ui

WORKDIR /app

COPY services/frontend/ui/package*.json ./services/frontend/ui/
RUN --mount=type=cache,target=/root/.npm \
    npm --prefix services/frontend/ui install

COPY services/frontend/ui ./services/frontend/ui

RUN npm --prefix services/frontend/ui run build

FROM golang:1.26.2 AS builder-frontend

WORKDIR /app

COPY go.mod ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

COPY --from=builder-frontend-ui /app/services/frontend/ui/dist ./services/frontend/ui/dist

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -o frontend-app ./services/frontend

FROM alpine:latest AS frontend

WORKDIR /app

COPY --from=builder-frontend /app/frontend-app .
COPY --from=builder-frontend /app/services/frontend/ui/dist ./ui/dist

CMD ["/app/frontend-app"]

# Default to API service
FROM api