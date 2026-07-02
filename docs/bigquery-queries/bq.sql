SELECT
  TIMESTAMP_TRUNC(timestamp, MINUTE) AS time,
  COUNTIF(httpRequest.status >= 500) AS error_count,
  COUNT(*) AS total_request_count,
  SAFE_DIVIDE(COUNTIF(httpRequest.status >= 500), COUNT(*)) * 100 AS error_rate_percent
FROM
  `PROJECT_ID.gke_logs.HTTP_REQUESTS_TABLE`
WHERE
  $__timeFilter(timestamp)
GROUP BY
  time
ORDER BY
  time;

SELECT
  TIMESTAMP_TRUNC(timestamp, MINUTE) AS time,
  APPROX_QUANTILES(
    CAST(REGEXP_EXTRACT(CAST(httpRequest.latency AS STRING), r'([0-9.]+)') AS FLOAT64),
    100
  )[OFFSET(50)] AS p50_latency_seconds,
  APPROX_QUANTILES(
    CAST(REGEXP_EXTRACT(CAST(httpRequest.latency AS STRING), r'([0-9.]+)') AS FLOAT64),
    100
  )[OFFSET(95)] AS p95_latency_seconds,
  APPROX_QUANTILES(
    CAST(REGEXP_EXTRACT(CAST(httpRequest.latency AS STRING), r'([0-9.]+)') AS FLOAT64),
    100
  )[OFFSET(99)] AS p99_latency_seconds
FROM
  `PROJECT_ID.gke_logs.HTTP_REQUESTS_TABLE`
WHERE
  $__timeFilter(timestamp)
  AND httpRequest.latency IS NOT NULL
GROUP BY
  time
ORDER BY
  time;
