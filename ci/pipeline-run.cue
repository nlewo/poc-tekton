package tekton

pipelineRun "hello-world-pipeline-run": {
	apiVersion: "tekton.dev/v1alpha1"
	kind:       "PipelineRun"
	metadata name: "hello-world-pipeline-run"
	spec: {
		pipelineRef name: "hello-world-pipeline"
		resources: [{
			name: "poc-repo"
			resourceRef name: "poc-repo"
		}, {
			name: "app-image"
			resourceRef name: "hello-world-image"
		}]
	}
}
