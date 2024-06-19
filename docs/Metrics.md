# Configurations for Metrics

## Generating Insights from Metrics

The Private-Spatial-APIs application microservices expose metrics which can be used for monitoring and troubleshooting the
performance and behavior of the Private-Spatial-APIs application.

Depending on your alerting setup, you can set up alerts based on these metrics to proactively respond to the issues in
your application.

### Exposed Metrics

Following are the metrics exposed by Feature-Service Application:

> click the `▶` symbol to expand

<details>

| Metric Name                      | Type    | Description                                                                                      |
|----------------------------------|---------|--------------------------------------------------------------------------------------------------|
| application.ready.time           | Gauge   | Time taken (ms) for the application to be ready to service requests.                                                          |
| application.started.time         | Gauge   | Time taken (ms) to start the application.                                                       |
| disk.free                        | Gauge   | Usable space for path.                                                         |
| disk.total                       | Gauge   | Total space for path.                                                      |
| executor.active                  | Gauge   | The approximate number of threads that are actively executing tasks.                                                      |
| jvm.gc.memory.allocated          | Counter | Incremented for an increase in the size of the (young) heap memory pool after one GC to before the next.                                                                 |
| executor.completed               | Counter | The approximate total number of tasks that have completed execution.                                                  |
| executor.pool.core               | Gauge   | The core number of threads for the pool.                                                          |
| executor.pool.max                | Gauge   | The maximum allowed number of threads in the pool.                                                   |
| executor.pool.size               | Gauge   | The current number of threads in the pool.                                                             |
| executor.queue.remaining         | Gauge   | The number of additional elements that this queue can ideally accept without blocking.                                                           |
| executor.queued                  | Gauge   | The approximate number of tasks that are queued for execution.                                                             |
| jdbc.connections.max             | Gauge   | Maximum number of active connections that can be allocated at the same time.                                                               |
| jdbc.connections.min             | Gauge   | Minimum number of idle connections in the pool.                                                              |
| jvm.buffer.count                 | Gauge   | An estimate of the number of buffers in the pool.                                                                        |
| jvm.buffer.memory.used           | Gauge   | An estimate of the memory that the Java virtual machine is using for this buffer pool.                                                                        |
| jvm.buffer.total.capacity        | Gauge   | An estimate of the total capacity of the buffers in this pool.                                            |
| jvm.classes.loaded               | Gauge   | The number of classes that are currently loaded in the Java virtual machine.                                                            |
| jvm.classes.unloaded             | Counter | The total number of classes unloaded since the Java virtual machine has started execution.                                                                       |
| jvm.gc.live.data.size            | Gauge   | Size of long-lived heap memory pool after reclamation.                                                                           |
| jvm.gc.max.data.size             | Gauge   | Max size of long-lived heap memory pool.                                                               |
| jvm.gc.memory.allocated          | Counter | Incremented for an increase in the size of the (young) heap memory pool after one GC to before the next.                                                                 |
| jvm.gc.memory.promoted           | Counter | Count of positive increases in the size of the old generation memory pool before GC to after GC.                                                                 | 
| jvm.gc.overhead                  | Gauge   | An approximation of the percent of CPU time used by GC activities over the last lookback period or since monitoring began, whichever is shorter, in the range [0..1].                                                                 |
| jvm.gc.pause                     | Summary | Time spent in GC pause.                                                                 | 
| jvm.gc.memory.allocated          | Counter | Incremented for an increase in the size of the (young) heap memory pool after one GC to before the next.                                                                 |
| jvm.memory.committed             | Gauge   | The amount of memory in bytes that is committed for the Java virtual machine to use.  
| jvm.memory.max                   | Gauge   | The maximum amount of memory in bytes that can be used for memory management.                                                                 | 
| jvm.memory.usage.after.gc        | Gauge   | The percentage of long-lived heap pool used after the last GC event, in the range [0..1].                                                                 | 
| jvm.memory.used                  | Gauge   |The amount of used memory.                                                                 | 
| jvm.threads.daemon               | Gauge   | The current number of live daemon threads.                                                                 | 
| jvm.threads.live                 | Gauge   | The current number of live threads including both daemon and non-daemon threads.                                                                 | 
| jvm.threads.peak                 | Gauge   | The peak live thread count since the Java virtual machine started or peak was reset.                                                                 | 
| jvm.threads.states               | Gauge   | The current number of threads.                                                                 | 
| logback.events                   | Counter | Number of events that made it to the logs.                                                                 | 
| mongodb.driver.pool.checkedout   | Gauge   | The count of connections that are currently in use.                                                                 | 
| mongodb.driver.pool.size         | Gauge   | The current size of the connection pool, including idle and and in-use members.                                                                 | 
| mongodb.driver.pool.waitqueuesize| Gauge   | The current size of the wait queue for a connection from the pool.                                                                 | 
| process.cpu.usage                | Gauge   | The "recent cpu usage" for the Java Virtual Machine process.                                                                 | 
| process.files.max                | Gauge   | The maximum file descriptor count.                                                                 | 
| process.files.open               | Gauge   | The open file descriptor count.                                                                 | 
| process.start.time               | Gauge   | Start time of the process since unix epoch.                                                                 | 
| process.uptime                   | Gauge   | The uptime of the Java virtual machine.                                                                 | 
| system.cpu.count                 | Gauge   | The number of processors available to the Java virtual machine.                                                                 | 
| system.cpu.usage                 | Gauge   | The "recent cpu usage" of the system the application is running in.                                                                 | 
| system.load.average.1m           | Gauge   | The sum of the number of runnable entities queued to available processors and the number of runnable entities running on the available processors averaged over a period of time.                                                                 | 
| http.server.requests.seconds.count| Counter | This metric represents the total number of HTTP requests your Spring Boot application received at a specific endpoint.                                                                 |
| http.server.requests.seconds.max  | Gauge   | This metric indicates the maximum request duration during a specific time window.                                                                 |
| http.server.requests.seconds.sum  | Summary | This metric provides the sum of request durations over a specific time period.                                                                 |
| mongodb.driver.commands.seconds.count| Counter | tracks the count of MongoDB driver commands executed by your application.                                                                 |
| mongodb.driver.commands.seconds.max  | Gauge   | Represents the maximum execution time for MongoDB driver commands.                                                                 |
| mongodb.driver.commands.seconds.sum  | Summary | Sum of execution times for MongoDB driver commands.                                                                 |
| spring.data.repository.invocations.seconds.count| Counter | Related to invocations of Spring Data repository methods.                                                                 |
| spring.data.repository.invocations.seconds.max| Gauge   | Maximum execution time for Spring Data repository invocations.                                                                 |
| spring.data.repository.invocations.seconds.sum| Summary | Sum of execution times for Spring Data repository invocations.                                                                 |

 


<hr>
</details>


[🔗 Return to `Table of Contents` 🔗](../README.md#miscellaneous)