FROM gcr.io/cloudsql-docker/gce-proxy as cloudsql-proxy

FROM golang:1.19-alpine

# ATLAS_COMMAND gets injected by github action since passing it as an argument is
# troublesome with quoting for pgsql creds
ENV ATLAS_COMMAND=

# Copy cloud-proxy binary
COPY --from=cloudsql-proxy /cloud_sql_proxy /cloud_sql_proxy

COPY entrypoint.sh /

WORKDIR /atlas

ENTRYPOINT [ "/entrypoint.sh" ]
