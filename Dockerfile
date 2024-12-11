# Use an official Node.js runtime as the base image
FROM node:22


# Install dependencies for Chrome
RUN apt-get update && apt-get install -y wget gnupg && rm -rf /var/lib/apt/lists/*

# Install latest Chrome dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    jq \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Create a working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json to the working directory
COPY package.json ./
# Install application dependencies
RUN npm install
# Copy the rest of your application source code to the working directory
# Define the command to run your application


# Copy run script and Puppeteer script
COPY run.sh /app/run.sh
COPY screenshot.js /app/screenshot.js

# Make run.sh executable
RUN chmod +x /app/run.sh

# Define the entrypoint
ENTRYPOINT ["/app/run.sh"]
