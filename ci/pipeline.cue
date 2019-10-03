package tekton

pipelineResource "poc-repo": {
	apiVersion: "tekton.dev/v1alpha1"
	kind:       "PipelineResource"
	metadata name: "poc-repo"
	spec: {
		type: "git"
		params: [{
			name:  "revision"
			value: "master"
		}, {
			name:  "url"
			value: "https://github.com/nlewo/poc-tekton"
		}]
	}
}
pipelineResource "hello-world-image": {
	apiVersion: "tekton.dev/v1alpha1"
	kind:       "PipelineResource"
	metadata name: "hello-world-image"
	spec: {
		type: "image"
		params: [{
			name:  "url"
			value: "lewo/tekton-hello-world"
		}]
	}
}
pipeline "hello-world-pipeline": {
	apiVersion: "tekton.dev/v1alpha1"
	kind:       "Pipeline"
	metadata name: "hello-world-pipeline"
	spec: {
		resources: [{
			name: "poc-repo"
			type: "git"
		}, {
			name: "app-image"
			type: "image"
		}]
		tasks: [{
			name: "build-app"
			taskRef name: "build-image-from-git-source"
			params: [{
				name:  "pathToContext"
				value: "/workspace/source"
			}]
			resources: {
				inputs: [{
					name:     "source"
					resource: "poc-repo"
				}]
				outputs: [{
					name:     "builtImage"
					resource: "app-image"
				}]
			}
		}, {
			// This is a workaround because the digest is not updated yet by tekton.
			// See https://github.com/tektoncd/pipeline/issues/216 and https://github.com/tektoncd/catalog/pull/68
			name: "update-digest"
			params: [{
				name:  "pipelineTask"
				value: "build-app"
			}]
			runAfter: [
				"build-app",
			]
			taskRef name: "update-image-digests"
		}, {
			name: "deploy-app"
			taskRef name: "deploy-using-kubectl"
			runAfter: [
				"update-digest",
			]
			params: [{
				name:  "path"
				value: "/workspace/source/deployment.yaml"
			}]
			resources inputs: [{
				name:     "source"
				resource: "poc-repo"
			}, {
				name:     "image"
				resource: "app-image"
			}]
		}]
	}
}
