# db-init-action

Composite Github Action that initializes freshly created databases. This action does the following:
- Creates four secrets in GCP Secret Manager - username/password for the DB user for service, and username/password for migrate user
- Creates the users in the DB with the username and password
- Proxies into Cloud SQL instance `parsley-services`
- Runs the init SQL script templatized in `init.sql.j2` using the `psql` client

## Design Decisions
- **Password generation:** The inspiration was taken from [here](https://github.com/community/community/discussions/39644). This would be [another option](https://github.com/licenseware/generate-password-and-hash). But the caveat with this option is 1) the password is not masked by the action and 2) Unnecessarily relying on a third party github action for a simple task

- **DB user creation in init script:** The error handling of the script init.sql was inspired from [here](https://stackoverflow.com/questions/8092086/create-postgresql-role-user-if-it-doesnt-exist/8099557?noredirect=1#comment85209018_8099557)

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
        
```

## Inputs

- **db-instance**: Name of the Cloud SQL instance
- **db-name**: Name of the database in the Cloud SQL instance
- **schema-name**: Name of the schema in the database
- **gcp-project-id**: The GCP project where the Cloud SQL instance resides
- **cloudsql-superuser**: User with cloudsqlsuperuser privileges in the Cloud SQL instance. This user is created by Terraform. [Link to Terraform Code](https://github.com/parsleyhealth/terraform-cloud-sql/blob/main/variables.tf#L11)
- **gcp-workload-id-provider**: GCP project ID to use for docker image repo
- **gcp-workload-id-service-account-email** - ServiceAccount for github workload