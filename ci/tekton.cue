package tekton

import (
	"github.com/tektoncd/pipeline/pkg/apis/pipeline/v1alpha1"
)

task <Name> : v1alpha1.Task & {
	apiVersion: "tekton.dev/v1alpha1"
	kind:       "Task"
	metadata name: Name
}

// This is where we convert Tekton extracted structure to structure that can be applied as Kubernetes resource
kubernetes tasks: {
	for k, x in task {
		"\(k)" :
			{for k, v in x if k != "spec" {"\(k)" : v}} &
			{spec :
				{for k, v in x.spec if k != "inputs" && k != "steps" {"\(k)" : v}} &
				// The goal is to translate the default value with needs a dedicated json marshaller
				// See https://github.com/tektoncd/pipeline/blob/92d5bcca31a690282179bae74a9b995c9e6337c5/pkg/apis/pipeline/v1alpha1/param_types.go#L86
				{inputs:
					{for k, v in x.spec.inputs if k != "params" {"\(k)" : v}} &
					{params:
						[ {for k, v in p if k != "default" {"\(k)" :     v
						}} & {for k, _ in p if k == "default" {default : p.default.StringVal}
						} for p in x.spec.inputs.params ]
					}

				} &
				// This is because the container structure is not inlined in the tetkon model.
				{steps: [ c.Container for c in x.spec.steps ]}
			}
	}
}

ParamTypeString :: v1alpha1.ParamTypeString
