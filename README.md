This is an experimental project with Tekton and Nix.

The goal is to define a Pipeline to build and deploy a Go application.

### Requirements

- A Kubernetes cluster
- Tekton Pipelines is already deployed
- Tekton Triggers is already deployed (for webhook handling)

### Getting Started

#### Deploy tasks

We first need to deploy some tasks
```
$ kubectl apply -f ci/task-build-docker-image.yaml
$ kubectl apply -f ci/task-check-deploy.yaml
```

We then need to add a task to update the digest resource. This is a
workaround (see https://github.com/tektoncd/catalog/pull/68 and
https://github.com/tektoncd/pipeline/issues/216)

```
$ kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/0b48da8e336a4214aff46af242658dc056199b1c/update-image-digests/image-digest-updater.yaml
$ kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/0b48da8e336a4214aff46af242658dc056199b1c/update-image-digests/update-image-digests.yaml
```

#### Deploy and run the pipeline

We can now create the pipeline:

```
$ kubectl apply -f ci/build-deploy-pipeline.yaml
```

To push to an authenticated registry, we need to expose a Docker
`config.json` file to `n2k8s`. See
https://github.com/nlewo/n2k8s#authentication for details.

```
$ kubectl create configmap docker-config --from-file=~/.docker/config.json
```

We can finally run the Pipeline:
```
$ kubectl apply -f ci/hello-world-pipeline-run.yaml
```

#### Display logs

To display the logs of the Pipeline run with the Tekton CLI:
```
$ tkn pipelinerun logs hello-world-pipeline-run -f
```

At the end, we should be able to get a http respond from the web
application:

```
$ curl $(kubectl get svc hello-world -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")
hello world
```

#### Enable webhook (triggers)

First an eventlistener must be created. This listener has a public IP which
will be used when configuring the github webhook. A secret is set on webhook creation
so that the incoming events can be validated by tekton. The webhook secret is also stored
in a k8s secret.

The secret is validated with a tekton task which needs to be installed.

```
$ kubectl apply -f ci/eventlistener.yaml
$ sed 's/GITHUB_WEBHOOK_TOKEN/secret/' ci/hello-world-webook-secret.yaml | kubectl apply -f -
$ kubectl apply -f ci/task-validate-github-event.yaml
```

Finally the trigger bindings and templates:

```
$ kubectl apply -f ci/triggerbinding-github.yaml
$ kubectl apply -f ci/hello-world-triggertemplate.yaml
```

When a github event is received by the `eventlistener` it is first validated by
the `validate-github-event` task. Then the `triggerbinding` binds some of the
event values to params which are given to the `triggertemplate`.

The `triggertemplate` defines the list of resources to be created in our case a
`pipelinerun` for the hello-world project.
