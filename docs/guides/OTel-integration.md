# OTel integration

Private Spatial APIs are able to integrate with [OTel](https://opentelemetry.io/docs/) compatible observability framework. Private Spatial API services can export telemetry data such as traces, metrics, and log to OTel collectors.

## Enable OTel 

To enable services to export telemetry data, you need to have your collector url ready, e.g http://jaeger.spatial.svc.cluster.local:4317. Please reference to the specific collector document on installing and configuring a collector.

Helm chart deployment, add the jvm option property for each of the services (e.g. Feature) 
```
helm install ..... --set "jvm.opts.feature=-javaagent:/app/bin/opentelemetry-javaagent.jar -Dotel.service.name=feature -Dotel.exporter.otlp.endpoint=<collector url>"
```

Yaml file deployment, add the JAVA_TOOL_OPTIONS environment variable to each of the services (e.g. Feature)
```
          env:
            - name: JAVA_TOOL_OPTIONS
              value: "-javaagent:/app/bin/opentelemetry-javaagent.jar -Dotel.service.name=feature -Dotel.exporter.otlp.endpoint=<collector url>"

```

After restart the service, it will start to export telemetry data
