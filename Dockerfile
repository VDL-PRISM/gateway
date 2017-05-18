FROM prisms/gateway-base
LABEL maintainer "Philip Lundrigan <philipbl@cs.utah.edu>"

VOLUME /data

# Install Home Assistant
RUN pip install homeassistant==0.40.2

# Install custom components
RUN git clone https://github.com/VDL-PRISM/home-assistant-components.git && \
    cd home-assistant-components && \
    git checkout tags/v0.1.0 && \
    pip install --no-cache-dir -r requirements.txt

# Switch on systemd init system in container
ENV INITSYSTEM on

ENV IMAGE_VERSION 1.0.0

CMD cp -R /home-assistant-components/* /data/custom_components/ && \
    hass -c /data
