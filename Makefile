.PHONY: help build build-api build-frontend clean test run-api run-frontend docker-api docker-frontend deploy-api deploy-frontend deploy-help

help:
	@echo "Go-Webhooker - Multi-service Makefile"
	@echo ""
	@echo "Build & Run:"
	@echo "  make build           - Build all services"
	@echo "  make build-api       - Build API service"
	@echo "  make build-frontend  - Build Frontend service (placeholder)"
	@echo "  make run-api         - Run API service locally"
	@echo "  make test            - Run all tests"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-api      - Build API Docker image"
	@echo "  make docker-frontend - Build Frontend Docker image"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy-help     - Show deployment options"
	@echo "  make deploy-api      - Deploy API service to remote"
	@echo "  make deploy-frontend - Deploy Frontend service to remote"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean           - Clean build artifacts"

build: build-api build-frontend
	@echo "✓ All services built successfully"

build-api:
	@echo "Building API service..."
	cd services/api && go build -o ../../go-api .

build-frontend:
	@echo "Building Frontend service..."
	@echo "⚠ Frontend service not yet implemented"

run-api: build-api
	@echo "Running API service..."
	PORT=8080 ./go-api

docker-api:
	docker build --target api -t go-webhooker-api:latest .

docker-frontend:
	docker build --target frontend -t go-webhooker-frontend:latest .

test:
	go test ./...

clean:
	rm -f go-api go-frontend
	find . -name "*.test" -delete

# ============ Deployment Targets ============

deploy-help:
	@echo "Deployment Options:"
	@echo ""
	@echo "Deploy API service (default port 8080):"
	@echo "  make deploy-api"
	@echo ""
	@echo "Deploy with custom port:"
	@echo "  APP_PORT=9000 make deploy-api"
	@echo ""
	@echo "Deploy to custom instance/zone:"
	@echo "  INSTANCE=my-instance ZONE=europe-north1-b make deploy-api"
	@echo ""
	@echo "Example - Deploy frontend to port 3000:"
	@echo "  SERVICE=frontend APP_PORT=3000 make deploy-frontend"
	@echo ""
	@echo "Environment variables:"
	@echo "  SERVICE              - Service name (default: api or frontend)"
	@echo "  APP_PORT             - External port (default: 8080)"
	@echo "  APP_INTERNAL_PORT    - Internal port (default: 8080)"
	@echo "  INSTANCE             - GCP instance name (default: terraform-instance)"
	@echo "  ZONE                 - GCP zone (default: europe-north1-a)"

deploy-api: build-api
	@echo "Deploying API service..."
	SERVICE=api ./scripts/deploy-local.sh

deploy-frontend: build-frontend
	@echo "Deploying Frontend service..."
	SERVICE=frontend ./scripts/deploy-local.sh
