# Use the official Node.js 18 image with Debian Bullseye (slim)
FROM node:18-bullseye-slim

# Install required dependencies
RUN apt update && apt install -y git

# Install Bit CLI and other dependencies
RUN npx @teambit/bvm install < /dev/null

# Add Bit CLI to the PATH
ENV PATH="/root/.bvm:/root/bin:${PATH}"

# Set Bit configurations
RUN bit config set analytics_reporting false && \
    bit config set error_reporting false

# Add .npmrc
COPY npmrc.tpl /etc/npmrc

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Set the entrypoint to run the action script
ENTRYPOINT ["/entrypoint.sh"]
