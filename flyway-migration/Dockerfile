FROM gcr.io/cloudsql-docker/gce-proxy AS cloudsql-proxy

FROM flyway/flyway:7.15.0

USER root
COPY --from=cloudsql-proxy /cloud_sql_proxy /cloud_sql_proxy
RUN chmod +x /cloud_sql_proxy
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
