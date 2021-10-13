# service-name-gen

Composite Github Action for generating consistent service name prefixes and URLs

## Usage

```yaml
name: Deploy My Site
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Generate unique service name and URL
      id: service
      uses: parsleyhealth/composite-actions/service-name-gen@main
      with:
        service-type: 'website'
        service-id: pr-${{ github.event.number }}
        domain: "work.tables.com" 
    - name: Deploy site
      run: |
        make deploy URL=${{ steps.service.outputs.url }}
```

## Inputs

- **service-type**: Prefix to use for service name
- **service-id**: Unique ID suffix for service
- **domain**: Root domain for service subdomain

## Outputs

- **url**: Generated `https` URL
- **hostname**: Generated hostname for service
- **name**: Generated unique service name
