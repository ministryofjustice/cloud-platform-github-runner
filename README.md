# Run GitHub actions from Kubernetes pods

Borrowing from https://github.com/SanderKnape/github-runner and https://caylent.com/github-actions-on-self-hosted-runners-for-kubernetes

To run, create the ns `github-runner`, then

create a repo token via Settings->Actions->Runners or https://docs.github.com/en/rest/reference/actions#self-hosted-runners

```
kubectl -n github-runner create secret generic github-token --from-literal=GITHUB_TOKEN=xxx

```
and deploy the runner
```
kubectl apply -f ./deployment.yaml
```
The runner service account will most likely need to be added to the `default:privileged` clusterrolebinding
