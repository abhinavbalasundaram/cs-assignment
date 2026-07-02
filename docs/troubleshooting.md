# Troubleshooting Scenario: MultiClusterIngress Endpoint Returned Empty Response

## Problem

After configuring MultiClusterIngress and testing the public endpoint, the application did not initially respond correctly. Curl requests to the public IP returned errors such as:

```bash
curl: (52) Empty reply from server
```

and sometimes:

```bash
curl: (56) Recv failure: Connection reset by peer
```

## Impact

The GKE workloads were running, and the backend services eventually showed as healthy, but the external customer-facing endpoint was not usable. This blocked validation of the assignment requirement for an accessible application endpoint.

## Investigation

I checked the MultiClusterIngress status and events using:

```bash
kubectl describe mci web-mci -n web
```

The first issue reported was:

```text
MCI web/web-mci is missing a default backend
```

After adding a default backend, I checked the global forwarding rules:

```bash
gcloud compute forwarding-rules list --global
```

At one point, no global forwarding rule was created. Looking again at the MultiClusterIngress events showed another issue:

```text
Error AVMBR102: MultiClusterService web/app-b-mcs not found.
```

I verified the MultiClusterService objects:

```bash
kubectl get mcs -n web
```

After ensuring both `app-a-mcs` and `app-b-mcs` existed, another error appeared:

```text
Invalid value for field 'resource.IPAddress': 'app-global-ip'. Must be a literal IP address or URL referencing an Address resource.
```

The MultiClusterIngress annotation was using the static IP resource name instead of the literal global IP address.

## Root Cause

There were three configuration issues during the first MultiClusterIngress setup:

1. The MultiClusterIngress was missing a required default backend.
2. The App B MultiClusterService was not available when the ingress tried to reconcile.
3. The static IP annotation used the reserved address name instead of the literal global IP address expected by the controller.

Additionally, after correcting the configuration, the Google Cloud load balancer required some time to finish reconciliation and become fully functional.

## Resolution

I resolved the issue by:

1. Adding a default backend to the MultiClusterIngress.
2. Verifying that both MultiClusterService resources existed.
3. Updating the `networking.gke.io/static-ip` annotation to use the literal global IP address.
4. Waiting for the MultiClusterIngress controller and Google Cloud load balancer resources to reconcile.
5. Rechecking the global forwarding rule and testing the public endpoint again.

After the load balancer finished provisioning, the public endpoint worked successfully.

## Validation

I validated the fix using:

```bash
kubectl describe mci web-mci -n web
gcloud compute forwarding-rules list --global
gcloud compute backend-services list --global
curl http://<GLOBAL_IP>/
curl http://<GLOBAL_IP>/app-a
curl http://<GLOBAL_IP>/app-b
```

The endpoint started responding correctly after the MultiClusterIngress and global load balancer finished reconciling.

## Lesson Learned

MultiClusterIngress depends on several resources being correct at the same time: the default backend, MultiClusterService objects, global static IP configuration, backend health, URL map, and forwarding rule. Even after the backend services are healthy, the global load balancer frontend may still need time to reconcile. Checking the MultiClusterIngress events and Google Cloud load balancer resources helped isolate the issue layer by layer.
