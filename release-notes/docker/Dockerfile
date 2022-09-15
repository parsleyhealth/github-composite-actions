FROM node:16-alpine

COPY package.json /app/package.json
COPY index.js /app/index.js
COPY entrypoint.sh /entrypoint.sh

RUN cd /app && npm i
RUN chmod +x /entrypoint.sh 

ENTRYPOINT [ "/entrypoint.sh" ]
