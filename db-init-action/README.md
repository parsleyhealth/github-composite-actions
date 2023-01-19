# build-push-action

Composite Github Action that builds and pushes docker image to `gcr.io` repo using workload ID for auth.

## Usage

```yaml
name: Initialize awesome database in  mycompany-services cloud sql instance in staging project
on: workflow_dispatch
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Initialize Database
      uses: parsleyhealth/composite-actions/db-init-action@v1
      with:
        db-instance: mycompany-services
        db-name: awesome
        gcp-project-id: mycompany-staging
        cloudsql-superuser: powerful-user
        db-init-script-path: database/init.sql
        gcp-workload-id-provider: ${{ secrets.GCP_WORKLOAD_ID_PROVIDER }}
        gcp-workload-id-service-account-email: ${{ secrets.GCP_WORKLOAD_ID_SA_EMAIL }}
        

```

## Inputs

- **db-instance**: Name of the Cloud SQL instance
- **db-name**: Name of the database in the Cloud SQL instance
- **gcp-project-id**: The GCP project where the Cloud SQL instance resides
- **cloudsql-superuser**: User with cloudsqlsuperuser privileges in the Cloud SQL instance
- **db-init-script-path**: Path to init script relative to root of repository
- **gcp-workload-id-provider**: GCP project ID to use for docker image repo
- **gcp-workload-id-service-account-email** - ServiceAccount for github workload