# IDP integration

The Private Spatial APIs are now able to integrate with IDPs that support OpenID Connect without Keycloak installed. The Spatial APIs will authenticate users based on the JWT token issued by the IDP. Access to Private Spatial APIs endpoints can be configured to allow only users with specific roles if needed. Note that Keycloak will be required in cases where you do not have an IDP, where you need more granular ACL control on specific named resources (tables, layers, maps) or where user federation (such as LDAP and Active Directory) is needed.

## IDP OpenID Connect issuer url

An IDP issuer url is required to setup the integration. The login client could be either private or public. If it is private, a client secret is also required in the configuration.

## Configure Security

In your Helm chart values yaml file, add following section. If you use a private client, set the clientSecret, otherwise, set it to empty string.

```
security:
  enabled: "true"
  oauth2:
    issuerUri: "<IDP issuer url>"
    clientId: "<client id>"
    clientSecret: ""
    usernameAttribute: "preferred_username"
    userroleAttribute: ""
    requiredAuthority: ""
```

Optional configuration for additional role based authentication.
* ``usernameAttribute``: the claim in the JWT token as Username. For example, "preferred_username".
* ``userroleAttribute``: the claim in the JWT token as Role. For example, "resource_access.OIDC-Connect.roles.group"
* ``requiredAuthority``: define a role (value retrieved from userroleAttribute) that only users with this role are allowed to access the spatial endpoints. For example, "spatial".

Deploy the charts with the values yaml file

```
helm install spatial ~/charts/private-spatial-apis -f your-values.yaml
```

Or generate Kubernetes manifest file and use kubectl to deploy

```
helm template ~/charts/private-spatial-apis -f your-values.yaml > spatial-deployment.yaml
```

```
kubectl apply -f spatial-deployment.yaml -n <your-namespace>
```

## Call Spatial API endpoints with JWT token

You need to get JWT token from your IDP and include the JWT access token as Bearer token in http header to call Spatial API endpoints.

Get token
```
curl --location 'https://<your issuer url>/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=<your client id>' \
--data-urlencode 'username=<username>' \
--data-urlencode 'password=<password>'
```
> NOTE: add --data-urlencode 'client_secret=<your client secret>' to the curl cmd if you use a private client

Call Spatial API (list tables),
```
curl --location 'http://<host>:<port>/rest/Spatial/FeatureService/tables.json' \
--header 'Authorization: Bearer <your access token>'
```