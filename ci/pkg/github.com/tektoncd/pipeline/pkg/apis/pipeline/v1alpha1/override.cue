package v1alpha1

import (
      	corev1 "k8s.io/api/core/v1"
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

ObjectMeta :: metav1.ObjectMeta
TypeMeta :: metav1.TypeMeta
Volume : corev1.Volume

PipelineResourceType :: enumPipelineResourceType
