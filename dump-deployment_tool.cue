package deployment

import (
	"tool/cli"
	"strings"
	"tool/exec"

)

# first we generate the output hash. We then replace this hash in the deployment file. I don't understand why, but we cannot use this hash in the cue struct: it fails because of non-concrrete value. 
command "dump": {
        container = deployment["hello-world"].spec.template.spec.containers[0]
	if (container._imageFromNix != _|_) {
           task instantiate: exec.Run & {
                # This is not correct because this is the derviation hash while we would like to have to output hash
		cmd: ["nix-instantiate"]
		stdout: string
	}}} &

	{
        	task print: cli.Print & {
                        # Extract the hash from the path
			hash = strings.Split(strings.Split(task.instantiate.stdout, "/")[3], "-")[0]
			d = deployment["hello-world"] & {
                          spec template spec containers: [...{
                               _imageFromNix name: string, image : _imageFromNix.name + ":IMAGE-HASH"}]}
                                             if (deployment["hello-world"].spec.template.spec.containers[0]._imageFromNix != _|_) { text: strings.Replace(yaml.MarshalStream([d]), "IMAGE-HASH", hash, -1)}
		}
	}
