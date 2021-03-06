# Github Composite Actions

Utility composite actions for Parsley Workflows

- [`tag-draft-release`](./tag-draft-release/README.md) creates a new tag based on a semver or properties file and then creates a draft release including content from `CHANGELOG.md`
- [`slack-job-status`](./slack-job-status/README.md) creates outputs based on the job status usable with [voxmedia/github-action-slack-notify-build](https://github.com/voxmedia/github-action-slack-notify-build)
- [`service-name-gen`](./service-name-gen/README.md) creates a unique service name and corresponding hostname for an endpoint
- [`bit-tag-export`](./bit-tag-export/README.md) tags and exports bit components
- [`bdd-xray-export`](./bdd-xray-export/README.md) runs cucumber BDD tests and exports results to Xray
