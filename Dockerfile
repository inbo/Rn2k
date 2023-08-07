FROM rocker/r-ver:4.3.1

## This handle reaches Thierry
MAINTAINER "Thierry Onkelinx" thierry.onkelinx@inbo.be

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Rn2k" \
      org.label-schema.description="A docker image with stable versions of R and a bunch of packages. The full list of packages is available in the README." \
      org.label-schema.url="e.g. https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/inbo/Rn2k" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
      maintainer="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

## Install nano
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget

RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    freetds-dev \
    freetds-bin \
    iproute2 \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfribidi-dev \
    libgdal-dev \
    libgeos-dev \
    libharfbuzz-dev \
    libltdl7 \
    libodbc1 \
    libpq-dev \
    libproj-dev \
    libssl-dev \
    libudunits2-dev \
    libxml2-dev \
    pkg-config \
    tdsodbc \
    unixodbc-dev \
    zlib1g-dev \
  && apt-get clean

RUN  Rscript -e 'install.packages("renv")' \
  && mkdir /analysis \
  && cd /analysis \
  && Rscript -e 'renv::init()'

COPY .Rprofile $R_HOME/etc/Rprofile.site
COPY renv.lock /analysis/renv.lock
COPY renv/activate.R /analysis/renv/activate.R

RUN  cd /analysis \
  && Rscript -e 'renv::restore(prompt = FALSE)'

COPY fit_model* /analysis/

WORKDIR /analysis
CMD ["/bin/bash"]
