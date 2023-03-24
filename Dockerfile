FROM python:3.10-slim-buster

# The dalai server runs on port 3000
EXPOSE 3000

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        curl \
        g++ \
	git \
        make \
        python3-venv \
        software-properties-common

# Add NodeSource PPA to get Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install Node.js 18.x
RUN apt-get update \
    && apt-get install -y nodejs \
    && apt-get install -y sudo

WORKDIR /root/dalai
RUN npm install -g npm@latest
RUN sudo chown -R 1000:1000 "/root/.npm"
# Install dalai and its dependencies
RUN npm install dalai@0.3.1

RUN npx dalai alpaca setup

# FIX
# RUN sudo chown -R 1000580000:0 "/.npm"
RUN sudo npm cache clean --force 
# Run the dalai server
CMD [ "npx", "dalai", "serve" ]
