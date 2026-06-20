FROM gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.22.1 AS cloudsql-proxy

FROM flyway/flyway:7.15.0

USER root
COPY --from=cloudsql-proxy /cloud-sql-proxy /cloud-sql-proxy
RUN chmod +x /cloud-sql-proxy
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
