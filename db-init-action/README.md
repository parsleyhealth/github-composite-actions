# db-init-action

Composite Github Action that builds and pushes docker image to `gcr.io` repo using workload ID for auth.

## Design Decisions
Password generator: The inspiration was taken from here: https://github.com/community/community/discussions/39644
Other Option: https://github.com/licenseware/generate-password-and-hash. But the caveat with this option is 1) the password is not masked by the action and 2) Unnecessarily relying on a third party github action for a simple task
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
        schema-name: awesome-schema
        gcp-project-id: mycompany-staging
        cloudsql-superuser: powerful-user
        db-user-for-app: awesome-user
        gcp-workload-id-provider: ${{ secrets.GCP_WORKLOAD_ID_PROVIDER }}
        gcp-workload-id-service-account-email: ${{ secrets.GCP_WORKLOAD_ID_SA_EMAIL }}
        

```

## Inputs

- **db-instance**: Name of the Cloud SQL instance
- **db-name**: Name of the database in the Cloud SQL instance
- **schema-name**: Name of the schema in the database
- **gcp-project-id**: The GCP project where the Cloud SQL instance resides
- **cloudsql-superuser**: User with cloudsqlsuperuser privileges in the Cloud SQL instance. This user is created by Terraform
- **db-user-for-app**: The user the app will use. This user is created by the workflow
- **db-init-script-path**: Path to init script relative to root of repository
- **gcp-workload-id-provider**: GCP project ID to use for docker image repo
- **gcp-workload-id-service-account-email** - ServiceAccount for github workload