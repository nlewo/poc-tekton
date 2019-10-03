### Cue notes

- Manually create the file
  pkg/github.com/tektoncd/pipeline/pkg/apis/pipeline/v1alpha1/override.cue
  to fix Cue issues and add more constraints. I think Cue should have
  a way to manage this file on its CLI.

- I got tekton from my fork because it's json schema is a bit
  patched. See https://github.com/tektoncd/pipeline/pull/1366

### Cue todo

- Currently only the task type is typed
- Submit a patch to tetkon to inlne the Container field (see in tekton.cue)
