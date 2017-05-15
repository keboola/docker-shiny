FROM quay.io/keboola/docker-base-r-packages:3.2.1-k
MAINTAINER Ondrej Popelka <ondrej.popelka@keboola.com>

ENV DOCKER_CUSTOM_VERSION 0.0.1
WORKDIR /tmp

COPY init.R /tmp/

# Install some commonly used R packages 
RUN Rscript /tmp/init.R

