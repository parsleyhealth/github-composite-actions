# Use the official Node.js 18 image with Debian Bullseye (slim)
FROM node:18-bullseye-slim

# Install Bit CLI and other dependencies
RUN npx @teambit/bvm install < /dev/null

# Install Bit CLI using the bvm script
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/teambit/bvm/master/bvm.install.sh)"

# Set Bit configurations
RUN bit config set analytics_reporting false && \
    bit config set error_reporting false

# Set the entrypoint to run the action script
ENTRYPOINT ["/entrypoint.sh"]

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh
USER user

# Add a health check command
HEALTHCHECK CMD node --version || exit 1
