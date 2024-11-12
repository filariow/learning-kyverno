#!/bin/bash

set -e

__print_title() {
  printf "\033[32;1m❯ %s\033[0m%s (hit enter)" "${1}" "${@:2}"
}

# show kyverno webhooks
__print_title "let's see which Mutating and Validating WebhookConfigurations are installed in the cluster"
read -r 
( set -x; kubectl get mutatingwebhookconfigurations.admissionregistration.k8s.io; )
echo ""
( set -x; kubectl get validatingwebhookconfigurations.admissionregistration.k8s.io; )
echo ""

# apply a mutate clusterpolicy
__print_title "let's now add a mutate cluster policy"
read -r 

( set -x; kubectl apply -f https://raw.githubusercontent.com/kyverno/policies/main/other/add-labels/add-labels.yaml -o yaml; )
echo ""
( set -x; kubectl get clusterpolicies.kyverno.io; )
echo ""

# retrieve the mutating webhook
__print_title "let's see how mutating webhook changed"
read -r
( set -x; kubectl get mutatingwebhookconfigurations.admissionregistration.k8s.io kyverno-resource-mutating-webhook-cfg; )
echo ""
__print_title "more details..."
read -r 
( set -x; kubectl get mutatingwebhookconfigurations.admissionregistration.k8s.io kyverno-resource-mutating-webhook-cfg -o yaml; )
