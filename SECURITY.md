# Security Guide - Credential Management

## Overview

This document provides guidance on secure credential management for Private Spatial APIs deployment. **NEVER use hardcoded credentials in production environments.**

## Vulnerability Remediation

This project has been updated to remove all hardcoded credentials following security audit findings. All credentials must now be provided externally using secure methods.

## Critical Security Issues Addressed

### 1. Hardcoded Credentials (CWE-798) - ✅ FIXED
- **Keycloak**: Removed hardcoded admin password
- **MongoDB**: Removed hardcoded root password  
- **OAuth2**: Removed hardcoded client secrets
- **Status**: All credentials now require external input

### 2. Missing Content-Security-Policy (OWASP A05:2021) - ✅ DOCUMENTED
- **Issue**: CSP headers missing from ingress configurations
- **Solution**: Commented examples added to all ingress templates
- **Documentation**: See [CSP Configuration Guide](docs/guides/CSP-Configuration.md)
- **Status**: Users must uncomment and configure based on requirements

## Content Security Policy (CSP) Configuration

To protect against Cross-Site Scripting (XSS) attacks, configure CSP headers on your ingress resources.

### Quick Implementation

Each ingress template includes commented CSP annotations:

```yaml
# In charts/*/templates/ingress.yaml
annotations:
  nginx.ingress.kubernetes.io/configuration-snippet: |
    more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none'";
    more_set_headers "X-Frame-Options: SAMEORIGIN";
    more_set_headers "X-Content-Type-Options: nosniff";
```

**Detailed Guide**: [CSP Configuration Guide](docs/guides/CSP-Configuration.md)

### Recommended CSP Policies by Service Type

| Service Type | Recommended CSP |
|--------------|----------------|
| REST/SOAP APIs | `default-src 'none'; frame-ancestors 'none'` |
| Web UIs | `default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:` |
| Keycloak | `default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:` |

## Compliance Checklist

- [ ] All hardcoded credentials removed from version control
- [ ] Secrets stored in external secret management system
- [ ] Pre-commit hooks installed to prevent credential commits
- [ ] Secret rotation policy documented and implemented
- [ ] Access to secrets restricted by RBAC
- [ ] Secrets encrypted at rest and in transit
- [ ] Audit logging enabled for secret access
- [ ] Regular security scans scheduled (e.g., GitGuardian, TruffleHog)

## Security Contacts

For security issues or questions, please contact your security team or follow your organization's security incident response procedures.

## References

