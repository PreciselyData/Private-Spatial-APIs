# keycloak standalone
Helm chart to install a keycloak single node instance (v23.0.7) running in dev mode for testing.

## Chart Values

| Value               | Description
|---------------------|---
| `hostname`          | The external hostname for admin-console.
| `adminUser`         | The initial admin username. **REQUIRED** - must be set during installation.
| `adminPassword`     | The initial admin password. **REQUIRED** - must be set during installation.

## Install

### Secure Installation (Recommended)

**Using --set flags**
```bash
helm install keycloak keycloak-standalone -n keycloak --create-namespace \
  --set hostname=<ingress external ip> \
  --set adminUser=<your-admin-username> \
  --set adminPassword=<your-secure-password>
```

Once all pods are up and ready, open the url http://<ingress external ip>/auth for Keycloak admin-console.
