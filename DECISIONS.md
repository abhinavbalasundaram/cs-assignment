# Design Decisions

This file records decisions made during the project and the reasoning behind them.

## Decision Log

### 001 - Build incrementally instead of finalizing full scope upfront

Decision:
We will build the project step by step and make design decisions when we reach each phase.

Reason:
Some areas, especially observability and traffic routing, need exploration before deciding the exact implementation. This avoids overengineering and helps keep the project explainable for the interview.

### 002 - Use local Terraform state for the initial assignment implementation

Decision:
Use local Terraform state during the initial implementation.

Reason:
This is a personal take-home assignment and the project is being developed by one person. Local state avoids adding backend bootstrap complexity. In a team or production setup, the Terraform state should be stored remotely in a GCS bucket with appropriate IAM controls.

### 003 - Do not use Shared VPC

Decision:
Do not use Shared VPC for this assignment. The project will use a VPC created directly inside the same GCP project.

Reason:
Shared VPC is useful in larger organizations where a central networking team owns a host project and application teams deploy resources into separate service projects. For this take-home assignment, we are using a single GCP project, so Shared VPC would add unnecessary complexity without improving the required deliverables.

### 004 - Use GKE Standard clusters

Decision:
Use GKE Standard instead of GKE Autopilot.

Reason:
The assignment discusses node pools, cluster architecture, and operational design. GKE Standard provides more direct control and visibility over node pools, networking, and cluster configuration, which makes the implementation easier.

### 005 - Use zonal GKE clusters to control node count and cost

Decision:
Use zonal GKE clusters instead of regional GKE clusters.

Reason:
In regional GKE clusters, node count is applied per zone. A node pool with `node_count = 1` can create one node in each zone, resulting in three nodes per cluster in a typical region. For this take-home assignment, one node per cluster is sufficient to demonstrate the required architecture while keeping cost low.