<!-- markdownlint-configure-file { "MD024": { "siblings_only": true } } -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v5.2.4]

### Added

- db-init-action: Added Secret management and templated init db script

## [v5.2.3]

### Fixed

- db-init-action: got rid of extra whitespace in secret output

## [v5.2.2]

### Fixed

- db-init-action: got rid of checkout 

## [v5.2.1]

### Fixed

- Typo in db-init-action

## [v5.2.0]

### Added

- Added new `db-init-action` for using to initialize databases in centralized cloud sql instance

## [v5.1.0] - 2022-12-23

### Fixed

- Print the output of bit tag —persist

## [v5.0.3] - 2022-12-01

### Fixed

- `bit-tag-export` fixing output issue w/ quotes

## [v5.0.2] - 2022-11-30

### Fixed

- `bit-tag-export` action now saves raw output from `bit tag` to a local file for transformation

## [v5.0.1] - 2022-11-29

### Fixed

- `bit-tag-export` action now prints raw output from `bit tag` command for debugging/formatting purposes

## [v5.0.0] - 2022-11-29

### Updated

- `bit-tag-export` action now requires `parsley-bot-token` input in order to assume id to bypass branch protection on bit repos

## [v4.4.0] - 2022-11-09

### Added

- `setup-nodejs` composite action to reduce confusion and DRY in repos that need bit.dev/etc.

## [v4.3.0] - 2022-11-07

### Added

- New optional for test command to execute with custom test command for `go-ci`

## [v4.2.1] - 2022-10-5

### Fixed

- fixed various issues with `goose-migrations`

## [v4.2.0] - 2022-10-3

### Added

- Added `goose-migration` action for goose migrations to deprecate old repo/code

## [v4.1.3] - 2022-9-21

### Updated

- added new option for golangci-lint `lint-timeout` in go-ci action

## [v4.1.2] - 2022-9-15

### Updated

- Convert Markdown from GH notes to Notion blocks

## [v4.1.1] - 2022-9-15

### Fixed

- Fixed broken inputs

## [v4.1.0] - 2022-9-15

### Added

- added new composite action `release-notes` to push notes from our core products to a Notion database.

## [v4.0.0] - 2022-9-8

### Added

- added new required options for sonarqube scanner `sonar-org` and `sonar-project-key` in go-ci action

## [v3.4.0] - 2022-8-23

### Added

- `run-gosec` option for go-ci action

## [v3.3.1] - 2022-8-23

### Fixed

- quote issue in go-ci action

## [v3.3.0] - 2022-8-22

### Added

- `go-ci` action for common Go CI

## [v3.2.4] - 2022-8-9

### Fixed

- attempting to fix auto-tagger action

## [3.2.2] - 2022-8-9

### Fixed

- attempting to fix auto-tagger action

## [3.2.1] - 2022-8-9

### Fixed

- attempting to fix auto-tagger action

## [3.2.0] - 2022-8-8

### Added

- `get-secretmanager-secret` action to get a secret from google cloud secret manager using workload ID

## [3.1.0] - 2022-8-5

### Added

- `build-push-action` action to build and push docker image to GCR using workload federation

## [3.0.0] - 2022-7-28

### Updated / Breaking Change

- added `status` input for slack-job-status composite action, needed when using this action inside another composite action

## [2.1.0] - 2022-7-19

### Added

- added `bdd-xray-export` composite action

## [2.0.3] - 2022-6-27

### Fixed

- fixed ordering issue with bit commands

## [2.0.2] - 2022-6-27

### Fixed

- fixed non-root chmod issue

## [2.0.0] - 2022-6-24

### Added

- added bit-tag-export composite/docker action

## [1.2.0] - 2021-10-13

### Added

- added service-name-gen composite action

## [1.1.0] - 2021-09-15

### Added

- added slack-job-status composite action

## [1.0.2] - 2021-09-15

### Changed

- bumping tag to right the ship

## [1.0.1] - 2021-09-15

### Changed

- tag-draft-release `README.md` update
- renamed action file to be more descriptive

## [1.0.0] - 2021-09-15

### Added

- tag-draft-release composite action
