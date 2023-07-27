# Use the official Node.js 18 image with Debian Bullseye (slim)
FROM node:18-bullseye-slim

# Install Bit CLI and other dependencies
RUN npm install -g @teambit/bvm && \
    npm install -g @teambit/bit

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
