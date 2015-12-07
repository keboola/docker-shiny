FROM quay.io/keboola/docker-custom-r
MAINTAINER Ondrej Popelka <ondrej.popelka@keboola.com>

ENV DOCKER_CUSTOM_VERSION 0.0.1
WORKDIR /tmp

COPY init.R /tmp/init.R

# Install some commonly used R packages 
RUN Rscript /tmp/init.R
