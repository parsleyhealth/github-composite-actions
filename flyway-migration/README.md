# flyway-migration

Composite Github Action for running Flyway migrations against CloudSQL instances.

## Usage

```yaml
name: Flyway Migration
on:
  push:
    branches:
      - master

jobs:
  migrate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: google-github-actions/auth@v0
        with:
          credentials_json: "${{ secrets.GCP_CLOUDSQL_CREDS }}"
          create_credentials_file: "true"

      - name: Run Flyway migration against CloudSQL
        uses: parsleyhealth/github-composite-actions/flyway-migration@v7.6.0
        with:
          migrations-dir: "path/to/migrations"
          cloud-sql-instance: "parsley-development-1:us-east1:sample-database=tcp:5432"
          flyway-command: >
            -url=jdbc:postgresql://localhost:5432/api
            -user=${{ secrets.DB_USER }}
            -password=${{ secrets.DB_PASSWORD }}
            -schemas=api,public
            migrate
          retries: "5"
```

## Inputs

- **cloud-sql-instance**: connection string for the Cloud SQL proxy, format: `<project-id>:<region>:<instance-id>=tcp:<port>`.
- **migrations-dir**: path to the migration SQL files relative to `$GITHUB_WORKSPACE` (default: `""`).
- **flyway-command**: Flyway CLI arguments including URL, user, password and command (e.g. `migrate`, `info`).
- **retries**: number of times to retry the command on failure (default: `5`).
