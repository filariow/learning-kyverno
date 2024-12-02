#!/bin/bash

set -e

# create the cluster
kind delete cluster --name kyverno || true
kind create cluster --name kyverno --config kind-config.yaml

# install kyverno 
helm repo add --force-update kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno \
  -n kyverno --create-namespace \
  --values ./kyverno-values.yaml

# wait for kyverno to be rolled out
kubectl rollout status -n kyverno deployment \
  --timeout 300s kyverno-admission-controller 
kubectl rollout status -n kyverno deployment \
  --timeout 300s kyverno-background-controller
kubectl rollout status -n kyverno deployment \
  --timeout 300s kyverno-cleanup-controller
kubectl rollout status -n kyverno deployment \
  --timeout 300s kyverno-reports-controller
