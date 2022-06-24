# bit-tag-export

Composite Github Action for tagging and exporting Bit components.

## Usage

```yaml
# This workflow hard-tags and exports soft-tagged components
name: Tag and Export Components

on:
  pull_request:
    branches: [master]

jobs:
  tag-and-export:
    runs-on: ubuntu-latest
    if: "!contains(github.event.head_commit.message, '--skip-ci')"
    env:
      SLACK_CHANNEL_ID: ASDFASDF

    steps:
      - uses: actions/checkout@v2
        with:
            ref: ${{ github.head_ref }}

      - uses: parsleyhealth/github-composite-actions/bit-tag-export@main
        with:
            bit-token: ${{ secrets.BIT_TOKEN }}
            slack-channel-id: ${{ env.SLACK_CHANNEL_ID }}
            slack-bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
```
