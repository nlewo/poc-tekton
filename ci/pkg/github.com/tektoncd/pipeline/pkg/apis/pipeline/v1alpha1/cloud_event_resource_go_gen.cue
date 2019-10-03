// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/tektoncd/pipeline/pkg/apis/pipeline/v1alpha1

package v1alpha1

// CloudEventResource is an event sink to which events are delivered when a TaskRun has finished
CloudEventResource :: {
	// Name is the name used to reference to the PipelineResource
	name: string @go(Name)

	// Type must be `PipelineResourceTypeCloudEvent`
	type: PipelineResourceType @go(Type)

	// TargetURI is the URI of the sink which the cloud event is develired to
	targetURI: string @go(TargetURI)
}
