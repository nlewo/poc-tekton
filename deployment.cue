package deployment

deployment "hello-world": {
	apiVersion: "extensions/v1beta1"
	kind:       "Deployment"
	metadata name: "hello-world"
	spec template: {
		metadata labels app: "hello-world"
		spec containers: [{
			name: "hello-world"
			_imageFromNix: {
				name: "docker.io/lewo/tekton-hello-world"
			}
			ports: [{
				containerPort: 8080
				name:          "hello-world"
			}]
			livenessProbe: {
				httpGet: {
					path: "/"
					port: "hello-world"
				}
				initialDelaySeconds: 3
				periodSeconds:       5
			}
			readinessProbe: {
				httpGet: {
					path: "/"
					port: "hello-world"
				}
				initialDelaySeconds: 3
				periodSeconds:       5
			}
		}]
	}
}
service "hello-world": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "hello-world"
		labels app: "hello-world"
	}
	spec: {
		ports: [{
			port:       80
			targetPort: 8080
		}]
		selector app: "hello-world"
		type: "LoadBalancer"
	}
}
