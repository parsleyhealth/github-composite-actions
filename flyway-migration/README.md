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
        env:
          FLYWAY_PASSWORD: ${{ secrets.DB_PASSWORD }}
        with:
          migrations-dir: "/path/to/migrations"
          cloud-sql-instance: "parsley-development-1:us-east1:sample-database=tcp:5432"
          flyway-command: >
            -url=jdbc:postgresql://localhost:5432/dbname
            -user=db_user
            -schemas=api,public
            migrate
          retries: "5"
```

## Inputs

- **cloud-sql-instance**: connection string for the Cloud SQL proxy, format: `<project-id>:<region>:<instance-id>=tcp:<port>`.
- **migrations-dir**: path to the migration SQL files relative to `$GITHUB_WORKSPACE`, with a leading `/` (e.g. `/data-api/api/src/main/resources/db/migration`).
- **flyway-command**: Flyway CLI arguments including URL, user and command (e.g. `migrate`, `info`). Do not include `-password` here.
- **retries**: number of times to retry the command on failure (default: `5`).

## Passing the database password

Pass the password via `env.FLYWAY_PASSWORD` on the step, not as a `-password=` CLI argument. Flyway reads `FLYWAY_PASSWORD` natively, and setting it via `env:` injects it directly into the container without going through the action's input system, keeping it off the process argument list.
