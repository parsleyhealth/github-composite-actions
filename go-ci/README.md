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
    - uses: actions/checkout@v4
    - name: Run lint, test, coverage
      uses: parsleyhealth/composite-actions/go-ci@v4
      with:
        go-version: ${{ matrix.go-version }}
        pat: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
        sonar-token: ${{ secrets.SONAR_TOKEN }}
        sonar-org: my-org
        sonar-project-key: super-awesome-service
        run-lint: "true"
        run-gosec: "true"
        test-cmd: "go test ./... -coverprofile=coverage.out"

```

## Inputs

- **go-version**: version of go to use with tests and CI (default: `1.18.x`)
- **pat**: Personal Access Token for use with private packages (required)
- **sonar-token**: API token to use with SonarCloud (required)
- **sonar-org**: Org to associate with scan (default: `parsleyhealth`)
- **sonar-project-key**: Project key to identify source in sonar dash (required)
- **run-lint**: Should the action run lint on the code (default: `true`)
- **run-gosec**: Should the action run the gosec on the code (default: `false`)
- **test-cmd**: Should override the test command (default :`go test ./... -coverprofile=coverage.out`)
