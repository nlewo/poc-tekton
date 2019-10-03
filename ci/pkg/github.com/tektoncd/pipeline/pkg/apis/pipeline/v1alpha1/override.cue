package v1alpha1

import (
      	corev1 "k8s.io/api/core/v1"
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// This is because cue doesn't import these object
ObjectMeta :: metav1.ObjectMeta
TypeMeta :: metav1.TypeMeta
Volume : corev1.Volume

// String is allowd by default which is not constrained enough
PipelineResourceType :: enumPipelineResourceType
