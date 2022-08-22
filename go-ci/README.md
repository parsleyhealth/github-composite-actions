# go-ci

Composite Github Action that runs CI for go-based services.

## Usage

```yaml
name: Go CI
on:
  pull_request:
    types: 
    - opened
    - synchronize
    - reopened

jobs:
   name: test-lint-coverage
    strategy:
      matrix:
        go-version: [1.18.x]
        platform: [ubuntu-20.04]
    runs-on: ${{ matrix.platform }}
    steps:
    - uses: actions/checkout@v3
    - name: Run lint, test, coverage
      uses: parsleyhealth/composite-actions/go-ci@v3
      with:
        go-version: ${{ matrix.go-version }}
        pat: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
        sonar-token: ${{ secrets.SONAR_TOKEN }}
        run-lint: "true"

```

## Inputs

- **go-version**: version of go to use with tests and CI (default: `1.18.x`)
- **pat**: Personal Access Token for use with private packages
- **sonar-token**: API token to use with SonarCloud
- **run-lint**: Should the action run lint on the code (default: `true`)
