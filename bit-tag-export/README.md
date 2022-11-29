# bit-tag-export

Composite Github Action for tagging and exporting Bit components.

## Usage

```yaml
# This workflow hard-tags and exports soft-tagged components
name: Tag and Export Components

on:
  push:
    branches:
      - master
      
jobs:
  tag-and-export:
    runs-on: ubuntu-latest
    if: "!contains(github.event.head_commit.message, '--skip-ci')"
    env:
      SLACK_CHANNEL_ID: ASDFASDF
      BOT_PAT: ${{ secrets.PAT }}

    steps:
      - uses: actions/checkout@v3
        with:
            ref: ${{ github.head_ref }}

      - uses: parsleyhealth/github-composite-actions/bit-tag-export@v5
        with:
            parsley-bot-token: ${{ env.BOT_PAT }}
            bit-token: ${{ secrets.BIT_TOKEN }}
            slack-channel-id: ${{ env.SLACK_CHANNEL_ID }}
            slack-bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
```
