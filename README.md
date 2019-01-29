# Generate some nice kube-prometheus

How? Run these steps:
```bash
./pullDependencies.sh
./compileManifests.sh
kubectl apply -f manifests/
```