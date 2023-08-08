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

COPY .Rprofile $R_HOME/etc/Rprofile.site

RUN Rscript -e 'install.packages("remotes")'

# packages start
RUN Rscript -e 'remotes::install_version("cli", version = "3.6.1")'
RUN Rscript -e 'remotes::install_version("glue", version = "1.6.2")'
RUN Rscript -e 'remotes::install_version("rlang", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("MASS", version = "7.3-60")'
RUN Rscript -e 'remotes::install_version("lifecycle", version = "1.0.3")'
RUN Rscript -e 'remotes::install_version("class", version = "7.3-22")'
RUN Rscript -e 'remotes::install_version("fansi", version = "1.0.4")'
RUN Rscript -e 'remotes::install_version("proxy", version = "0.4-27")'
RUN Rscript -e 'remotes::install_version("utf8", version = "1.2.3")'
RUN Rscript -e 'remotes::install_version("vctrs", version = "0.6.3")'
RUN Rscript -e 'remotes::install_version("KernSmooth", version = "2.23-22")'
RUN Rscript -e 'remotes::install_version("Rcpp", version = "1.0.11")'
RUN Rscript -e 'remotes::install_version("e1071", version = "1.7-13")'
RUN Rscript -e 'remotes::install_version("lattice", version = "0.21-8")'
RUN Rscript -e 'remotes::install_version("magrittr", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("pillar", version = "1.9.0")'
RUN Rscript -e 'remotes::install_version("pkgconfig", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("sys", version = "3.4.2")'
RUN Rscript -e 'remotes::install_version("withr", version = "2.5.0")'
RUN Rscript -e 'remotes::install_version("wk", version = "0.7.3")'
RUN Rscript -e 'remotes::install_version("DBI", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("Matrix", version = "1.6-0")'
RUN Rscript -e 'remotes::install_version("R6", version = "2.5.1")'
RUN Rscript -e 'remotes::install_version("askpass", version = "1.1")'
RUN Rscript -e 'remotes::install_version("bit", version = "4.0.5")'
RUN Rscript -e 'remotes::install_version("classInt", version = "0.4-9")'
RUN Rscript -e 'remotes::install_version("crayon", version = "1.5.2")'
RUN Rscript -e 'remotes::install_version("generics", version = "0.1.3")'
RUN Rscript -e 'remotes::install_version("ps", version = "1.7.5")'
RUN Rscript -e 'remotes::install_version("rprojroot", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("s2", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("stringi", version = "1.7.12")'
RUN Rscript -e 'remotes::install_version("tibble", version = "3.2.1")'
RUN Rscript -e 'remotes::install_version("tidyselect", version = "1.2.0")'
RUN Rscript -e 'remotes::install_version("units", version = "0.8-2")'
RUN Rscript -e 'remotes::install_version("MatrixModels", version = "0.5-2")'
RUN Rscript -e 'remotes::install_version("SparseM", version = "1.81")'
RUN Rscript -e 'remotes::install_version("base64enc", version = "0.1-3")'
RUN Rscript -e 'remotes::install_version("bit64", version = "4.0.5")'
RUN Rscript -e 'remotes::install_version("blob", version = "1.2.4")'
RUN Rscript -e 'remotes::install_version("boot", version = "1.3-28.1")'
RUN Rscript -e 'remotes::install_version("curl", version = "5.0.1")'
RUN Rscript -e 'remotes::install_version("desc", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("diffobj", version = "0.3.5")'
RUN Rscript -e 'remotes::install_version("digest", version = "0.6.33")'
RUN Rscript -e 'remotes::install_version("dplyr", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("fs", version = "1.6.3")'
RUN Rscript -e 'remotes::install_version("hms", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("jsonlite", version = "1.8.7")'
RUN Rscript -e 'remotes::install_version("mime", version = "0.12")'
RUN Rscript -e 'remotes::install_version("minqa", version = "1.2.5")'
RUN Rscript -e 'remotes::install_version("nlme", version = "3.1-162")'
RUN Rscript -e 'remotes::install_version("nloptr", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("openssl", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("plyr", version = "1.8.8")'
RUN Rscript -e 'remotes::install_version("processx", version = "3.8.2")'
RUN Rscript -e 'remotes::install_version("purrr", version = "1.0.1")'
RUN Rscript -e 'remotes::install_version("rematch2", version = "2.1.2")'
RUN Rscript -e 'remotes::install_version("sf", version = "1.0-14")'
RUN Rscript -e 'remotes::install_version("sp", version = "2.0-0")'
RUN Rscript -e 'remotes::install_version("stringr", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("survival", version = "3.5-5")'
RUN Rscript -e 'remotes::install_version("terra", version = "1.7-39")'
RUN Rscript -e 'remotes::install_version("timechange", version = "0.2.0")'
RUN Rscript -e 'remotes::install_version("RODBC", version = "1.3-20")'
RUN Rscript -e 'remotes::install_version("RPostgreSQL", version = "0.7-5")'
RUN Rscript -e 'remotes::install_version("assertthat", version = "0.2.1")'
RUN Rscript -e 'remotes::install_version("aws.signature", version = "0.6.0")'
RUN Rscript -e 'remotes::install_version("brio", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("callr", version = "3.7.3")'
RUN Rscript -e 'remotes::install_version("ellipsis", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("evaluate", version = "0.21")'
RUN Rscript -e 'remotes::install_version("git2r", version = "0.32.0")'
RUN Rscript -e 'remotes::install_version("httr", version = "1.4.6")'
RUN Rscript -e 'remotes::install_version("inlabru", version = "2.8.0")'
RUN Rscript -e 'remotes::install_version("lazyeval", version = "0.2.2")'
RUN Rscript -e 'remotes::install_version("lme4", version = "1.1-34")'
RUN Rscript -e 'remotes::install_version("lubridate", version = "1.9.2.9000")'
RUN Rscript -e 'remotes::install_version("mnormt", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("mvtnorm", version = "1.2-2")'
RUN Rscript -e 'remotes::install_version("numDeriv", version = "2016.8-1.1")'
RUN Rscript -e 'remotes::install_version("odbc", version = "1.3.5")'
RUN Rscript -e 'remotes::install_version("pkgload", version = "1.3.2.1")'
RUN Rscript -e 'remotes::install_version("praise", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("quantreg", version = "5.96")'
RUN Rscript -e 'remotes::install_version("tidyr", version = "1.3.0")'
RUN Rscript -e 'remotes::install_version("waldo", version = "0.5.1")'
RUN Rscript -e 'remotes::install_version("xml2", version = "1.3.5")'
RUN Rscript -e 'remotes::install_version("INLA", version = "23.06.29")'
RUN Rscript -e 'remotes::install_version("aws.s3", version = "0.3.21")'
RUN Rscript -e 'remotes::install_version("littler", version = "0.3.18")'
RUN Rscript -e 'remotes::install_version("multimput", version = "0.2.12")'
RUN Rscript -e 'remotes::install_version("n2khelper", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("sn", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("testthat", version = "3.1.10")'
RUN Rscript -e 'remotes::install_version("yaml", version = "2.3.7")'
RUN Rscript -e 'remotes::install_version("n2kanalysis", version = "0.3.1")'
# packages end

COPY fit_model* /analysis/

WORKDIR /analysis
CMD ["/bin/bash"]
