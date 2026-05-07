# syntax=docker/dockerfile:1.7

FROM golang:1.26.2 AS builder

WORKDIR /app

COPY go.mod ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -o go-app .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/go-app .

CMD ["/app/go-app"]