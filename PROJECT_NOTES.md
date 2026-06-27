# Project Notes

## Assignment Summary

The assignment asks for a GCP project using Terraform to create infrastructure, deploy applications, and enable observability.

Expected deliverables include:

- Working GKE cluster/application endpoint
- Two GKE clusters
- Two web applications
- Multi-pod deployments
- Observability
- Grafana dashboard screenshot or export
- BigQuery queries for log analysis
- Troubleshooting scenario
- Architecture and setup documentation

## Current Approach

We are building the project step by step.

We will not finalize the full architecture upfront. Design decisions will be made as we reach each phase.

## Open Questions

- Should GKE be Standard or Autopilot?
- How should the two clusters be exposed?
- Should we use Ingress or LoadBalancer services?
- How much observability should be implemented in Grafana?
- Should Grafana use BigQuery only, Cloud Monitoring, or both?
- Should we create custom applications or use existing sample apps?
- What should be skipped as out of scope or not free-tier friendly?