FROM ubuntu:focal

LABEL maintainer="Arnaud Becheler" \
      description="Basic stuff for CircleCi repo." \
      version="0.1.0"
      
ARG DEBIAN_FRONTEND=noninteractive
     
RUN apt-get update -y

# Install GDAL dependencies for python
RUN apt-get install -y gdal-bin libpq-dev libmysqlclient-dev libgdal-dev --no-install-recommends && apt-get clean -y

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Python
RUN pip install --upgrade pip \
    pip install pipenv numpy GDAL
            
RUN apt-get autoclean && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
