# goose-migration

Composite Github Action for running Goose migrations against CloudSQL instances.

## Usage

```yaml
name: Goose Migration
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

    - name: Run goose migration against cloudsql
      uses: parsleyhealth/github-composite-actions/goose-migrations@v4
      with:
        migrations-dir: "/migrations/sql"
        cloud-sql-instance: "parsley-development-1:us-east1:sample-database=tcp:5432"
        goose-version: "latest"
        goose-command: >
            postgres 
            "user=${{ secrets.DB_USER }} 
            password=${{ secrets.DB_PASSWORD }} 
            dbname=sample 
            port=5432 
            host=localhost" 
            up
        retries: "5"
```

## Inputs

- **cloud-sql-instance**: connection string for cloud sql proxy, should be in the format: `<project-id>:<region>:<cloud-sql-instance-id>=<bind-proto>:<bind-port>`.
- **migrations-dir**: path to the migration scripts relative to `$GITHUB_WORKSPACE` (default `./`).
- **goose-command**: command to issue to goose including any credentials required.
- **goose-version**: [version of v3 goose to use](https://github.com/pressly/goose/releases) (default: `latest`).
- **retries**: number of times to retry command in case of failure (default: `5`).
