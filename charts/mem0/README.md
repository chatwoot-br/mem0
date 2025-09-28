# Mem0 Helm Chart

This Helm chart deploys the Mem0 FastAPI REST API server on a Kubernetes cluster using the Helm package manager.

## Features

- 🚀 **FastAPI Server**: High-performance REST API with automatic OpenAPI documentation
- 🗄️ **PostgreSQL Integration**: Vector storage with pgvector extension support
- 🔗 **Neo4j Graph Database**: Knowledge graph capabilities for advanced memory relationships
- 🔐 **Security**: Network policies, RBAC, security contexts, and secret management
- 📈 **Scalability**: Horizontal Pod Autoscaler with intelligent scaling policies
- 🔍 **Observability**: Prometheus monitoring, health checks, and structured logging
- 🌍 **Multi-Environment**: Separate configurations for development, staging, and production
- 💾 **Persistence**: Configurable persistent storage for application data

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistence)
- Ingress controller (nginx recommended)
- cert-manager (for TLS certificates)

## Repository

```bash
# Add the Helm repository (if publishing to a repository)
helm repo add mem0 https://chatwoot-br.github.io/mem0/
helm repo update
```

## Installation

### Quick Start (Development)

```bash
# Clone the repository
git clone https://github.com/chatwoot-br/mem0.git
cd charts/mem0

# Install with development values
helm install mem0-dev . -f environments/dev-values.yaml -n mem0-dev --create-namespace
```

### Production Installation

```bash
# 1. Create namespace
kubectl create namespace mem0-prod

# 2. Create secrets (required for production)
kubectl create secret generic mem0-secrets \
  --from-literal=openai-api-key=\"your-openai-api-key\" \
  --from-literal=postgres-password=\"your-postgres-password\" \
  --from-literal=neo4j-password=\"your-neo4j-password\" \
  -n mem0-prod

# 3. Install with production values
helm install mem0-prod . -f environments/prod-values.yaml -n mem0-prod
```

## Configuration

### Basic Configuration

| Parameter          | Description             | Default                       |
| ------------------ | ----------------------- | ----------------------------- |
| `replicaCount`     | Number of replicas      | `1`                           |
| `image.registry`   | Container registry      | `ghcr.io`                     |
| `image.repository` | Image repository        | `chatwoot-br/mem0-api-server` |
| `image.tag`        | Image tag               | `latest`                      |
| `image.pullPolicy` | Image pull policy       | `IfNotPresent`                |
| `service.type`     | Kubernetes service type | `ClusterIP`                   |
| `service.port`     | Service port            | `8000`                        |

### Ingress Configuration

| Parameter               | Description        | Default      |
| ----------------------- | ------------------ | ------------ |
| `ingress.enabled`       | Enable ingress     | `false`      |
| `ingress.className`     | Ingress class name | `nginx`      |
| `ingress.hosts[0].host` | Hostname           | `mem0.local` |
| `ingress.tls`           | TLS configuration  | `[]`         |

### Resource Configuration

| Parameter                   | Description    | Default |
| --------------------------- | -------------- | ------- |
| `resources.limits.cpu`      | CPU limit      | `2000m` |
| `resources.limits.memory`   | Memory limit   | `2Gi`   |
| `resources.requests.cpu`    | CPU request    | `500m`  |
| `resources.requests.memory` | Memory request | `512Mi` |

### Autoscaling Configuration

| Parameter                                       | Description      | Default |
| ----------------------------------------------- | ---------------- | ------- |
| `autoscaling.enabled`                           | Enable HPA       | `false` |
| `autoscaling.minReplicas`                       | Minimum replicas | `1`     |
| `autoscaling.maxReplicas`                       | Maximum replicas | `10`    |
| `autoscaling.targetCPUUtilizationPercentage`    | CPU target       | `70`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Memory target    | `80`    |

### Database Configuration

#### PostgreSQL

| Parameter                    | Description                 | Default      |
| ---------------------------- | --------------------------- | ------------ |
| `postgresql.enabled`         | Enable PostgreSQL subchart | `true`       |
| `postgresql.auth.database`   | Database name               | `mem0`       |
| `postgresql.auth.username`   | Database username           | `mem0`       |
| `postgresql.auth.password`   | Database password           | `mem0`       |
| `config.postgresql.host`     | External PostgreSQL host    | `postgresql` |
| `config.postgresql.port`     | PostgreSQL port             | `5432`       |

#### Neo4j

