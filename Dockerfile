FROM quay.io/keboola/docker-base-r-packages:3.2.5-e

# Install prerequisites
RUN yum -y update \
	&& yum -y install \
    ca-certificates \
    file \
    git \
    libapparmor1 \
    libedit2 \
    libcurl4-openssl-dev \
    libssl1.0.0 \
    libssl-dev \
    psmisc \
    python-setuptools \
    sudo \
    wget \
	&& yum clean all

WORKDIR /code

COPY . /code/

RUN R CMD javareconf

# Install some commonly used R packages 
RUN Rscript /code/docker/init.R

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/centos5.9/x86_64/VERSION -O "version.txt" && \
    VER=$(cat version.txt)  && \
    wget --no-verbose -q https://download3.rstudio.org/centos5.9/x86_64/shiny-server-${VER}-rh5-x86_64.rpm && \
    yum -y install --nogpgcheck shiny-server-${VER}-rh5-x86_64.rpm && \
    yum clean all && \
    rm -f version.txt shiny-server-${VER}-rh5-x86_64.rpm

## Use s6
RUN wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

EXPOSE 3838

COPY docker/shiny-server.sh /usr/bin/shiny-server.sh

RUN chmod u+x /usr/bin/shiny-server.sh

CMD ["/init"]