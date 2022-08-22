# Github Composite Actions

Utility composite actions for Parsley Workflows

- [`tag-draft-release`](./tag-draft-release/README.md) creates a new tag based on a semver or properties file and then creates a draft release including content from `CHANGELOG.md`
- [`slack-job-status`](./slack-job-status/README.md) creates outputs based on the job status usable with [voxmedia/github-action-slack-notify-build](https://github.com/voxmedia/github-action-slack-notify-build)
- [`service-name-gen`](./service-name-gen/README.md) creates a unique service name and corresponding hostname for an endpoint
- [`bit-tag-export`](./bit-tag-export/README.md) tags and exports bit components
- [`bdd-xray-export`](./bdd-xray-export/README.md) runs cucumber BDD tests and exports results to Xray
- [`build-push-action`](./build-push-action/README.md) builds and pushes docker image to GCR using workload id federation
- [`get-secretmanager-secret`](./get-secretmanager-secret/README.md) get secret from google cloud secret manager using workload id federation
- [`go-ci`](./go-ci/README.md) common CI patterns for running test, lint and sonar scans on go services
