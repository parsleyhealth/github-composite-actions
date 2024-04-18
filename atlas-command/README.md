# atlas-migration

Composite Github Action for running Atlas migrations against CloudSQL instances.

## Usage

```yaml
name: Atlas Migration
on:
  push:
    branches:
      - master

jobs:
    steps:
    - uses: actions/checkout@v3
    
    - uses: "google-github-actions/auth@v0"
      with:
        credentials_json: "${{ secrets.GCP_CLOUDSQL_CREDS }}"
        create_credentials_file: "true"

    - name: Run atlas migration against cloudsql
      uses: parsleyhealth/github-composite-actions/atlas-migration@v4
      with:
        migrations-dir: "/migrations/sql"
        cloud-sql-instance: "parsley-development-1:us-east1:sample-database=tcp:5432"
        atlas-command: >
          migrate apply \
          --dir "file://ent/migrate/migrations" \
          --url "postgres://${{ secrets.DB_USER }}:${{ secrets.DB_PASSWORD }}@localhost:3306/example"
        retries: "5"
```

## Inputs

- **cloud-sql-instance**: connection string for cloud sql proxy, should be in the format: `<project-id>:<region>:<cloud-sql-instance-id>=<bind-proto>:<bind-port>`.
- **migrations-dir**: path to the migration scripts relative to `$GITHUB_WORKSPACE` (default `./`).
- **atlas-command**: command to issue to goose including any credentials required.
- **retries**: number of times to retry command in case of failure (default: `5`).
