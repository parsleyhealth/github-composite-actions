# tag-draft-release

Composite Github Action that creates a tag based on a properties file and a draft release including content from `CHANGELOG.md`

## Usage

```yaml
name: Tag and Create Draft Release
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'
    - name: Tag and Create Draft Release
      uses: parsleyhealth/composite-actions/tag-create-draft-release@v1
      with:
        semver-file: 'version.txt'
        use-v: false # do you want `v1.0.0` or `1.0.0`
        changelog: ./CHANGELOG.md # defaults to this
    - name: Tag and Create Draft Release with overridden version
      uses: parsleyhealth/composite-actions/tag-create-draft-release@main
      with:
        semver: '1.0.2' # or use an output to inject this from somewhere else
        use-v: true # will create `v1.0.2` tag
```

## Inputs

- **semver-file**: Relative path to a one-line file with format `version=x.x.x` to use for semver
- **semver**: A non-prefixed semantic version to use for tagging (overrides any file provided)
- **changelog**: Relative path to [`CHANGELOG.md`](https://keepachangelog.com/en/1.0.0/) file
- **use-v**: Prefix the version with the letter 'v'

## Outputs

- **tag**: Generated and pushed tag
- **draft-release-url**: URL to draft release in Github
