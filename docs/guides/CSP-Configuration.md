# Content Security Policy (CSP) Configuration Guide

## Overview

Content-Security-Policy (CSP) is a critical HTTP security header that helps protect web applications from Cross-Site Scripting (XSS), clickjacking, and other code injection attacks. This guide explains how to configure CSP for Private Spatial APIs ingress resources.

## Security Vulnerability Context

**Finding**: Missing Content-Security-Policy header  
**Risk**: Cross-Site Scripting (XSS) attacks, code injection  
**OWASP**: A05:2021 – Security Misconfiguration, A07:2021 – Identification and Authentication Failures

## Implementation Options

### Option 1: Uncomment Pre-configured Examples (Recommended for Quick Start)

Each ingress template includes commented CSP annotations. To enable:

1. Navigate to the ingress template file (e.g., `charts/private-spatial-apis/charts/*/templates/ingress.yaml`)
2. Uncomment the `nginx.ingress.kubernetes.io/configuration-snippet` annotation
3. Customize the CSP directives as needed

**Example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: feature-service
  annotations:
    # Uncomment the following lines:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self'";
      more_set_headers "X-Frame-Options: SAMEORIGIN";
      more_set_headers "X-Content-Type-Options: nosniff";
      more_set_headers "X-XSS-Protection: 1; mode=block";
      more_set_headers "Referrer-Policy: strict-origin-when-cross-origin";
```

### Option 2: Apply via Helm Values (Production Recommended)

Create a custom values file to override ingress annotations:

**custom-security-values.yaml:**
```yaml
namedresource-service:
  ingress:
    annotations:
      nginx.ingress.kubernetes.io/configuration-snippet: |
        more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'";
        more_set_headers "X-Frame-Options: DENY";
        more_set_headers "X-Content-Type-Options: nosniff";

feature-service:
  ingress:
    annotations:
      nginx.ingress.kubernetes.io/configuration-snippet: |
        more_set_headers "Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'";
        more_set_headers "X-Frame-Options: DENY";
        more_set_headers "X-Content-Type-Options: nosniff";

# Repeat for other services...
```

Deploy with:
```bash
helm install spatial-apis ./charts/private-spatial-apis -f custom-security-values.yaml
```

### Option 3: Global Ingress Controller Configuration

For organization-wide policies, configure CSP at the Ingress Controller level:

```yaml
# nginx-ingress-controller ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-configuration
  namespace: ingress-nginx
data:
  add-headers: "ingress-nginx/custom-headers"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: custom-headers
  namespace: ingress-nginx
data:
  Content-Security-Policy: "default-src 'self'; script-src 'self'; object-src 'none'"
  X-Frame-Options: "SAMEORIGIN"
  X-Content-Type-Options: "nosniff"
  X-XSS-Protection: "1; mode=block"
```

## CSP Directive Explanation

### Provided Example Policy
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self'
```

| Directive | Value | Purpose |
|-----------|-------|---------|
| `default-src 'self'` | Only from same origin | Default policy for all resource types |
| `script-src 'self' 'unsafe-inline' 'unsafe-eval'` | Same origin + inline scripts | Allow JavaScript execution (relaxed for compatibility) |
| `style-src 'self' 'unsafe-inline'` | Same origin + inline styles | Allow CSS from same origin and inline styles |
| `img-src 'self' data: https:` | Same origin, data URIs, HTTPS | Allow images from secure sources |
| `font-src 'self' data:` | Same origin, data URIs | Allow web fonts |
| `connect-src 'self'` | Same origin only | Restrict AJAX/WebSocket connections |
| `frame-ancestors 'self'` | Only same origin can frame | Prevent clickjacking |
| `base-uri 'self'` | Same origin only | Restrict `<base>` tag URLs |
| `form-action 'self'` | Forms submit to same origin | Prevent form hijacking |

### Recommended Production Policy (Stricter)

For REST/SOAP APIs that don't serve HTML:
```
Content-Security-Policy: default-src 'none'; script-src 'none'; object-src 'none'; frame-ancestors 'none'
```

For APIs with web UI/documentation:
```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; object-src 'none'
```

## Common Issues and Troubleshooting

### Issue: Web UI not loading after enabling CSP

**Symptoms**: Blank pages, console errors like "Refused to load script"

**Solution**: Gradually relax CSP directives:
1. Start with report-only mode: `Content-Security-Policy-Report-Only`
2. Check browser console for violations
3. Add specific sources or use `'unsafe-inline'` if necessary

