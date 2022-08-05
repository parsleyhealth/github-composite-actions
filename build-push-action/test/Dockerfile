# syntax=docker/dockerfile:1

ARG GO_VERSION=1.18

FROM golang:${GO_VERSION}-alpine

ENV GOPRIVATE=github.com/parsleyhealth \
    USER=parsley UID=1001 GID=1001 \
    GRPC_HEALTH_PROBE_VERSION=v0.4.11 \
    WD=/app

WORKDIR ${WD}

RUN apk update \
    && apk add --no-cache ca-certificates \
    && addgroup -g ${GID} ${USER}\
    && adduser \
        --disabled-password \
        --home "${WD}" \
        --gecos "" \
        --ingroup "${USER}" \
        --no-create-home \
        --uid "${UID}" \
    "${USER}" \
    && chown ${USER}: ${WD} \
    && cd /tmp \
    && wget -q \
        https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 \
    && wget -qO - \
        https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/checksums.txt \
        | grep linux-amd64 > grpc_checksums.txt \
    && sha256sum -c ./grpc_checksums.txt \
    && rm ./grpc_checksums.txt \
    && mv ./grpc_health_probe-linux-amd64 /bin/grpc_health_probe \
    && chmod +x /bin/grpc_health_probe 

USER ${USER}
