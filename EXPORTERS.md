## **PUD’s Prometheus Metrics & Exporters**

**Performance and Usage Diagnosis** (PUD) Enabler follows an HTTP pull model: It scrapes performance metrics from endpoints routinely. Typically the abstraction layer between the application and PUD is an **exporter**, which takes application-formatted metrics and converts them to Prometheus metrics for consumption. Because PUD uses an HTTP pull model, the exporter typically provides an endpoint `/metrics` where the performance metrics can be scraped. 

The relationship between Prometheus, the exporter, and the application in a Kubernetes environment can be visualized like this:

![alt text](https://trstringer.com/images/prometheus-exporter.png)

Metrics are served as plaintext. They are designed to be consumed either by PUD itself or by a scraper that is compatible with scraping a Prometheus client endpoint. The raw metrics can also be visualized in a browser by opening /metrics endpoint. Note that the metrics exposed on the `/metrics` endpoint reflect the current state of the application monitored.

The Prometheus metrics format is so widely adopted that it became an independent project: OpenMetrics, striving to make this metric format specification an industry standard.

### Prometheus metrics naming

Generally metric names should allow someone who is familiar with Prometheus but not a particular system to make a good guess as to what a metric means. A metric named http_requests_total is not extremely useful - are these being measured as they come in, in some filter or when they get to the user’s code? And requests_total is even worse, what type of requests?

Metric names for applications should generally be prefixed by the exporter name, e.g. haproxy_up.

Metrics must use base units (e.g. seconds, bytes) and leave converting them to something more readable to graphing tools. No matter what units you end up using, the units in the metric name must match the units in use.

Prometheus metrics and label names are written in snake_case.

Only [a-zA-Z0-9:_] are valid in metric names.

The _sum, _count, _bucket and _total suffixes are used by Summaries, Histograms and Counters. Unless you’re producing one of those, avoid these suffixes.

_total is a convention for counters, you should use it if you’re using the COUNTER type.

Prometheus metric format has a name combined with a series of labels or tags.

```
<metric name>{<label name>=<label value>, ...}
```

A time series with the metric name http_requests_total and the labels service="service", server="pod50″ and env="production" could be written like this:

```
http_requests_total{service="service", server="pod50", env="production"}
```

You can associate any number of context-specific labels to every metric you submit.

Imagine a typical metric like http_requests_per_second, every one of your web servers is emitting these metrics. You can then bundle the labels (or dimensions):

-	Web Server software (Nginx, Apache)
-	Environment (production, staging)
-	HTTP method (POST, GET)
-	Error code (404, 503) 
-	HTTP response code (number) 
-	Endpoint (/webapp1, /webapp2) 
-	Datacenter zone (east, west)

Prometheus metrics text-based format is line oriented. Lines are separated by a line feed character (n). The last line must end with a line feed character. Empty lines are ignored. A metric is composed by several fields:

-	Metric name
-	Any number of labels (can be 0), represented as a key-value array
-	Current metric value 
-	Optional metric timestamp

A Prometheus metric can be as simple as:

```
http_requests 2
```

Or, including all the mentioned components:

```
http_requests_total{method="post",code="400"}  3   1395066363000
```

Metric output is typically preceded with `# HELP` and `# TYPE` metadata lines.

The HELP string identifies the metric name and a brief description of it. The TYPE string identifies the type of metric. If there’s no TYPE before a metric, the metric is set to untyped. Everything else that starts with a # is parsed as a comment.

```
# HELP metric_name Description of the metric
# TYPE metric_name type
# Comment that's not parsed by prometheus
http_requests_total{method="post",code="400"}  3   1395066363000
```

### Prometheus metrics client libraries

The Prometheus project maintains 4 official Prometheus metrics libraries written in Go, Java / Scala, Python, and Ruby.

The Prometheus community has created many third-party libraries that you can use to instrument other languages (or just alternative implementations for the same language): 

-	Bash 
-	C++ 
-	Common Lisp 
-	Elixir 
-	Erlang 
-	Haskell 
-	Lua for Nginx
-	Lua for Tarantool 
-	.NET / C# 
-	Node.js 
-	Perl 
-	PHP 
-	Rust

### Prometheus metrics / OpenMetrics types

Depending on what kind of information you want to collect and expose, you’ll have to use a different metric type. Here are your four choices available on the OpenMetrics specification:

**Counter**

This represents a cumulative metric that only increases over time, like the number of requests to an endpoint. Note: instead of using Counter to instrument decreasing values, use Gauges.

```
# HELP go_memstats_alloc_bytes_total Total number of bytes allocated, even if freed.
# TYPE go_memstats_alloc_bytes_total counter
go_memstats_alloc_bytes_total 3.7156890216e+10
```

**Gauge**

Gauges are instantaneous measurements of a value. They can be arbitrary values which will be recorded. Gauges represent a random value that can increase and decrease randomly such as the load of your system.

```
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 73
```

**Histogram**

A histogram samples observations (usually things like request durations or response sizes) and counts them in configurable buckets. It also provides a sum of all observed values. A histogram with a base metric name of exposes multiple time series during a scrape:

```
# HELP http_request_duration_seconds request duration histogram
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.5"} 0
http_request_duration_seconds_bucket{le="1"} 1
http_request_duration_seconds_bucket{le="2"} 2
http_request_duration_seconds_bucket{le="3"} 3
http_request_duration_seconds_bucket{le="5"} 3
http_request_duration_seconds_bucket{le="+Inf"} 3
http_request_duration_seconds_sum 6
http_request_duration_seconds_count 3
```

**Summary**

Similar to a histogram, a summary samples observations (usually things like request durations and response sizes). While it also provides a total count of observations and a sum of all observed values, it calculates configurable quantiles over a sliding time window. A summary with a base metric name of also exposes multiple time series during a scrape:

```
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 3.291e-05
go_gc_duration_seconds{quantile="0.25"} 4.3849e-05
go_gc_duration_seconds{quantile="0.5"} 6.2452e-05
go_gc_duration_seconds{quantile="0.75"} 9.8154e-05
go_gc_duration_seconds{quantile="1"} 0.011689149
go_gc_duration_seconds_sum 3.451780079
go_gc_duration_seconds_count 13118
```

More regarding OpenMetrics types: https://prometheus.io/docs/concepts/metric_types/

### Prometheus exporters

Many popular server applications like Nginx or PostgreSQL are much older than the Prometheus metrics / OpenMetrics popularization. They usually have their own metrics formats and exposition methods. To work around this hurdle, the Prometheus community is creating and maintaining a vast collection of Prometheus exporters. An exporter is a “translator” or “adapter” program able to collect the server native metrics and re-publishing these metrics using the Prometheus metrics format and HTTP protocol transports. These small binaries can be co-located in the same container or pod executing the main server that is being monitored, or isolated in their own sidecar container and then you can collect the service metrics scraping the exporter that exposes and transforms them into Prometheus metrics.

There are a number of [exporters](https://prometheus.io/docs/instrumenting/exporters/) that are maintained as part of the official [Prometheus GitHub](https://github.com/prometheus).

You might need to write your own exporter if…

- You’re using 3rd party software that doesn’t have an existing exporter already

- You want to generate Prometheus metrics from software that you have written

### Example

Building a generic HTTP server metrics exporter in Python. By Nancy Chauhan: https://levelup.gitconnected.com/building-a-prometheus-exporter-8a4bbc3825f5
