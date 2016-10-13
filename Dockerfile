FROM quay.io/keboola/docker-base-r-packages:3.2.1-d
MAINTAINER Ondrej Popelka <ondrej.popelka@keboola.com>

ENV DOCKER_CUSTOM_VERSION 0.0.1
WORKDIR /home

COPY . /home/

# Install some commonly used R packages 
RUN Rscript ./init.R

ENTRYPOINT Rscript ./main.R