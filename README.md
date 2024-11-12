# Learning Kyverno

This repo contains a quick demo for showing how to crash kyverno by deleting the node it's running on.

```bash
# create the kind cluster and install kyverno
./00-setup.sh

# show webhooks and apply a mutating policy for pods
./01-demo.sh

# delete the node and show pods can't be created
./02-crashing-kyverno.sh
```
