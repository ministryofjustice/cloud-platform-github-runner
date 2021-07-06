# Run GitHub actions from Kubernetes pods

Borrowing from https://github.com/SanderKnape/github-runner and https://caylent.com/github-actions-on-self-hosted-runners-for-kubernetes

To run, create the ns `github-runner`, then

create a personal GH token with only "public_repo" access
```
kubectl -n github-runner create secret generic github-token --from-literal=GITHUB_PERSONAL_TOKEN=xxx

```
and deploy the runner
```
kubectl apply -f ./deployment.yaml
```
