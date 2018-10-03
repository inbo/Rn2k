FROM ubuntu:18.04

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


## script to install specific R package from CRAN
COPY cran_install.sh cran_install.sh

## copy analysis script
COPY analysis.sh analysis.sh
COPY analysis.R analysis.R

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    locales \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

## Add apt-get repositories
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    gnupg \
    ca-certificates \
  && sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list' \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x51716619e084dab9

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \
  && apt-get clean

## Install R base
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    r-base-core=3.5.1-1bionic \
    r-base-dev=3.5.1-1bionic \
    r-cran-boot=1.3-20-1.1cranBionic0 \
    r-cran-class=7.3-14-2cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-cluster=2.0.7-1-1cranBionic0 \
    r-cran-codetools=0.2-15-1.1cranBionic0 \
    r-cran-foreign=0.8.70-1cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-kernsmooth=2.23-15-3cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-lattice=0.20-35-1cranBionic0 \
    r-cran-mass=7.3-50-1bionic0 \
    r-cran-matrix=1.2-14-1cranBionic0 \
    r-cran-mgcv=1.8-24-1bionic0 \
    r-cran-nlme=3.1.137-1cranBionic0 \
    r-cran-nnet=7.3-12-2cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-rpart=4.1-13-1cranBionic0  \
    r-cran-spatial=7.3-11-2cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-survival=2.42-6-1cran1bionic0 \
    r-recommended=3.5.1-1bionic

## Install litter
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    littler=0.3.4-1bionic0 \
  && apt-get clean

## Install devtools and dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev \
    curl \
    git \
    libgit2-dev \
    libssl-dev \
    libssh2-1-dev \
  && apt-get clean \
  && ./cran_install.sh jsonlite 1.5 \
  && ./cran_install.sh mime 0.5 \
  && ./cran_install.sh curl 3.2 \
  && ./cran_install.sh digest 0.6.16 \
  && ./cran_install.sh R6 2.2.2 \
  && ./cran_install.sh magrittr 1.5 \
  && ./cran_install.sh stringi 1.2.4 \
  && ./cran_install.sh glue 1.3.0 \
  && ./cran_install.sh stringr 1.3.1 \
  && ./cran_install.sh openssl 1.0.2 \
  && ./cran_install.sh httr 1.3.1 \
  && ./cran_install.sh git2r 0.23.0  \
  && ./cran_install.sh memoise 1.1.0 \
  && ./cran_install.sh whisker 0.3-2 \
  && ./cran_install.sh rstudioapi 0.7 \
  && ./cran_install.sh withr 2.1.2 \
  && ./cran_install.sh devtools 1.13.6

## Install assertthat
RUN  ./cran_install.sh assertthat 0.2.0

## Install dplyr and dependencies
RUN  ./cran_install.sh Rcpp 0.12.18 \
  && ./cran_install.sh lazyeval 0.2.1 \
  && ./cran_install.sh DBI 1.0.0 \
  && ./cran_install.sh BH 1.66.0-1 \
  && ./cran_install.sh rlang 0.2.2 \
  && ./cran_install.sh crayon 1.3.4 \
  && ./cran_install.sh cli 1.0.0 \
  && ./cran_install.sh utf8 1.1.4 \
  && ./cran_install.sh fansi 0.3.0 \
  && ./cran_install.sh pillar 1.3.0 \
  && ./cran_install.sh tibble 1.4.2 \
  && ./cran_install.sh plogr 0.2.0 \
  && ./cran_install.sh bindr 0.1.1 \
  && ./cran_install.sh pkgconfig 2.0.2 \
  && ./cran_install.sh bindrcpp 0.2.2 \
  && ./cran_install.sh purrr 0.2.5 \
  && ./cran_install.sh tidyselect 0.2.4 \
  && ./cran_install.sh dplyr 0.7.6

## Install plyr
RUN  ./cran_install.sh plyr 1.8.4

## Install lubridate
RUN  ./cran_install.sh lubridate 1.7.4

## Install freetds
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    freetds-dev \
    freetds-bin \
    tdsodbc \
  && apt-get clean

## Install RODBC and dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    pkg-config \
    libltdl7 \
    libodbc1 \
    unixodbc-dev \
  && apt-get clean \
  && ./cran_install.sh RODBC 1.3-15

## Install xtable
RUN  ./cran_install.sh xtable 1.8-3

## Install igraph and its dependencies
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libxml2-dev \
  && ./cran_install.sh registry 0.5 \
  && ./cran_install.sh bibtex 0.4.2 \
  && ./cran_install.sh pkgmaker 0.27 \
  && ./cran_install.sh rngtools 1.3.1 \
  && ./cran_install.sh gridBase 0.4-7 \
  && ./cran_install.sh iterators 1.0.10 \
  && ./cran_install.sh foreach 1.4.4 \
  && ./cran_install.sh doParallel 1.0.11 \
  && ./cran_install.sh NMF 0.21.0 \
  && ./cran_install.sh irlba 2.3.2 \
  && ./cran_install.sh igraph 1.2.2

## install sp
RUN  ./cran_install.sh sp 1.3-1

## install tidyr
RUN  ./cran_install.sh tidyr 0.8.1

## install lme4
RUN  ./cran_install.sh minqa 1.2.4 \
  && ./cran_install.sh nloptr 1.0.4 \
  && ./cran_install.sh RcppEigen 0.3.3.4.0 \
  && ./cran_install.sh lme4 1.1-18-1

## install optimx and dependencies
RUN  ./cran_install.sh numDeriv 2016.8-1 \
  && ./cran_install.sh optextras 2016-8.8 \
  && ./cran_install.sh Rvmmin 2018-4.17 \
  && ./cran_install.sh Rcgmin 2013-2.21 \
  && ./cran_install.sh quadprog 1.5-5 \
  && ./cran_install.sh BB 2014.10-1 \
  && ./cran_install.sh ucminf 1.1-4 \
  && ./cran_install.sh setRNG 2013.9-1 \
  && ./cran_install.sh dfoptim 2018.2-1 \
  && ./cran_install.sh svUnit 0.7-12 \
  && ./cran_install.sh optimx 2013.8.7

## install INLA
RUN  ./cran_install.sh MatrixModels 0.4-1 \
  && wget https://github.com/inbo/INLA/archive/v18.07.12.tar.gz \
  && R CMD INSTALL v18.07.12.tar.gz \
  && rm v18.07.12.tar.gz

## install mvtnorm
RUN  ./cran_install.sh mvtnorm 1.0-8

## install multimput
RUN wget https://github.com/inbo/multimput/archive/v0.2.8.1.tar.gz \
  && R CMD INSTALL v0.2.8.1.tar.gz \
  && rm v0.2.8.1.tar.gz

## install aws.s3
RUN  ./cran_install.sh base64enc 0.1-3 \
  && ./cran_install.sh xml2 1.2.0 \
  && ./cran_install.sh aws.signature 0.4.4 \
  && ./cran_install.sh aws.s3 0.3.12

## install RPostgreSQL
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libpq-dev \
  && ./cran_install.sh RPostgreSQL 0.6-2

## install dbplyr
RUN  ./cran_install.sh dbplyr 1.2.2

## install profvis
RUN  ./cran_install.sh yaml 2.2.0 \
  && ./cran_install.sh htmltools 0.3.6 \
  && ./cran_install.sh htmlwidgets 1.2 \
  && ./cran_install.sh profvis 0.3.5

CMD ["/bin/bash"]
