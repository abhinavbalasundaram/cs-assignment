SELECT
  timestamp,
  httpRequest.requestMethod AS method,
  httpRequest.requestUrl AS url,
  httpRequest.status AS status,
  httpRequest.latency AS latency,
  resource.labels.backend_service_name AS backend_service
FROM
  `PROJECT_ID.gke_logs.HTTP_LOAD_BALANCER_TABLE`
ORDER BY
  timestamp DESC
LIMIT 50;

SELECT
  REGEXP_EXTRACT(httpRequest.requestUrl, r'http://[^/]+(/[^?]*)') AS path,
  COUNT(*) AS request_count
FROM
  `PROJECT_ID.gke_logs.HTTP_LOAD_BALANCER_TABLE`
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY
  path
ORDER BY
  request_count DESC;

SELECT
  timestamp,
  resource.labels.cluster_name AS cluster_name,
  resource.labels.namespace_name AS namespace_name,
  resource.labels.pod_name AS pod_name,
  resource.labels.container_name AS container_name,
  textPayload
FROM
  `PROJECT_ID.gke_logs.K8S_CONTAINER_TABLE`
WHERE
  resource.labels.namespace_name = "web"
ORDER BY
  timestamp DESC
LIMIT 50;