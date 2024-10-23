# IDP integration

Private Spatial API is able to integrate with IDPs that support OpenID Connect without Keycloak installed. Spatial API will authenticate users based on the JWT token issued by the IDP. Keycloak is required only when you do not have an IDP, or you need resource ACL control or User federation (such as LDAP and Active Directory). 

## IDP OpenID Connect issuer url

An IDP issurer url is required to setup the integration. The login client could be either private or public. If it is private, a client secret is also required in the configuration.

## Configure Security

In your Helm chart values yaml file, add following section. If you use a private client, set the clientSecret, otherwise, set it to empty string.

```
security:
  enabled: "true"
  oauth2:
    issuerUri: "<IDP issurer url>"
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
curl --location 'https://<your issurer-url>/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=<your client id>' \
--data-urlencode 'username=<username>' \
--data-urlencode 'password=<password>'
```


Call Spatial API (list tables),
```
curl --location 'http://<host>:<port>/rest/Spatial/FeatureService/tables.json' \
--header 'Authorization: Bearer <your access token>'
```