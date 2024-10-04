FROM rocker/r-ver:4.4.1

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
RUN Rscript -e 'remotes::install_version("cli", version = "3.6.3")'
RUN Rscript -e 'remotes::install_version("glue", version = "1.8.0")'
RUN Rscript -e 'remotes::install_version("rlang", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("MASS", version = "7.3-61")'
RUN Rscript -e 'remotes::install_version("lifecycle", version = "1.0.4")'
RUN Rscript -e 'remotes::install_version("class", version = "7.3-22")'
RUN Rscript -e 'remotes::install_version("fansi", version = "1.0.6")'
RUN Rscript -e 'remotes::install_version("proxy", version = "0.4-27")'
RUN Rscript -e 'remotes::install_version("utf8", version = "1.2.4")'
RUN Rscript -e 'remotes::install_version("vctrs", version = "0.6.5")'
RUN Rscript -e 'remotes::install_version("KernSmooth", version = "2.23-24")'
RUN Rscript -e 'remotes::install_version("R6", version = "2.5.1")'
RUN Rscript -e 'remotes::install_version("Rcpp", version = "1.0.13")'
RUN Rscript -e 'remotes::install_version("e1071", version = "1.7-16")'
RUN Rscript -e 'remotes::install_version("magrittr", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("pillar", version = "1.9.0")'
RUN Rscript -e 'remotes::install_version("pkgconfig", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("ps", version = "1.8.0")'
RUN Rscript -e 'remotes::install_version("withr", version = "3.0.1")'
RUN Rscript -e 'remotes::install_version("wk", version = "0.9.3")'
RUN Rscript -e 'remotes::install_version("DBI", version = "1.2.3")'
RUN Rscript -e 'remotes::install_version("base64enc", version = "0.1-3")'
RUN Rscript -e 'remotes::install_version("classInt", version = "0.4-10")'
RUN Rscript -e 'remotes::install_version("digest", version = "0.6.37")'
RUN Rscript -e 'remotes::install_version("fastmap", version = "1.2.0")'
RUN Rscript -e 'remotes::install_version("generics", version = "0.1.3")'
RUN Rscript -e 'remotes::install_version("lattice", version = "0.22-6")'
RUN Rscript -e 'remotes::install_version("processx", version = "3.8.4")'
RUN Rscript -e 'remotes::install_version("s2", version = "1.1.7")'
RUN Rscript -e 'remotes::install_version("sys", version = "3.4.3")'
RUN Rscript -e 'remotes::install_version("tibble", version = "3.2.1")'
RUN Rscript -e 'remotes::install_version("tidyselect", version = "1.2.1")'
RUN Rscript -e 'remotes::install_version("units", version = "0.8-5")'
RUN Rscript -e 'remotes::install_version("Matrix", version = "1.7-0")'
RUN Rscript -e 'remotes::install_version("askpass", version = "1.2.1")'
RUN Rscript -e 'remotes::install_version("bit", version = "4.5.0")'
RUN Rscript -e 'remotes::install_version("cachem", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("callr", version = "3.7.6")'
RUN Rscript -e 'remotes::install_version("crayon", version = "1.5.3")'
RUN Rscript -e 'remotes::install_version("desc", version = "1.4.3")'
RUN Rscript -e 'remotes::install_version("dplyr", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("fs", version = "1.6.4")'
RUN Rscript -e 'remotes::install_version("htmltools", version = "0.5.8.1")'
RUN Rscript -e 'remotes::install_version("rappdirs", version = "0.3.3")'
RUN Rscript -e 'remotes::install_version("sf", version = "1.0-17")'
RUN Rscript -e 'remotes::install_version("sp", version = "2.1-4")'
RUN Rscript -e 'remotes::install_version("stringi", version = "1.8.4")'
RUN Rscript -e 'remotes::install_version("xfun", version = "0.48")'
RUN Rscript -e 'remotes::install_version("MatrixModels", version = "0.5-3")'
RUN Rscript -e 'remotes::install_version("SparseM", version = "1.84-2")'
RUN Rscript -e 'remotes::install_version("bit64", version = "4.5.2")'
RUN Rscript -e 'remotes::install_version("blob", version = "1.2.4")'
RUN Rscript -e 'remotes::install_version("boot", version = "1.3-31")'
RUN Rscript -e 'remotes::install_version("curl", version = "5.2.3")'
RUN Rscript -e 'remotes::install_version("diffobj", version = "0.3.5")'
RUN Rscript -e 'remotes::install_version("evaluate", version = "1.0.0.9000")'
RUN Rscript -e 'remotes::install_version("fmesher", version = "0.1.7")'
RUN Rscript -e 'remotes::install_version("highr", version = "0.11")'
RUN Rscript -e 'remotes::install_version("hms", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("jquerylib", version = "0.1.4")'
RUN Rscript -e 'remotes::install_version("jsonlite", version = "1.8.9")'
RUN Rscript -e 'remotes::install_version("memoise", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("mime", version = "0.12")'
RUN Rscript -e 'remotes::install_version("minqa", version = "1.2.8")'
RUN Rscript -e 'remotes::install_version("nlme", version = "3.1-166")'
RUN Rscript -e 'remotes::install_version("nloptr", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("openssl", version = "2.2.2")'
RUN Rscript -e 'remotes::install_version("pkgbuild", version = "1.4.4")'
RUN Rscript -e 'remotes::install_version("purrr", version = "1.0.2")'
RUN Rscript -e 'remotes::install_version("rematch2", version = "2.1.2")'
RUN Rscript -e 'remotes::install_version("rprojroot", version = "2.0.4")'
RUN Rscript -e 'remotes::install_version("sass", version = "0.4.9")'
RUN Rscript -e 'remotes::install_version("stringr", version = "1.5.1")'
RUN Rscript -e 'remotes::install_version("survival", version = "3.7-0")'
RUN Rscript -e 'remotes::install_version("timechange", version = "0.3.0")'
RUN Rscript -e 'remotes::install_version("yaml", version = "2.3.10")'
RUN Rscript -e 'remotes::install_version("INLA", version = "24.06.27")'
RUN Rscript -e 'remotes::install_version("RODBC", version = "1.3-23")'
RUN Rscript -e 'remotes::install_version("RPostgreSQL", version = "0.7-7")'
RUN Rscript -e 'remotes::install_version("assertthat", version = "0.2.1")'
RUN Rscript -e 'remotes::install_version("aws.signature", version = "0.6.0")'
RUN Rscript -e 'remotes::install_version("brio", version = "1.1.5")'
RUN Rscript -e 'remotes::install_version("bslib", version = "0.8.0")'
RUN Rscript -e 'remotes::install_version("fontawesome", version = "0.5.2")'
RUN Rscript -e 'remotes::install_version("git2r", version = "0.33.0.9000")'
RUN Rscript -e 'remotes::install_version("httr", version = "1.4.7")'
RUN Rscript -e 'remotes::install_version("knitr", version = "1.48")'
RUN Rscript -e 'remotes::install_version("lazyeval", version = "0.2.2")'
RUN Rscript -e 'remotes::install_version("lme4", version = "1.1-35.5")'
RUN Rscript -e 'remotes::install_version("lubridate", version = "1.9.3.9000")'
RUN Rscript -e 'remotes::install_version("mnormt", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("mvtnorm", version = "1.3-1")'
RUN Rscript -e 'remotes::install_version("numDeriv", version = "2016.8-1.1")'
RUN Rscript -e 'remotes::install_version("odbc", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("pkgload", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("plyr", version = "1.8.9")'
RUN Rscript -e 'remotes::install_version("praise", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("quantreg", version = "5.98")'
RUN Rscript -e 'remotes::install_version("tidyr", version = "1.3.1")'
RUN Rscript -e 'remotes::install_version("tinytex", version = "0.53")'
RUN Rscript -e 'remotes::install_version("waldo", version = "0.5.3")'
RUN Rscript -e 'remotes::install_version("xml2", version = "1.3.6")'
RUN Rscript -e 'remotes::install_version("aws.s3", version = "0.3.21")'
RUN Rscript -e 'remotes::install_version("multimput", version = "0.2.14")'
RUN Rscript -e 'remotes::install_version("n2khelper", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("rmarkdown", version = "2.28")'
RUN Rscript -e 'remotes::install_version("sn", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("testthat", version = "3.2.1.1")'
RUN Rscript -e 'remotes::install_version("n2kanalysis", version = "0.3.2")'
# packages end

COPY fit_model_aws.R /analysis/fit_model_aws.R
COPY fit_model_aws.sh /analysis/fit_model_aws.sh
COPY fit_model_file.R /analysis/fit_model_file.R
COPY fit_model_file.sh /analysis/fit_model_file.sh

WORKDIR /analysis
CMD ["/bin/bash"]
