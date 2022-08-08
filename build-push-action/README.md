# build-push-action

Composite Github Action that builds and pushes docker image to `gcr.io` repo using workload ID for auth.

## Usage

```yaml
name: Create and push docker image
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Build and push docker image
      uses: parsleyhealth/composite-actions/build-push-action@v3
      with:
        image-name: my-service
        image-tags: "latest,1.0.0,foo"
        gcp-project-id: mycompany-artifacts
        gcp-workload-id-provider: ${{ secrets.GCP_WORKLOAD_ID_PROVIDER }}
        gcp-workload-id-service-account-email: ${{ secrets.GCP_WORKLOAD_ID_SA_EMAIL }}

```

## Inputs

- **context**: relative path to `Dockerfile` and contents for context to builder
- **image-name**: Image name to use when building and tagging
- **image-tags**: CSV string of tags to use for docker image
- **image-build-args**: Key value, comma separated build arguments for docker (ex. `FOO=BAR,TEST=SOMETHING`)
- **image-registry-uri**: URI for Google Container Registry to use (uses `gcr.io` by default)
- **gcp-project-id**: GCP project ID to use for docker image repo
- **gcp-workload-id-provider** - See <https://github.com/google-github-actions/auth>
- **gcp-workload-id-service-account-email** - See <https://github.com/google-github-actions/auth>
