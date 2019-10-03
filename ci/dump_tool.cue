package tekton

import (
	"encoding/yaml"
	"tool/cli"
)

objects: [ x for v in objectSets for x in v ]

objectSets: [
	task,
	pipeline,
]

command "dump-task": {
	task print: cli.Print & {
		text: yaml.MarshalStream([ v for v in kubernetes.tasks ])
	}
}

command "dump-pipeline": {
	task print: cli.Print & {
		text: yaml.MarshalStream([ v for v in kubernetes.pipelines ])
	}
}

command "dump-non-run": {
	task print: cli.Print & {
		text: yaml.MarshalStream([ v for v in kubernetes.pipelines & kubernetes.tasks & kubernetes.pipelineResources ])
	}
}
