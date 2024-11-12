#!/bin/bash

__print_title() {
  printf "\033[32;1m❯ %s\033[0m%s (hit enter)" "${1}" "${@:2}"
}

__print_title "let's now crash the node on which Kyverno is running"
read -r
(set -x; podman stop kyverno-worker2; )
echo ""

__print_title "Mutating and Validating WebhookConfigurations are still installed in the cluster"
read -r 
( set -x; kubectl get mutatingwebhookconfigurations.admissionregistration.k8s.io; )
echo ""
( set -x; kubectl get validatingwebhookconfigurations.admissionregistration.k8s.io; )
echo ""

__print_title "if we now try to create a new pod, it will not be put in execution as Kyverno is not replying webhook callback"
read -r
(set -x; kubectl run my-app -n default --image bash:latest -- sleep infinity)
#+ kubectl run my-app -n default --image bash:latest -- sleep infinity
#❯ kubectl remove mutatingwebhookconfigurations.admissionregistration.k8s.io  -l webhook.kyverno.io/managed-by=kyverno
echo ""

__print_title "let's remediate by deleting kyverno's webhooks"
read -r
(set -x; kubectl delete mutatingwebhookconfigurations.admissionregistration.k8s.io -l webhook.kyverno.io/managed-by=kyverno )
echo ""
(set -x; kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io -l webhook.kyverno.io/managed-by=kyverno )
echo ""

__print_title "if we create a new pod now, it will run (policies will not be applied, but APIServer will be usable again)"
read -r
(set -x; kubectl run my-app -n default --image bash:latest -- sleep infinity)
