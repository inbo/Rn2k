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
  && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget

## Install R base
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    r-base-core=3.6.1-3bionic \
    r-base-dev=3.6.1-3bionic \
    r-cran-boot=1.3-23-2bionic0 \
    r-cran-class=7.3-15-1bionic0 \
    r-cran-cluster=2.1.0-2bionic0 \
    r-cran-codetools=0.2-16-1bionic0 \
    r-cran-foreign=0.8.72-1bionic0 \
    r-cran-kernsmooth=2.23-16-1+1bionic0 \
    r-cran-lattice=0.20-38-1cran1bionic0 \
    r-cran-mass=7.3-51.4-2bionic0 \
    r-cran-matrix=1.2-18-1bionic0 \
    r-cran-mgcv=1.8-31-1cran1bionic0 \
    r-cran-nlme=3.1.142-1bionic0 \
    r-cran-nnet=7.3-12-2cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-rpart=4.1-15-2bionic0 \
    r-cran-spatial=7.3-11-2cranArtful0~ubuntu18.04.1~ppa1 \
    r-cran-survival=2.44-1.1-2bionic0 \
    r-recommended=3.6.1-3bionic

## Install litter
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    littler=0.3.9-1bionic0

## Install assertthat from CRAN
RUN ./cran_install.sh assertthat 0.2.1

## Install digest from CRAN
RUN ./cran_install.sh digest 0.6.23

## Install xtable from CRAN
RUN ./cran_install.sh xtable 1.8-4

## Install shiny from CRAN
RUN ./cran_install.sh BH 1.69.0-1 \
 && ./cran_install.sh Rcpp 1.0.3 \
 && ./cran_install.sh rlang 0.4.2 \
 && ./cran_install.sh later 1.0.0 \
 && ./cran_install.sh magrittr 1.5 \
 && ./cran_install.sh R6 2.4.1 \
 && ./cran_install.sh promises 1.1.0 \
 && ./cran_install.sh crayon 1.3.4 \
 && ./cran_install.sh fastmap 1.0.1 \
 && ./cran_install.sh htmltools 0.4.0 \
 && ./cran_install.sh httpuv 1.5.2 \
 && ./cran_install.sh jsonlite 1.6 \
 && ./cran_install.sh mime 0.7 \
 && ./cran_install.sh sourcetools 0.1.7 \
 && ./cran_install.sh shiny 1.4.0

## Install git2r apt-get dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    libgit2-dev \
    libssh2-1-dev \
  && apt-get clean

## Install git2r from CRAN
RUN ./cran_install.sh git2r 0.26.1

## Install purrr from CRAN
RUN ./cran_install.sh purrr 0.3.3

## Install yaml from CRAN
RUN ./cran_install.sh yaml 2.2.0

## Install covr apt-get dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev \
    curl \
    libssl-dev \
  && apt-get clean

## Install covr from CRAN
RUN ./cran_install.sh sys 3.3 \
 && ./cran_install.sh askpass 1.1 \
 && ./cran_install.sh curl 4.3 \
 && ./cran_install.sh lazyeval 0.2.2 \
 && ./cran_install.sh openssl 1.4.1 \
 && ./cran_install.sh httr 1.4.1 \
 && ./cran_install.sh rex 1.1.2 \
 && ./cran_install.sh withr 2.1.2 \
 && ./cran_install.sh covr 3.4.0

## Install stringr from CRAN
RUN ./cran_install.sh glue 1.3.1 \
 && ./cran_install.sh stringi 1.4.3 \
 && ./cran_install.sh stringr 1.4.0

## Install tibble from CRAN
RUN ./cran_install.sh backports 1.1.5 \
 && ./cran_install.sh ellipsis 0.3.0 \
 && ./cran_install.sh fansi 0.4.0 \
 && ./cran_install.sh zeallot 0.1.0 \
 && ./cran_install.sh cli 2.0.0 \
 && ./cran_install.sh utf8 1.1.4 \
 && ./cran_install.sh vctrs 0.2.0 \
 && ./cran_install.sh pillar 1.4.2 \
 && ./cran_install.sh pkgconfig 2.0.3 \
 && ./cran_install.sh tibble 2.1.3

## Install ggplot2 from CRAN
RUN ./cran_install.sh colorspace 1.4-1 \
 && ./cran_install.sh farver 2.0.1 \
 && ./cran_install.sh labeling 0.3 \
 && ./cran_install.sh lifecycle 0.1.0 \
 && ./cran_install.sh munsell 0.5.0 \
 && ./cran_install.sh plyr 1.8.5 \
 && ./cran_install.sh RColorBrewer 1.1-2 \
 && ./cran_install.sh viridisLite 0.3.0 \
 && ./cran_install.sh gtable 0.3.0 \
 && ./cran_install.sh reshape2 1.4.3 \
 && ./cran_install.sh scales 1.1.0 \
 && ./cran_install.sh ggplot2 3.2.1

## Install roxygen2 apt-get dependencies
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libxml2-dev

## Install roxygen2 from CRAN
RUN ./cran_install.sh ps 1.3.0 \
 && ./cran_install.sh processx 3.4.1 \
 && ./cran_install.sh rprojroot 1.3-2 \
 && ./cran_install.sh callr 3.4.0 \
 && ./cran_install.sh desc 1.2.0 \
 && ./cran_install.sh prettyunits 1.0.2 \
 && ./cran_install.sh pkgbuild 1.0.6 \
 && ./cran_install.sh rstudioapi 0.10 \
 && ./cran_install.sh brew 1.0-6 \
 && ./cran_install.sh commonmark 1.7 \
 && ./cran_install.sh pkgload 1.0.2 \
 && ./cran_install.sh xml2 1.2.2 \
 && ./cran_install.sh roxygen2 7.0.2

