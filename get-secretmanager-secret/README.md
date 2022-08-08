# get-secretmanager-secret

Composite Github Action that retreives a secret from Google Cloud Secrets Manager

## Usage

```yaml
name: Get secret example
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Get our secret
      id: my-secret
      uses: parsleyhealth/composite-actions/get-secretmanager-secret@v3
      with:
        secret-id: someproject/somesecret
        gcp-workload-id-provider: ${{ secrets.GCP_WORKLOAD_ID_PROVIDER }}
        gcp-workload-id-service-account-email: ${{ secrets.GCP_WORKLOAD_ID_SA_EMAIL }}
    - name: Use our secret
      run: |
        echo ${{ steps.my-secret.outputs.content }} > some_secret_file.txt
```

## Inputs

- **secret-id**: The shorthand ID for the secret. Example: `<project-id>/<secret-id>` for the "latest"
- **gcp-workload-id-provider** - See <https://github.com/google-github-actions/auth>
- **gcp-workload-id-service-account-email** - See <https://github.com/google-github-actions/auth>

## Outputs

- **content**: The content of the secret
