# release-notes

Composite Github Action for taking release notes from our core repos and pushing them to a database in Notion.

## Usage

```yaml
# This workflow captures release notes from a release and pushes them to a database in Notion
name: Release Notes

on:
  release:
    types:
      - published

jobs:
  release-notes:
    runs-on: ubuntu-latest
    if: "${{ github.event.release.body != '' }}"
    env:
      NOTION_DATABASE_ID: 00000000-0000-0000-0000-000000000000
      PRODUCT: "Product Name, e.g. MyParsley"

    steps:
      - uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }}

      - uses: parsleyhealth/github-composite-actions/release-notes@main
        with:
          notion-token: ${{ secrets.NOTION_TOKEN }}
          notion-database-id: ${{ env.NOTION_DATABASE_ID }}
          product: ${{ env.PRODUCT }}
          release-tag: ${{ github.event.release.tag_name }}
          release-notes: ${{ github.event.release.body }}
```
