ARG IMAGE_TAG=0.0.998-node-16.15.0

FROM bitcli/bit-non-root:${IMAGE_TAG}

COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh 
USER user 

ENTRYPOINT [ "/entrypoint.sh" ]
