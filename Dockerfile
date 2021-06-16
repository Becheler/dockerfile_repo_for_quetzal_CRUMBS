FROM ubuntu:latest

LABEL maintainer="Arnaud Becheler" \
      description="Basic stuff for CircleCi repo." \
      version="0.1.0"
      
ARG DEBIAN_FRONTEND=noninteractive

# Install GDAL dependencies for python
RUN set -xe \
    apt-get update -y \
    apt-get install -y gdal-bin libpq-dev libmysqlclient-dev libgdal-dev --no-install-recommends \
    apt-get clean -y

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Python and pip3
RUN set -xe \
    sudo apt install python3-pip \
    pip3 -v \
    pip3 install --upgrade pip
    
# Pipenv
RUN pip3 install pipenv
ENV PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
ENV PATH="$PATH:$PYTHON_BIN_PATH"
RUN pipenv install numpy GDAL
            
RUN set -xe \ 
    apt-get autoclean && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
