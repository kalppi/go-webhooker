# go-webhooker

Multi-service Go project structure with support for multiple microservices.

## Project Structure

```
go-webhooker/
├── services/                 # Individual microservices
│   ├── api/                  # Backend API service (webhooks)
│   │   └── main.go
│   └── frontend/             # Frontend service (Go + React + TypeScript)
│
├── pkg/                      # Shared packages
│   └── (shared utilities, helpers, middleware)
│
├── terraform/                # Infrastructure as Code
│   ├── backend.tf
│   ├── main.tf
│   └── variables.tf
│
├── scripts/                  # Utility scripts
│   ├── deploy-local.sh
│   ├── deploy-server.sh
│   └── setup-git-hooks.sh
│
├── Dockerfile               # Multi-stage Dockerfile for all services
├── Makefile                 # Build and run commands
├── go.mod                   # Go module definition
└── README.md                # This file
```

## Services

### API Service (`services/api/`)

Backend API service handling webhooks and core business logic.

**Build:**
```bash
make build-api
# or
cd services/api && go build -o ../../go-api .
```

**Run locally:**
```bash
make run-api
# Runs on PORT 8080 by default
```

**Docker:**
```bash
make docker-api
# or
docker build --target api -t go-webhooker-api:latest .
```

### Frontend Service (`services/frontend/`)

Frontend service that serves a React + TypeScript single-page app.

- Go server: `services/frontend/main.go`
- React app source: `services/frontend/ui/src/`
- Built static assets: `services/frontend/ui/dist/`

**Build:**
```bash
make build-frontend
```

**Run locally:**
```bash
make run-frontend
# Uses PORT=3000 by default for local dev
```

**Docker:**
```bash
make docker-frontend
```

## Quick Start

### Local Development

1. **Install dependencies:**
   ```bash
   go mod download
   ```

2. **Build services:**
   ```bash
   make build
   ```

3. **Run API service:**
   ```bash
   make run-api
   ```

4. **Test:**
   ```bash
   make test
   ```

### Docker Development

**Build API image:**
```bash
docker build --target api -t go-webhooker-api:latest .
```

**Run API container:**
```bash
docker run -p 8080:8080 -e PORT=8080 go-webhooker-api:latest
```

## Environment Variables

- `PORT` - Port the service listens on (default: 8080)
- `FRONTEND_DIST_DIR` - Optional path to built frontend assets for frontend service

## Adding a New Service

1. Create a new directory under `services/`:
   ```bash
   mkdir services/myservice
   ```

2. Create `main.go` in the new service directory

3. Add build target to `Makefile`:
   ```makefile
   build-myservice:
       cd services/myservice && go build -o ../../go-myservice .
   ```

4. Add Docker stage to `Dockerfile`:
   ```dockerfile
   FROM golang:1.26.2 AS builder-myservice
   # ... build steps ...
   ```

## Deployment

See deployment scripts in `scripts/` directory:
- `deploy-local.sh` - Local development deployment
- `deploy-server.sh` - Production server deployment
- `setup-git-hooks.sh` - Git hooks setup

## Terraform

Infrastructure configuration is in the `terraform/` directory. Deploy with:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Testing

Run all tests:
```bash
make test
```

Run service-specific tests:
```bash
cd services/api && go test ./...
```
