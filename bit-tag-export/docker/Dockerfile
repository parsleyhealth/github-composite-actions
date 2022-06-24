ARG IMAGE_TAG=latest-node-16.15.0

FROM bitcli/bit-non-root:${IMAGE_TAG}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

ENTRYPOINT [ "/entrypoint.sh" ]
