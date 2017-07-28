FROM prisms/gateway-base:1.2.0
LABEL maintainer "Philip Lundrigan <philipbl@cs.utah.edu>"

# Install Supervisor
RUN apt-get update && apt-get install -y \
    supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install dumb-init
RUN pip install --no-cache-dir dumb-init

# Install Home Assistant
RUN pip install --no-cache-dir homeassistant==0.40.2
RUN mkdir /etc/homeassistant

# Copy Supervisor configuration
COPY programs.conf /etc/supervisor/conf.d/programs.conf

ENV IMAGE_VERSION 1.2.0

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["bash", "-c", "supervisord -c /etc/supervisor/supervisord.conf -n"]