| Parameter               | Description           | Default             |
| ----------------------- | --------------------- | ------------------- |
| `neo4j.enabled`         | Enable Neo4j subchart | `true`              |
| `neo4j.neo4j.password`  | Neo4j password        | `mem0graph`         |
| `config.neo4j.uri`      | Neo4j connection URI  | `bolt://neo4j:7687` |
| `config.neo4j.username` | Neo4j username        | `neo4j`             |

### Security Configuration

| Parameter                      | Description             | Default |
| ------------------------------ | ----------------------- | ------- |
| `networkPolicy.enabled`        | Enable network policies | `false` |
| `podDisruptionBudget.enabled`  | Enable PDB              | `false` |
| `serviceAccount.create`        | Create service account  | `true`  |
| `securityContext.runAsNonRoot` | Run as non-root         | `true`  |
| `securityContext.runAsUser`    | User ID                 | `1000`  |

### Monitoring Configuration

| Parameter                 | Description                  | Default    |
| ------------------------- | ---------------------------- | ---------- |
| `serviceMonitor.enabled`  | Enable Prometheus monitoring | `false`    |
| `serviceMonitor.interval` | Scrape interval              | `30s`      |
| `serviceMonitor.path`     | Metrics path                 | `/metrics` |

### Secrets Configuration

| Parameter                              | Description                           | Default               |
| -------------------------------------- | ------------------------------------- | --------------------- |
| `secrets.openaiApiKey`                 | OpenAI API key (direct)               | `""`                  |
| `secrets.postgresqlPassword`           | PostgreSQL password (direct)          | `""`                  |
| `secrets.neo4jPassword`                | Neo4j password (direct)               | `""`                  |
| `secrets.existingSecret`               | Name of existing secret               | `""`                  |
| `secrets.existingSecretKeys.openaiApiKey` | Key name for OpenAI API key       | `"OPENAI_API_KEY"`    |
| `secrets.existingSecretKeys.postgresqlPassword` | Key name for PostgreSQL password | `"POSTGRES_PASSWORD"` |
| `secrets.existingSecretKeys.neo4jPassword` | Key name for Neo4j password     | `"NEO4J_PASSWORD"`    |

## Environment-Specific Deployments

### Development Environment

```bash
# Deploy to development
helm install mem0-dev . \
  -f environments/dev-values.yaml \
  -n mem0-dev \
  --create-namespace

# Features:
# - Single replica
# - Minimal resources
# - No TLS
# - Embedded databases
# - No network policies
```

### Staging Environment

```bash
# Deploy to staging
helm install mem0-staging . \
  -f environments/staging-values.yaml \
  -n mem0-staging \
  --create-namespace \
  --set secrets.openaiApiKey=\"your-api-key\"

# Features:
# - 2-5 replicas with HPA
# - Moderate resources
# - TLS with staging certificates
# - Basic security policies
# - Monitoring enabled
```

### Production Environment

```bash
# Deploy to production
helm install mem0-prod . \
  -f environments/prod-values.yaml \
  -n mem0-prod \
  --create-namespace

# Features:
# - 3-20 replicas with HPA
# - High resources
# - Production TLS
# - Full security policies
# - External databases
# - Complete monitoring
```

## Secrets Management

The chart automatically uses secrets created by the dependency charts (PostgreSQL and Neo4j) when enabled, and supports custom secret management for the Mem0 application.

### Automatic Secret Integration
When `postgresql.enabled=true` or `neo4j.enabled=true`, the chart automatically:
- Uses secrets created by the PostgreSQL Bitnami chart (`<release>-postgresql`)
- Uses secrets created by the Neo4j chart (`<release>-neo4j-auth`)
- References the standard password keys (`password` for PostgreSQL, `neo4j-password` for Neo4j)

### Custom Secret Management (Production)
For the Mem0 application secrets (OpenAI API key), you can:

**Option 1: Direct values (Development)**
```yaml
secrets:
  openaiApiKey: "sk-your-openai-key"
```

**Option 2: Existing secret (Production)**
```yaml
secrets:
  existingSecret: "mem0-production-secrets"
  existingSecretKeys:
    openaiApiKey: "openai-api-key"
```

### Creating External Secrets

#### Using kubectl

**For Mem0 application secrets only:**
```bash
# Custom key format (recommended for production)
kubectl create secret generic mem0-production-secrets \
  --from-literal=openai-api-key="sk-..." \
  -n mem0-prod

# Default key format
kubectl create secret generic mem0-secrets \
  --from-literal=OPENAI_API_KEY="sk-..." \
  -n mem0-prod
```

**Note**: Database secrets are automatically created by the PostgreSQL and Neo4j charts when enabled. No manual secret creation needed for database credentials.

