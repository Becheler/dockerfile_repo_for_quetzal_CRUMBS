FROM ubuntu:focal

LABEL maintainer="Arnaud Becheler" \
      description="Basic things for quetzal-CRUMBS CircleCI repository." \
      version="0.1.0"

ARG DEBIAN_FRONTEND=noninteractive

# Install GDAL dependencies for python
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntugis/ppa
RUN set -xe \
    apt-get update && apt-get install -y \
    gdal-bin \
    libpq-dev \
    libmysqlclient-dev \
    libgdal-dev \
    --no-install-recommends

# Update environment variables so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Python
RUN set -xe \
    apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    python3.8-venv \
    --no-install-recommends

RUN pip3 install --upgrade pip
RUN pip3 install build twine pipenv numpy

ENV PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
ENV PATH="$PATH:$PYTHON_BIN_PATH"

RUN pip3 install GDAL==$(gdal-config --version) pyvolve==1.0.3 rasterio matplotlib imageio imageio-ffmpeg

RUN set -xe \
    apt-get autoclean && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
