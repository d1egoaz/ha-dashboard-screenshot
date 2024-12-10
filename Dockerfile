FROM node:18-bullseye-slim

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
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Set up Puppeteer environment
RUN npm install puppeteer@latest

# Copy our run script and give it execute permissions
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
