# setup-node

Composite Github Action that sets up Node.js and injects private repo keys to .npmrc file. Use this instead of [`actions/setup-node`](https://github.com/actions/setup-node) (this composite uses it under-the-hood).

## Usage

```yaml
name: Some Deploy Thing
on:
  push:
    branches:
      - master
env:
    NPM_TOKEN: ${{ secrets.NODE_AUTH_TOKEN }}
    BIT_TOKEN: ${{ secrets.BIT_TOKEN }}

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js with version 19.0.1
      uses: parsleyhealth/github-composite-actions/setup-nodejs@v4
      with:
        node-version: "19.0.1"
    
    - name: Setup Node.js with default node version but override bit-token
      uses: parsleyhealth/github-composite-actions/setup-nodejs@v4
      with:
        bit-token: ${{ secrets.OTHER_BIT_TOKEN }}

```

## Inputs

- **node-version**: Node.js version to install, defaults to `lts/gallium`, [reference other versions here](https://nodejs.org/en/download/releases/)
- **npm-token**: Private repo access token, defaults to use injected environment variable `NPM_TOKEN`, will error if neither are set
- **bit-token**: Private bit.dev repo access token, defaults to use injected environment variable `BIT_TOKEN`, will error if neither are set