## Install remotes from CRAN
RUN ./cran_install.sh remotes 2.1.0

## Install development version of digest
RUN Rscript -e 'remotes::install_github("eddelbuettel/digest@ee005b8a040b", dependencies = FALSE, upgrade = FALSE, keep_source = FALSE)'

## Install sessioninfo from CRAN
RUN ./cran_install.sh sessioninfo 1.1.1

## Install DT from CRAN
RUN ./cran_install.sh crosstalk 1.0.0 \
 && ./cran_install.sh htmlwidgets 1.5.1 \
 && ./cran_install.sh DT 0.10

## Install testthat from CRAN
RUN ./cran_install.sh evaluate 0.14 \
 && ./cran_install.sh praise 1.0.0 \
 && ./cran_install.sh testthat 2.3.1

## Install devtools from CRAN
RUN ./cran_install.sh ini 0.3.1 \
 && ./cran_install.sh clipr 0.7.0 \
 && ./cran_install.sh clisymbols 1.2.0 \
 && ./cran_install.sh fs 1.3.1 \
 && ./cran_install.sh gh 1.0.1 \
 && ./cran_install.sh whisker 0.4 \
 && ./cran_install.sh xopen 1.0.0 \
 && ./cran_install.sh memoise 1.1.0 \
 && ./cran_install.sh rcmdcheck 1.3.3 \
 && ./cran_install.sh rversions 2.0.1 \
 && ./cran_install.sh usethis 1.5.1 \
 && ./cran_install.sh devtools 2.2.1

## Install dplyr from CRAN
RUN ./cran_install.sh plogr 0.2.0 \
 && ./cran_install.sh tidyselect 0.2.5 \
 && ./cran_install.sh dplyr 0.8.3

## Install lubridate from CRAN
RUN ./cran_install.sh lubridate 1.7.4

## Install freetds apt-get
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    freetds-dev \
    freetds-bin \
    tdsodbc \
  && apt-get clean

## Install RODBC apt-get dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    pkg-config \
    libltdl7 \
    libodbc1 \
    unixodbc-dev \
  && apt-get clean

## Install RODBC from CRAN
RUN ./cran_install.sh RODBC 1.3-16

## Install rmarkdown from CRAN
RUN ./cran_install.sh highr 0.8 \
 && ./cran_install.sh markdown 1.1 \
 && ./cran_install.sh base64enc 0.1-3 \
 && ./cran_install.sh knitr 1.26 \
 && ./cran_install.sh rmarkdown 2.0

## Install igraph from CRAN
RUN ./cran_install.sh igraph 1.2.4.2

## Install lintr from CRAN
RUN ./cran_install.sh cyclocomp 1.1.0 \
 && ./cran_install.sh stringdist 0.9.5.5 \
 && ./cran_install.sh xmlparsedata 1.0.3 \
 && ./cran_install.sh lintr 2.0.0

## Install sp from CRAN
RUN ./cran_install.sh sp 1.3-2

## Install tidyr from CRAN
RUN ./cran_install.sh tidyr 1.0.0

## Install lme4 from CRAN
RUN ./cran_install.sh minqa 1.2.4 \
 && ./cran_install.sh nloptr 1.2.1 \
 && ./cran_install.sh RcppEigen 0.3.3.7.0 \
 && ./cran_install.sh lme4 1.1-21

## Install optimx from CRAN
RUN ./cran_install.sh numDeriv 2016.8-1.1 \
 && ./cran_install.sh optimx 2018-7.10

## Install MatrixModels from CRAN
RUN ./cran_install.sh MatrixModels 0.4-1

## install INLA
RUN  wget https://inla.r-inla-download.org/R/stable/src/contrib/INLA_19.09.03.tar.gz \
  && R CMD INSTALL --clean --no-multiarch --without-keep.source --byte-compile --resave-data --compact-docs --no-demo INLA_19.09.03.tar.gz \
  && rm INLA_19.09.03.tar.gz

## Install RSQLite from CRAN
RUN ./cran_install.sh bit 1.1-14 \
 && ./cran_install.sh bit64 0.9-7 \
 && ./cran_install.sh blob 1.2.0 \
 && ./cran_install.sh DBI 1.0.0 \
 && ./cran_install.sh RSQLite 2.1.4

## Install mvtnorm from CRAN
RUN ./cran_install.sh mvtnorm 1.0-11

## install multimput
RUN Rscript -e 'remotes::install_github("inbo/multimput@v0.2.9", dependencies = FALSE, upgrade = FALSE, keep_source = FALSE)'

## Install aws.s3 from CRAN
RUN ./cran_install.sh aws.signature 0.5.2 \
 && ./cran_install.sh aws.s3 0.3.12

## install RPostgreSQL apt-get dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libpq-dev

## Install RPostgreSQL from CRAN
RUN ./cran_install.sh RPostgreSQL 0.6-2

## Install profvis from CRAN
RUN ./cran_install.sh profvis 0.3.6

## Install git2rdata from CRAN
RUN ./cran_install.sh git2rdata 0.2.0

## Install odbc from CRAN
RUN ./cran_install.sh hms 0.5.2 \
 && ./cran_install.sh odbc 1.2.1

## copy fit single model script
COPY fit_model_aws.sh fit_model_aws.sh
COPY fit_model_aws.R fit_model_aws.R
COPY fit_model_file.sh fit_model_file.sh
COPY fit_model_file.R fit_model_file.R

CMD ["/bin/bash"]
