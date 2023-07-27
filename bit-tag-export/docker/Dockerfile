# Use the official Node.js 18 image with Debian Bullseye (slim)
FROM node:18-bullseye-slim

# Install Bit CLI
RUN npx @teambit/bvm install < /dev/null
RUN bit config set analytics_reporting false && \
    bit config set error_reporting false

# Set the entrypoint to run the action script
COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh
USER user

ENTRYPOINT ["/entrypoint.sh"]
