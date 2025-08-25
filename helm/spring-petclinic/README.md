# Spring PetClinic Helm Chart

This Helm chart deploys the Spring PetClinic application with a PostgreSQL database on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- kubectl configured to communicate with your cluster
- Docker registry access (if using private images)

## Installation

### Add the Helm repository (if applicable)
```bash
helm repo add spring-petclinic https://your-repo-url
helm repo update
```

### Install the chart
```bash
# Install with default values
helm install my-petclinic ./helm/spring-petclinic

# Install with custom values
helm install my-petclinic ./helm/spring-petclinic -f values-custom.yaml

# Install in a specific namespace
helm install my-petclinic ./helm/spring-petclinic --namespace petclinic --create-namespace
```

## Configuration

The following table lists the configurable parameters of the Spring PetClinic chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `petclinic.enabled` | Enable PetClinic application deployment | `true` |
| `petclinic.image.repository` | PetClinic image repository | `539825459983.dkr.ecr.us-east-1.amazonaws.com/pet-clinic` |
| `petclinic.image.tag` | PetClinic image tag | `latest` |
| `petclinic.image.pullPolicy` | PetClinic image pull policy | `IfNotPresent` |
| `petclinic.replicaCount` | Number of PetClinic replicas | `1` |
| `petclinic.service.type` | PetClinic service type | `LoadBalancer` |
| `petclinic.service.port` | PetClinic service port | `80` |
| `petclinic.service.targetPort` | PetClinic service target port | `8080` |
| `petclinic.resources.limits.cpu` | CPU limit for PetClinic | `500m` |
| `petclinic.resources.limits.memory` | Memory limit for PetClinic | `512Mi` |
| `petclinic.resources.requests.cpu` | CPU request for PetClinic | `250m` |
| `petclinic.resources.requests.memory` | Memory request for PetClinic | `256Mi` |
| `database.enabled` | Enable PostgreSQL database deployment | `true` |
| `database.image.repository` | PostgreSQL image repository | `postgres` |
| `database.image.tag` | PostgreSQL image tag | `17.5` |
| `database.auth.username` | PostgreSQL username | `user` |
| `database.auth.password` | PostgreSQL password | `pass` |
| `database.auth.database` | PostgreSQL database name | `petclinic` |
| `database.persistence.enabled` | Enable PostgreSQL persistence | `true` |
| `database.persistence.size` | PostgreSQL PVC size | `8Gi` |
| `database.persistence.storageClass` | PostgreSQL storage class | `""` |
| `database.persistence.accessMode` | PostgreSQL access mode | `ReadWriteOnce` |

## Usage Examples

### Basic Installation
```bash
helm install my-petclinic ./helm/spring-petclinic
```

### Custom Image Tag
```bash
helm install my-petclinic ./helm/spring-petclinic \
  --set petclinic.image.tag=v1.0.0
```

### Custom Database Credentials
```bash
helm install my-petclinic ./helm/spring-petclinic \
  --set database.auth.username=petclinic_user \
  --set database.auth.password=secure_password \
  --set database.auth.database=petclinic_db
```

### Disable Database (Use External Database)
```bash
helm install my-petclinic ./helm/spring-petclinic \
  --set database.enabled=false
```

### Custom Resource Limits
```bash
helm install my-petclinic ./helm/spring-petclinic \
  --set petclinic.resources.limits.cpu=1000m \
  --set petclinic.resources.limits.memory=1Gi \
  --set petclinic.resources.requests.cpu=500m \
  --set petclinic.resources.requests.memory=512Mi
```

## Upgrading

```bash
# Upgrade with new values
helm upgrade my-petclinic ./helm/spring-petclinic -f values-custom.yaml

# Upgrade with specific values
helm upgrade my-petclinic ./helm/spring-petclinic \
  --set petclinic.image.tag=v1.0.1
```

## Uninstalling

```bash
helm uninstall my-petclinic
```

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app.kubernetes.io/name=spring-petclinic-app
```

### View Application Logs
```bash
kubectl logs -l app.kubernetes.io/name=spring-petclinic-app
```

### View Database Logs
```bash
kubectl logs -l app.kubernetes.io/name=spring-petclinic-db
```

### Check Services
```bash
kubectl get svc -l app.kubernetes.io/name=spring-petclinic
```

### Port Forward to Application
```bash
kubectl port-forward svc/my-petclinic-app 8080:80
```

## Architecture

The chart deploys the following components:

1. **PetClinic Application**: Spring Boot application with health checks
2. **PostgreSQL Database**: Persistent database with service binding
3. **Services**: LoadBalancer for app, ClusterIP for database
4. **Secrets**: Database credentials and service binding information
5. **PersistentVolumeClaim**: For database data persistence

## Service Binding

The application uses Kubernetes service binding to connect to the PostgreSQL database. The database credentials are automatically mounted to `/bindings/secret` in the application container.

## Health Checks

- **Liveness Probe**: `/livez` endpoint
- **Readiness Probe**: `/readyz` endpoint
- **Database Probes**: TCP socket checks on port 5432 