- [CWE-798: Use of Hard-coded Credentials](https://cwe.mitre.org/data/definitions/798.html)
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [OWASP Content Security Policy Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- [Kubernetes Secrets Best Practices](https://kubernetes.io/docs/concepts/configuration/secret/)
- [12-Factor App - Config](https://12factor.net/config)
- [MDN: Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [CSP Configuration Guide](docs/guides/CSP-Configuration.md) (Project-specific)

```env
# OAuth2 Configuration
OAUTH2_CLIENT_SECRET=your-secure-client-secret

# Other variables
IMAGE_REGISTRY=your-registry
TAG=latest
SPATIAL_PATH=/path/to/data
```

**IMPORTANT**: Never commit `.env` files to version control!

## Secret Generation Best Practices

### Generate Strong Passwords

```bash
# Using OpenSSL (32 character random password)
openssl rand -base64 32

# Using pwgen
pwgen -s 32 1

# Using Python
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Generate OAuth2 Client Secrets

```bash
# Generate UUID-based secret
uuidgen

# Or use a cryptographically secure random string
openssl rand -hex 32
```

## Secret Rotation

### Recommended Rotation Schedule

- **Production**: Every 90 days minimum
- **Staging**: Every 180 days
- **Development**: Every 365 days or when compromised

### Rotation Process

1. Generate new credentials
2. Update secrets in secret management system
3. Restart affected services
4. Verify functionality
5. Revoke old credentials

## Pre-commit Hook Setup

Prevent credential commits by installing pre-commit hooks:

### Install detect-secrets

```bash
pip install detect-secrets
```

### Create .pre-commit-config.yaml

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
        exclude: package.lock.json
```

### Install the hook

```bash
pre-commit install
detect-secrets scan > .secrets.baseline
```

## .gitignore Configuration

Ensure the following patterns are in your `.gitignore`:

```
# Secret files
secure-values.yaml
*-secrets.yaml
*.secret
.env
.env.local

# Credential files
# Security Guide - Credential Management

## Overview

This document provides guidance on secure credential management for Private Spatial APIs deployment. **NEVER use hardcoded credentials in production environments.**

## Vulnerability Remediation

This project has been updated to remove all hardcoded credentials following security audit findings. All credentials must now be provided externally using secure methods.

## Critical Security Issues Addressed

### 1. Hardcoded Credentials (CWE-798) - ✅ FIXED
- **Keycloak**: Removed hardcoded admin password
- **MongoDB**: Removed hardcoded root password  
- **OAuth2**: Removed hardcoded client secrets
- **Status**: All credentials now require external input

### 2. Missing Content-Security-Policy (OWASP A05:2021) - ✅ DOCUMENTED
- **Issue**: CSP headers missing from ingress configurations
- **Solution**: Commented examples added to all ingress templates
- **Documentation**: See [CSP Configuration Guide](docs/guides/CSP-Configuration.md)
- **Status**: Users must uncomment and configure based on requirements

## Content Security Policy (CSP) Configuration

To protect against Cross-Site Scripting (XSS) attacks, configure CSP headers on your ingress resources.

### Quick Implementation

Each ingress template includes commented CSP annotations:

```yaml
# In charts/*/templates/ingress.yaml
annotations:
  nginx.ingress.kubernetes.io/configuration-snippet: |
    more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none'";
    more_set_headers "X-Frame-Options: SAMEORIGIN";
    more_set_headers "X-Content-Type-Options: nosniff";
```

**Detailed Guide**: [CSP Configuration Guide](docs/guides/CSP-Configuration.md)

### Recommended CSP Policies by Service Type

| Service Type | Recommended CSP |
|--------------|----------------|
| REST/SOAP APIs | `default-src 'none'; frame-ancestors 'none'` |
| Web UIs | `default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:` |
| Keycloak | `default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:` |

## Kubernetes Deployments (Helm Charts)

### Using Kubernetes Secrets (Recommended)

#### For Keycloak Admin Credentials

1. Create a Kubernetes Secret:
```bash
kubectl create secret generic keycloak-admin-credentials \
  --from-literal=username=<your-admin-username> \
  --from-literal=password=<your-secure-password> \
  --namespace=<your-namespace>
```

2. Install the Helm chart referencing the secret:
```bash
helm install keycloak ./charts/keycloak-standalone \
  --set adminUser=<your-admin-username> \
  --set adminPassword=<your-secure-password> \
  --namespace=<your-namespace>
```

#### For MongoDB Credentials

1. Create a Kubernetes Secret:
```bash
kubectl create secret generic mongo-credentials \
  --from-literal=username=<your-db-username> \
  --from-literal=password=<your-secure-password> \
  --namespace=<your-namespace>
```

2. Install the Helm chart:
```bash
helm install mongo ./charts/mongo-standalone \
  --set credentials.rootUsername=<your-db-username> \
  --set credentials.rootPassword=<your-secure-password> \
  --namespace=<your-namespace>
```

### Using Values Files (Secure)

Create a separate values file that is **NOT committed to version control**:

**secure-values.yaml** (add to .gitignore):
```yaml
# Keycloak
adminUser: "your-admin-username"
adminPassword: "your-secure-password"

# MongoDB
credentials:
  rootUsername: "your-db-username"
  rootPassword: "your-secure-password"
```

Deploy using:
```bash
helm install <release-name> <chart-path> -f secure-values.yaml
```

### Using External Secret Management (Production Recommended)

#### HashiCorp Vault Integration

1. Store secrets in Vault
2. Use External Secrets Operator or Vault Agent Injector
3. Reference secrets in Helm templates

Example with External Secrets Operator:
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: keycloak-credentials
spec:
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: keycloak-admin-credentials
  data:
  - secretKey: username
    remoteRef:
      key: secret/keycloak
      property: username
  - secretKey: password
    remoteRef:
      key: secret/keycloak
      property: password
```

#### AWS Secrets Manager

```bash
# Store secret
aws secretsmanager create-secret \
  --name spatial-apis/keycloak/admin \
  --secret-string '{"username":"admin","password":"secure-password"}'

# Use AWS Secrets and Configuration Provider (ASCP)
```

#### Azure Key Vault

```bash
# Store secret
az keyvault secret set \
  --vault-name <vault-name> \
  --name keycloak-admin-password \
  --value <secure-password>

# Use Azure Key Vault Provider for Secrets Store CSI Driver
```

#### Google Secret Manager

```bash
# Store secret
gcloud secrets create keycloak-admin-password \
  --data-file=- <<< "your-secure-password"

# Use Workload Identity and Secret Manager CSI
```

## Docker Compose Deployments

### Environment Variables (Required)

For docker-compose deployments, **you must set environment variables** before starting services:

#### Windows (PowerShell):
```powershell
$env:OAUTH2_CLIENT_SECRET = "your-secure-client-secret"
docker-compose up -d
```

#### Windows (Command Prompt):
```cmd
set OAUTH2_CLIENT_SECRET=your-secure-client-secret
docker-compose up -d
```

#### Linux/macOS:
```bash
export OAUTH2_CLIENT_SECRET="your-secure-client-secret"
docker-compose up -d
```

### Using .env File (NOT for production)

Create a `.env` file in the `docker-desktop/` directory (**add to .gitignore**):
```env
# OAuth2 Configuration
OAUTH2_CLIENT_SECRET=your-secure-client-secret

# Other variables
IMAGE_REGISTRY=your-registry
TAG=latest
SPATIAL_PATH=/path/to/data
```
