package tekton

task "build-image-from-git-source": {
	spec: {
		inputs: {
			resources: [{
				name: "source"
				type: "git"
			}]
			params: [{
			    name: "pathToContext"
			    description: "The directory containing the default.nix file"
                            _defaultString: "/workspace/source"
			}]
		}
		outputs resources: [{
			name: "builtImage"
			type: "image"
		}]
		volumes: [{
			name: "docker-config"
			configMap name: "docker-config"
		}]
		steps: [{Container : {
			name:  "build-and-push"
			image: "docker.io/lewo/n2k8s:latest"
			volumeMounts: [{
				name:      "docker-config"
				mountPath: "/builder/home/.docker/"
			}]
			command: [
				"/entrypoint",
			]
			args: [
				"--context",
				"$(inputs.params.pathToContext)",
				"--destination",
				"$(outputs.resources.builtImage.url)",
				"--image-manifest-filepath",
				"/builder/home/image-outputs/builtImage/index.json",
			]
		}}]
	}
}
