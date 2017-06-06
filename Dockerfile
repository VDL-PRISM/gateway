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

# Install custom components
RUN git clone https://github.com/VDL-PRISM/home-assistant-components.git && \
    cd home-assistant-components && \
    git checkout tags/v1.0.0 && \
    pip install --no-cache-dir -r requirements.txt

# Copy Supervisor configuration
COPY programs.conf /etc/supervisor/conf.d/programs.conf

ENV IMAGE_VERSION 1.1.0

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["bash", "-c", "cp -RT /home-assistant-components /etc/homeassistant/custom_components && supervisord -c /etc/supervisor/supervisord.conf -n"]
