# keycloak standalone
Helm chart to install a keycloak single node instance (v23.0.7) running in dev mode for testing.

## ⚠️ SECURITY WARNING

**DO NOT use default or hardcoded credentials in production environments!**

This chart requires you to provide secure credentials during installation. Never commit credentials to version control.

## Chart Values

| Value               | Description
|---------------------|---
| `hostname`          | The external hostname for admin-console.
| `adminUser`         | The initial admin username. **REQUIRED** - must be set during installation.
| `adminPassword`     | The initial admin password. **REQUIRED** - must be set during installation.

## Install

### Secure Installation (Recommended)

**Option 1: Using --set flags**
```bash
helm install keycloak keycloak-standalone -n keycloak --create-namespace \
  --set hostname=<ingress external ip> \
  --set adminUser=<your-admin-username> \
  --set adminPassword=<your-secure-password>
```

**Option 2: Using Kubernetes Secrets**
```bash
# Create secret first
kubectl create secret generic keycloak-admin-credentials \
  --from-literal=username=<your-admin-username> \
  --from-literal=password=<your-secure-password> \
  -n keycloak

# Install chart
helm install keycloak keycloak-standalone -n keycloak --create-namespace \
  --set hostname=<ingress external ip> \
  --set adminUser=<your-admin-username> \
  --set adminPassword=<your-secure-password>
```

**Option 3: Using a secure values file (NOT committed to git)**
```bash
# Create secure-values.yaml (add to .gitignore!)
cat > secure-values.yaml <<EOF
hostname: <ingress external ip>
adminUser: <your-admin-username>
adminPassword: <your-secure-password>
EOF

# Install
helm install keycloak keycloak-standalone -n keycloak --create-namespace -f secure-values.yaml
```

### Generate Secure Password

```bash
# Generate a strong random password
openssl rand -base64 32
```

Once all pods are up and ready, open the url http://<ingress external ip>/auth for Keycloak admin-console.

## Security Best Practices

- Use strong, randomly generated passwords
- Rotate credentials regularly (every 90 days minimum)
- Use external secret management (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault) for production
- Never commit credentials to version control
- See [../../SECURITY.md](../../SECURITY.md) for detailed security guidance

### Content Security Policy (CSP)

To protect against XSS attacks, configure Content-Security-Policy headers on the Keycloak ingress.

The ingress template (`templates/keycloak.yaml`) includes commented CSP annotations. To enable:

1. Edit `templates/keycloak.yaml`
2. Uncomment the CSP annotation under the Ingress metadata
3. Customize based on your Keycloak configuration

**Note**: Keycloak admin console requires relaxed CSP for proper functionality:
```yaml
nginx.ingress.kubernetes.io/configuration-snippet: |
  more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'self'";
  more_set_headers "X-Frame-Options: SAMEORIGIN";
  more_set_headers "X-Content-Type-Options: nosniff";
```

See [CSP Configuration Guide](../../docs/guides/CSP-Configuration.md) for more details.
