# slack-job-status

Composite Github Action that creates outputs based on the job status usable with [voxmedia/github-action-slack-notify-build](https://github.com/voxmedia/github-action-slack-notify-build)

## Usage

```yaml
name: Some Deploy Thing
on:
  push:
    branches:
      - master
env:
    SLACK_CHANNEL_ID: somechannelid
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Slack notification start
      id: slack
      env:
        SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
      uses: voxmedia/github-action-slack-notify-build@v1
      with:
        channel_id: ${{ env.SLACK_CHANNEL_ID }}
        status: Starting Staging Deploy for Thing
        color: warning
    - name: Do some deploy thing
      run: |
        kubectl apply -f ./my-deploy.yml
    - name: Set status for Slack notification
      if: always()
      id: slack-status
      uses: parsleyhealth/github-composite-actions/slack-job-status@main
      with:
        job-description: Staging K8s Deploy of Thing
    - name: Slack notification results
      if: always()
      env:
        SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
      uses: voxmedia/github-action-slack-notify-build@v1
      with:
        message_id: ${{ steps.slack.outputs.message_id }}
        channel_id: ${{ env.SLACK_CHANNEL_ID }}
        status: ${{ steps.slack-status.outputs.status }}
        color: ${{ steps.slack-status.outputs.color }}
```

## Inputs

- **job-description**: A prefix to display with the job's status in the Slack notification, ex. `Node Deploy` or `K8S Deployment Rollout`

## Outputs

- **color**: The color relating to the status of the `job.status` (`cancelled` = `warning`, `failure` = `danger`, otherwise `good`)
- **status**: Text status to display in the Slack notification, uses `job-description` and will be postfixed by _Cancelled_, _Success_ or _Failed_
