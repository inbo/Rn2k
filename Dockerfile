FROM rocker/r-ver:4.5.1

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Rn2k" \
      org.label-schema.description="A docker image with stable versions of R and a bunch of packages. The full list of packages is available in the README." \
      org.label-schema.url="e.g. https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/inbo/Rn2k" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
      org.opencontainers.image.authors="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

## for apt to be noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && usermod -a -G staff docker

## Install nano
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget


COPY .Rprofile $R_HOME/etc/Rprofile.site

RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
  && apt-get clean

RUN Rscript -e 'install.packages("pak")'

RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    gdal-bin \
    libcurl4-openssl-dev \
    libgdal-dev \
    libgeos-dev \
    libgit2-dev \
    libicu-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    libxml2-dev \
    make \
    unixodbc-dev \
  && apt-get clean

COPY pkg.lock pkg.lock
RUN Rscript -e 'pak::lockfile_install()'

COPY fit_model_aws.R /analysis/fit_model_aws.R
COPY fit_model_aws.sh /analysis/fit_model_aws.sh
COPY fit_model_file.R /analysis/fit_model_file.R
COPY fit_model_file.sh /analysis/fit_model_file.sh

WORKDIR /analysis
CMD ["/bin/bash"]
