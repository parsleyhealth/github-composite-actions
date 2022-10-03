FROM gcr.io/cloudsql-docker/gce-proxy as cloudsql-proxy

FROM golang:1.19-alpine

# Copy cloud-proxy binary
COPY --from=cloudsql-proxy /cloud_sql_proxy /cloud_sql_proxy

RUN go install github.com/pressly/goose/v3/cmd/goose@latest

COPY entrypoint.sh /

WORKDIR /goose

ENTRYPOINT /entrypoint.sh
