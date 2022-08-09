<!-- markdownlint-configure-file { "MD024": { "siblings_only": true } } -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.2.4] - 2022-8-9

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
