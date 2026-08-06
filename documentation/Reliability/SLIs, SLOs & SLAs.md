# 🚧 Work in Progress

## SLIs (Measurements)

* Availibility
  - Http Requests Total (`sum(rate(http_requests_total[5m]))`)
  - Error Counts (`sum(rate(http_requests_total{status=~"5.."}[5m]))`)
  - Success Ratio (`rate(http_successes[5m] / rate(http_total[5m])`)
  - API Availability (5m) (`avg_over_time(probe_success{endpoint="/health"}[5m])`)

* Latency
  - Response Latency (use histograms)
  - p95 latancy (`histogram_quantile(0.95,rate(http_request_duration_seconds_bucket[5m]))`
  - p99 latancy (`histogram_quantile(0.99,rate(http_request_duration_seconds_bucket[5m]))`
  - Outliers (`count_over_time(http_request_duration_seconds{le="1"}[5m]) < count_over_time(http_request_total[5m])`)

* Errors
  - http_errors / http_total
  - Error Rates (`sum(rate(http_request_errors_total[5m])) / sum(rate(http_requests_total[5m]))`)
  - Request Success Rate

* Throughput
  - Requests per Second (`sum(rate(http_requests_total[5m]))`)
  - rate(request counter metric)

* Saturation - Golden Signals 
  - CPU utilization stays below 80% during peak hours
  cpu_usage / cpu_limit

## SLOs (Internal Targets)

* 99.9% of API requests should succeed (web, voting-svc, emoji-svc)
* 99% of requests should complete within 300ms
 - Why? Research shows users get impatient after 300ms
* 99.9% of votes should process successfully
* 95% of votes should process within 2 seconds
 - Why? Research shows customer satisfaction drops after that point


## SLAs (External Promises)

* 99.9% Uptime