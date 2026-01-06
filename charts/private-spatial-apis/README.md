# Private Spatial APIs
This Helm chart is an umbrella Helm chart for installing as many of the services as possible at once.

The following Kubernetes objects are created:

* feature-service
* mapping-service
* namedresource-service
* spatialmanager-service
* tiling-service

## Pre-requisites
A MongoDB (Replica Set) is required to persist named resources. 
MongoDB is configured with this Helm variables:

| Value                                  | Description                 |
|----------------------------------------|-----------------------------|
| `repository.mongodb.url`               | A connection string         |

More details on Private Spatial APIs usage can be found [here](https://help.precisely.com/r/Precisely-Data-Integrity-Suite/Latest/en-US/Private-Spatial-APIs-Guide/Services/REST-Services).

## Security Configuration

### Content Security Policy (CSP) Headers

**Important**: To protect against Cross-Site Scripting (XSS) and code injection attacks, it is strongly recommended to configure Content-Security-Policy headers on all ingress resources.

Each service's ingress template includes commented CSP annotation examples. To enable:

1. **Edit the ingress template** (e.g., `charts/private-spatial-apis/charts/feature-service/templates/ingress.yaml`)
2. **Uncomment the CSP annotation** in the metadata section
3. **Customize the CSP directives** based on your security requirements

**Example:**
```yaml
metadata:
  name: feature-service
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none'";
      more_set_headers "X-Frame-Options: SAMEORIGIN";
      more_set_headers "X-Content-Type-Options: nosniff";
```

**Comprehensive Guide**: See [CSP Configuration Guide](../../docs/guides/CSP-Configuration.md) for:
- Detailed CSP directive explanations
- Service-specific recommendations
- Production best practices
- Testing and troubleshooting

**Quick Reference - Recommended Policies:**

- **REST/SOAP APIs** (feature, mapping, tiling, namedresource):
  ```
  Content-Security-Policy: default-src 'none'; frame-ancestors 'none'
  ```

- **Web UIs** (spatialmanager-service):
  ```
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self'; frame-ancestors 'self'
  ```

For more information on security best practices, see [SECURITY.md](../../SECURITY.md).
