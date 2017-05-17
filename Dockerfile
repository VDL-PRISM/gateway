FROM prisms/gateway-base
LABEL maintainer "Philip Lundrigan <philipbl@cs.utah.edu>"

# Set our working directory
WORKDIR /usr/src/app

# # Set up links to openzwave
# RUN ln -sd /usr/local/lib/python3.*/site-packages/python_openzwave/ozw_config

# Install Home Assistant
RUN pip install homeassistant==0.40.2

# Install custom components
RUN git clone https://github.com/VDL-PRISM/home-assistant-components.git && \
    mv home-assistant-components custom_components && \
    cd custom_components && \
    git checkout tags/v0.1.0 && \
    pip3 install --no-cache-dir -r requirements.txt

# This will copy all files in our root to the working directory in the container
COPY . ./

# Switch on systemd init system in container
ENV INITSYSTEM on

CMD ["hass", "-c", "/usr/src/app/"]