#### Using External Secrets Operator
```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  namespace: mem0-prod
spec:
  provider:
    vault:
      server: "https://vault.example.com"
      path: "secret"
      version: "v2"
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: mem0-secrets
  namespace: mem0-prod
spec:
  refreshInterval: 60s
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: mem0-secrets
    creationPolicy: Owner
  data:
  - secretKey: openai-api-key
    remoteRef:
      key: mem0/openai
      property: api-key
```

## Health Checks and Monitoring

### Health Check Endpoints
- **Health**: `GET /health` - Basic health status
- **API Docs**: `GET /docs` - OpenAPI documentation
- **Metrics**: `GET /metrics` - Prometheus metrics (if enabled)

### Testing the Deployment
```bash
# Run Helm tests
helm test mem0-dev -n mem0-dev

# Check pod status
kubectl get pods -n mem0-dev -l app.kubernetes.io/name=mem0

# Check logs
kubectl logs -n mem0-dev -l app.kubernetes.io/name=mem0 -f

# Port forward to test locally
kubectl port-forward -n mem0-dev svc/mem0-dev 8000:8000
curl http://localhost:8000/health
```

## Upgrades

### Rolling Updates
```bash
# Update image tag
helm upgrade mem0-prod . \
  -f environments/prod-values.yaml \
  --set image.tag=v1.1.0 \
  -n mem0-prod

# Check rollout status
kubectl rollout status deployment/mem0-prod -n mem0-prod
```

### Database Migrations
For database schema changes, use init containers or jobs:

```yaml
# Custom migration job
apiVersion: batch/v1
kind: Job
metadata:
  name: mem0-migration
spec:
  template:
    spec:
      containers:
      - name: migrate
        image: ghcr.io/chatwoot-br/mem0-api-server:v1.1.0
        command: ["python", "migrate.py"]
        envFrom:
        - configMapRef:
            name: mem0-config
        - secretRef:
            name: mem0-secrets
      restartPolicy: Never
```

## Troubleshooting

### Common Issues

#### Pod Startup Issues
```bash
# Check pod events
kubectl describe pod <pod-name> -n <namespace>

# Check init container logs
kubectl logs <pod-name> -c wait-for-postgresql -n <namespace>
kubectl logs <pod-name> -c wait-for-neo4j -n <namespace>
```

#### Database Connection Issues
```bash
# Test PostgreSQL connection
kubectl run pg-test --rm -i --tty --image postgres:15 -- \
  pg_isready -h mem0-postgresql -p 5432 -U mem0

# Test Neo4j connection
kubectl run neo4j-test --rm -i --tty --image neo4j:5.0 -- \
  cypher-shell -a bolt://mem0-neo4j:7687 -u neo4j -p mem0graph "RETURN 1"
```

#### Ingress Issues
```bash
# Check ingress status
kubectl get ingress -n <namespace>
kubectl describe ingress mem0 -n <namespace>

# Check TLS certificates
kubectl get certificates -n <namespace>
kubectl describe certificate mem0-tls -n <namespace>
```

### Debugging Commands
```bash
# Get all resources
kubectl get all -n <namespace> -l app.kubernetes.io/name=mem0

# Check resource usage
kubectl top pods -n <namespace> -l app.kubernetes.io/name=mem0

# Check HPA status
kubectl get hpa -n <namespace>
kubectl describe hpa mem0 -n <namespace>
```

## Uninstallation

```bash
# Uninstall the release
helm uninstall mem0-dev -n mem0-dev

# Remove PVCs (if needed)
kubectl delete pvc -n mem0-dev -l app.kubernetes.io/name=mem0

# Remove namespace
kubectl delete namespace mem0-dev
```

## Security Considerations

### Production Security Checklist
- [ ] Use external secret management (Vault, AWS Secrets Manager, etc.)
- [ ] Enable network policies
- [ ] Configure pod security contexts
- [ ] Use specific image tags (not `latest`)
- [ ] Enable TLS for all communications
- [ ] Set up RBAC with minimal permissions
- [ ] Configure resource limits
- [ ] Enable audit logging
- [ ] Scan images for vulnerabilities
- [ ] Use private container registry

### Network Security
- Network policies restrict pod-to-pod communication
- Ingress TLS termination with valid certificates
- Service mesh integration (optional)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and test
4. Submit a pull request

## Support

- **Documentation**: [https://docs.mem0.ai](https://docs.mem0.ai)
- **Issues**: [GitHub Issues](https://github.com/chatwoot-br/mem0/issues)
- **Discord**: [Mem0 Community](https://discord.gg/mem0)

## License

This chart is licensed under the Apache 2.0 License. See [LICENSE](../../LICENSE) for details."