### Issue: Third-party integrations broken

**Symptoms**: External widgets, maps, or authentication not working

**Solution**: Add specific domains to CSP:
```
script-src 'self' https://trusted-cdn.example.com;
connect-src 'self' https://api.trusted-service.com;
```

### Issue: NGINX returns 500 error after adding annotations

**Symptoms**: Ingress not working, NGINX error logs

**Solution**: 
1. Ensure `nginx-ingress-controller` has `headers-more` module
2. Verify YAML syntax (especially multiline strings)
3. Check NGINX controller logs: `kubectl logs -n ingress-nginx <nginx-controller-pod>`

## Testing Your CSP Configuration

### Method 1: Browser Developer Tools
1. Open browser DevTools (F12)
2. Navigate to the Console tab
3. Look for CSP violation messages
4. Check Network tab for blocked resources

### Method 2: Report-Only Mode
Use `Content-Security-Policy-Report-Only` instead of `Content-Security-Policy` to test without blocking:

```yaml
nginx.ingress.kubernetes.io/configuration-snippet: |
  more_set_headers "Content-Security-Policy-Report-Only: default-src 'self'; script-src 'self'";
```

### Method 3: Online CSP Evaluator
Use tools like:
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [Mozilla Observatory](https://observatory.mozilla.org/)

## Security Best Practices

### 1. Avoid 'unsafe-inline' and 'unsafe-eval' in Production
These directives significantly weaken CSP protection. Instead:
- Use nonces or hashes for inline scripts
- Refactor code to avoid `eval()` and inline event handlers

### 2. Use Specific Sources Over Wildcards
❌ Bad: `script-src *` or `script-src https:`  
✅ Good: `script-src 'self' https://cdn.example.com`

### 3. Implement frame-ancestors
Prevent clickjacking:
```
frame-ancestors 'none'  # Cannot be framed at all
frame-ancestors 'self'  # Can only be framed by same origin
```

### 4. Set upgrade-insecure-requests
Force HTTP resources to HTTPS:
```
Content-Security-Policy: upgrade-insecure-requests; default-src 'self'
```

### 5. Enable CSP Reporting
Monitor violations in production:
```yaml
nginx.ingress.kubernetes.io/configuration-snippet: |
  more_set_headers "Content-Security-Policy: default-src 'self'; report-uri https://your-csp-report-collector.example.com/report";
```

## Service-Specific Recommendations

### Keycloak (Authentication UI)
Keycloak admin console requires relaxed CSP:
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:
```

### REST APIs (Feature, Mapping, Tiling Services)
APIs without HTML can use strict CSP:
```
Content-Security-Policy: default-src 'none'; frame-ancestors 'none'
```

### Spatial Server Manager (Web UI)
May require inline scripts for functionality:
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self'
```

## Compliance and Standards

CSP implementation helps meet:
- **OWASP Top 10 2021**: A05 (Security Misconfiguration), A03 (Injection)
- **PCI-DSS v4.0**: Requirement 6.4 (Secure Coding)
- **NIST 800-53**: SC-18 (Mobile Code)
- **SOC 2**: CC6.6 (Logical and Physical Access Controls)

## Additional Security Headers

The provided examples include these complementary headers:

| Header | Value | Purpose |
|--------|-------|---------|
| `X-Frame-Options` | `SAMEORIGIN` or `DENY` | Prevent clickjacking (legacy, CSP `frame-ancestors` is preferred) |
| `X-Content-Type-Options` | `nosniff` | Prevent MIME-type sniffing |
| `X-XSS-Protection` | `1; mode=block` | Enable browser XSS filter (legacy) |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Control referer header information |
| `Permissions-Policy` | `geolocation=(self), microphone=(), camera=()` | Control browser features |

## References

- [MDN: Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [CSP Level 3 Specification](https://www.w3.org/TR/CSP3/)
- [OWASP: Content Security Policy Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- [Google: CSP Best Practices](https://csp.withgoogle.com/docs/strict-csp.html)
- [NGINX Ingress Controller: Configuration Snippets](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#configuration-snippet)

## Support

For questions or issues with CSP configuration:
1. Review NGINX Ingress Controller logs
2. Test with `Content-Security-Policy-Report-Only` first
3. Use browser DevTools to identify violations
4. Consult the [SECURITY.md](../SECURITY.md) for general security guidance

---

**Last Updated**: January 6, 2026  
**Applies To**: Private Spatial APIs v1.x, NGINX Ingress Controller

