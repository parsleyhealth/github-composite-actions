# slack-job-status

Composite Github Action that executes cucumber BDD tests, generates reports and exports them to Xray.

## Usage

```yaml
name: Some BDD tests
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    
    - uses: actions/checkout@v2

    - name: Execute BDD tests and export to Xray
      uses: parsleyhealth/github-composite-actions/bdd-xray-export@main
      with:
        project-id: SOME_JIRA_PROJECT_ID
        browser: firefox
        record-video: "true"
        xray-client-id: ${{ env.XRAY_CLIENT_ID }}
        xray-client-secret: ${{ secrets.XRAY_CLIENT_SECRET }}
    
```

## Inputs

- **project-id**: the JIRA project ID to use for test reports etc.
- **browser**: browser engine to use for tests
- **record-video**: should test record execution?
- **node-version**: NodeJS version to use with action (default:lts/gallium)
- **xray-client-id**: Xray client ID
- **xray-client-secret**: Xray client secret
- **github-token**: Github token for uploading artifacts etc.

## Outputs
