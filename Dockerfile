# Use a base image with Node.js and other dependencies
FROM node:18-buster

# Install necessary packages for Chrome, Xvfb, VNC, and noVNC
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    nginx \
    git \
    # --- Chrome dependencies ---
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    --no-install-recommends

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git /usr/local/novnc

# Set up the working directory
WORKDIR /usr/src/app

# Copy application files
COPY package*.json ./
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.js .
COPY container_start.sh .

# Install Node.js dependencies
RUN npm install

# Make the start script executable
RUN chmod +x container_start.sh

# Set the entrypoint
ENTRYPOINT ["./container_start.sh"]
