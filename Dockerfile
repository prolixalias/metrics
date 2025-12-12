# Base image
FROM node:20-bookworm-slim

# Copy repository
COPY . /metrics
WORKDIR /metrics

# Environment variables for Puppeteer
# IMPORTANT: These must be set BEFORE npm ci to prevent Puppeteer from downloading Chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_BROWSER_PATH=/usr/bin/chromium

# Setup
RUN chmod +x /metrics/source/app/action/index.mjs \
  # Install Chromium and fonts to support major charsets
  # Using Debian's Chromium instead of Google Chrome due to repository issues
  && apt-get update \
  && apt-get install -y chromium fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 --no-install-recommends \
  # Install deno for miscellaneous scripts
  && apt-get install -y curl unzip \
  && curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr/local sh \
  # Install ruby to support github licensed gem
  && apt-get install -y ruby-full git g++ cmake pkg-config libssl-dev xz-utils zlib1g-dev libxml2-dev libxslt-dev \
  && gem install nokogiri -- --use-system-libraries \
  && gem install licensed \
  # Install python for node-gyp
  && apt-get install -y python3 \
  # Clean apt/lists
  && rm -rf /var/lib/apt/lists/* \
  # Install node modules and rebuild indexes
  && npm ci \
  && npm run build

# Execute GitHub action
ENTRYPOINT node /metrics/source/app/action/index.mjs
