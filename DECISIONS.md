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