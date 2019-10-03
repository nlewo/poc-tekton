package tekton

task "deploy-using-kubectl": {
	spec: {
		inputs: {
			resources: [{
				name: "source"
				type: "git"
			}, {
				name: "image"
				type: "image"
			}]
			params: [{
				name:        "path"
				type:        "string"
				description: "Path to the manifest to apply"
			}]
		}
		volumes: [{
			name: "docker-config"
			configMap name: "docker-config"
		}]
		steps: [ {Container : {
			name:  "check-if-image-tag-is-up-to-date"
			image: "nixery.dev/shell/findutils/yq/jq/skopeo"
			volumeMounts: [{
				name:      "docker-config"
				mountPath: "/builder/home/.docker/"
			}]
			command: ["bash"]
			args: [
				"-c",
				"""
                                cat $(inputs.params.path) | yq -rs '.[0].spec.template.spec.containers[0].image'
                                | xargs -I '{}' skopeo inspect docker://'{}' | jq -e '.Digest == "$(inputs.resources.image.digest)"'
                                """,
			]
		}}, {Container : {
			// Ok, this is a bit magic:/
			// We query the registry to get the digest of the image used in the deployment.
			// This step fails if this digest associated to the tag is not equal to the digest of the image resource.

			name:  "run-kubectl"
			image: "nixery.dev/shell/kubectl"
			command: ["kubectl"]
			args: [
				"apply",
				"-f",
				"$(inputs.params.path)",
			]
		}}]
	}
}
