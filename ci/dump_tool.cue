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
		text: yaml.MarshalStream([ o for o in kubernetes.tasks ])
	}
}

command "dump-pipeline": {
	task print: cli.Print & {
		text: yaml.MarshalStream([ o for o in objects if o.kind == "Pipeline" ])
	}
}
