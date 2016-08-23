FROM ubuntu:16.04

## This handle reaches Thierry
MAINTAINER "Thierry Onkelinx" thierry.onkelinx@inbo.be

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

## Add apt-get repositories
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list' \
  && gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \
  && gpg -a --export E084DAB9 | apt-key add -

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \
  && apt-get clean

## Install R base
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    r-base-core=3.3.0-1xenial0 \
    r-base-dev=3.3.0-1xenial0 \
    r-cran-boot=1.3-18-1cran1xenial0 \
    r-cran-class=7.3-14-1xenial0 \
    r-cran-cluster=2.0.4-1xenial0 \
    r-cran-codetools=0.2-14-1 \
    r-cran-foreign=0.8.66-1xenial0 \
    r-cran-mass=7.3-45-1xenial0 \
    r-cran-kernsmooth=2.23-15-1 \
    r-cran-lattice=0.20-33-1 \
    r-cran-matrix=1.2-6-1xenial0 \
    r-cran-mgcv=1.8-12-1cran1xenial0 \
    r-cran-nnet=7.3-12-1xenial0 \
    r-cran-nlme=3.1.127-1xenial0 \
    r-cran-rpart=4.1-10-1 \
    r-cran-spatial=7.3-11-1xenial0 \
    r-cran-survival=2.39-2-1cran1xenial0 \
    r-recommended=3.3.0-1xenial0 \
  && apt-get clean

## Install devtools and dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    git \
    libssl-dev \
    libssh2-1-dev \
  && apt-get clean \
  && wget https://cran.rstudio.com/src/contrib/Archive/jsonlite/jsonlite_0.9.19.tar.gz \
  && R CMD INSTALL jsonlite_0.9.19.tar.gz \
  && rm jsonlite_0.9.19.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/mime/mime_0.4.tar.gz \
  && R CMD INSTALL mime_0.4.tar.gz \
  && rm mime_0.4.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/curl/curl_0.9.7.tar.gz \
  && R CMD INSTALL curl_0.9.7.tar.gz \
  && rm curl_0.9.7.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/digest/digest_0.6.9.tar.gz \
  && R CMD INSTALL digest_0.6.9.tar.gz \
  && rm digest_0.6.9.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/R6_2.1.2.tar.gz \
  && R CMD INSTALL R6_2.1.2.tar.gz \
  && rm R6_2.1.2.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/magrittr_1.5.tar.gz \
  && R CMD INSTALL magrittr_1.5.tar.gz \
  && rm magrittr_1.5.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/stringi/stringi_1.0-1.tar.gz \
  && R CMD INSTALL stringi_1.0-1.tar.gz \
  && rm stringi_1.0-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/stringr/stringr_1.0.0.tar.gz \
  && R CMD INSTALL stringr_1.0.0.tar.gz \
  && rm stringr_1.0.0.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/openssl/openssl_0.9.3.tar.gz \
  && R CMD INSTALL openssl_0.9.3.tar.gz \
  && rm openssl_0.9.3.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/httr/httr_1.1.0.tar.gz \
  && R CMD INSTALL httr_1.1.0.tar.gz \
  && rm httr_1.1.0.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/git2r/git2r_0.14.0.tar.gz \
  && R CMD INSTALL git2r_0.14.0.tar.gz  \
  && rm git2r_0.14.0.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/memoise_1.0.0.tar.gz \
  && R CMD INSTALL memoise_1.0.0.tar.gz \
  && rm memoise_1.0.0.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/whisker_0.3-2.tar.gz \
  && R CMD INSTALL whisker_0.3-2.tar.gz \
  && rm whisker_0.3-2.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/rstudioapi/rstudioapi_0.5.tar.gz \
  && R CMD INSTALL rstudioapi_0.5.tar.gz \
  && rm rstudioapi_0.5.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/withr/withr_1.0.1.tar.gz \
  && R CMD INSTALL withr_1.0.1.tar.gz \
  && rm withr_1.0.1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/devtools/devtools_1.11.1.tar.gz \
  && R CMD INSTALL devtools_1.11.1.tar.gz \
  && rm devtools_1.11.1.tar.gz

## Install digest 0.6.9.3 from Github
RUN Rscript -e 'devtools::install_github("eddelbuettel/digest", ref = "fcbb3315450b9c1bf7121efd69bec605ce57fb51", upgrade_dependencies = FALSE)'

## Install assertthat
RUN wget https://cran.rstudio.com/src/contrib/assertthat_0.1.tar.gz \
  && R CMD INSTALL assertthat_0.1.tar.gz \
  && rm assertthat_0.1.tar.gz

## Install dplyr and dependencies
RUN wget https://cran.rstudio.com/src/contrib/Archive/Rcpp/Rcpp_0.12.4.tar.gz \
  && R CMD INSTALL Rcpp_0.12.4.tar.gz \
  && rm Rcpp_0.12.4.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/lazyeval/lazyeval_0.1.10.tar.gz\
  && R CMD INSTALL lazyeval_0.1.10.tar.gz \
  && rm lazyeval_0.1.10.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/DBI/DBI_0.4-1.tar.gz \
  && R CMD INSTALL DBI_0.4-1.tar.gz \
  && rm DBI_0.4-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/BH_1.60.0-2.tar.gz \
  && R CMD INSTALL BH_1.60.0-2.tar.gz \
  && rm BH_1.60.0-2.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/dplyr/dplyr_0.4.3.tar.gz \
  && R CMD INSTALL dplyr_0.4.3.tar.gz \
  && rm dplyr_0.4.3.tar.gz

## Install plyr
RUN wget https://cran.rstudio.com/src/contrib/Archive/plyr/plyr_1.8.3.tar.gz \
  && R CMD INSTALL plyr_1.8.3.tar.gz \
  && rm plyr_1.8.3.tar.gz

## Install lubridate
RUN wget https://cran.rstudio.com/src/contrib/lubridate_1.5.6.tar.gz \
  && R CMD INSTALL lubridate_1.5.6.tar.gz \
  && rm lubridate_1.5.6.tar.gz

## Install RODBC and dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    pkg-config \
    libltdl7 \
    libodbc1 \
    unixodbc-dev \
  && apt-get clean \
  && wget https://cran.rstudio.com/src/contrib/RODBC_1.3-13.tar.gz \
  && R CMD INSTALL RODBC_1.3-13.tar.gz \
  && rm RODBC_1.3-13.tar.gz

## Install testthat and dependencies
RUN wget https://cran.rstudio.com/src/contrib/Archive/crayon/crayon_1.3.1.tar.gz \
  && R CMD INSTALL crayon_1.3.1.tar.gz \
  && rm crayon_1.3.1.tar.gz \
  && wget https://github.com/cran/praise/archive/1.0.0.tar.gz \
  && R CMD INSTALL 1.0.0.tar.gz \
  && rm 1.0.0.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/testthat_1.0.2.tar.gz \
  && R CMD INSTALL testthat_1.0.2.tar.gz \
  && rm testthat_1.0.2.tar.gz

## install sp
RUN wget https://cran.rstudio.com/src/contrib/sp_1.2-3.tar.gz \
  && R CMD INSTALL sp_1.2-3.tar.gz \
  && rm sp_1.2-3.tar.gz

## install tidyr
RUN wget https://github.com/cran/tidyr/archive/0.4.1.tar.gz \
  && R CMD INSTALL 0.4.1.tar.gz \
  && rm 0.4.1.tar.gz

## install lme4
RUN wget https://github.com/cran/minqa/archive/1.2.4.tar.gz \
  && R CMD INSTALL 1.2.4.tar.gz \
  && rm 1.2.4.tar.gz \
  && wget https://github.com/cran/nloptr/archive/1.0.4.tar.gz \
  && R CMD INSTALL 1.0.4.tar.gz \
  && rm 1.0.4.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/RcppEigen_0.3.2.8.1.tar.gz \
  && R CMD INSTALL RcppEigen_0.3.2.8.1.tar.gz \
  && rm RcppEigen_0.3.2.8.1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/lme4_1.1-12.tar.gz \
  && R CMD INSTALL lme4_1.1-12.tar.gz \
  && rm lme4_1.1-12.tar.gz

## install optimx and dependencies
RUN wget https://github.com/cran/numDeriv/archive/2014.2-1.tar.gz \
  && R CMD INSTALL 2014.2-1.tar.gz \
  && rm 2014.2-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/optextras/optextras_2013-10.28.tar.gz \
  && R CMD INSTALL optextras_2013-10.28.tar.gz \
  && rm optextras_2013-10.28.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Rvmmin_2013-11.12.tar.gz \
  && R CMD INSTALL Rvmmin_2013-11.12.tar.gz \
  && rm Rvmmin_2013-11.12.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Rcgmin_2013-2.21.tar.gz \
  && R CMD INSTALL Rcgmin_2013-2.21.tar.gz \
  && rm Rcgmin_2013-2.21.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/quadprog_1.5-5.tar.gz \
  && R CMD INSTALL quadprog_1.5-5.tar.gz \
  && rm quadprog_1.5-5.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/BB_2014.10-1.tar.gz \
  && R CMD INSTALL BB_2014.10-1.tar.gz \
  && rm BB_2014.10-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/ucminf_1.1-3.tar.gz \
  && R CMD INSTALL ucminf_1.1-3.tar.gz \
  && rm ucminf_1.1-3.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/setRNG_2013.9-1.tar.gz \
  && R CMD INSTALL setRNG_2013.9-1.tar.gz \
  && rm setRNG_2013.9-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/Archive/dfoptim/dfoptim_2011.8-1.tar.gz \
  && R CMD INSTALL dfoptim_2011.8-1.tar.gz \
  && rm dfoptim_2011.8-1.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/svUnit_0.7-12.tar.gz \
  && R CMD INSTALL svUnit_0.7-12.tar.gz \
  && rm svUnit_0.7-12.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/optimx_2013.8.7.tar.gz \
  && R CMD INSTALL optimx_2013.8.7.tar.gz \
  && rm optimx_2013.8.7.tar.gz

## install INLA
RUN wget https://github.com/inbo/INLA/archive/v0.0-1455098891.tar.gz \
  && R CMD INSTALL v0.0-1455098891.tar.gz \
  && rm v0.0-1455098891.tar.gz

## install RSQLite
RUN wget https://github.com/cran/RSQLite/archive/1.0.0.tar.gz \
  && R CMD INSTALL 1.0.0.tar.gz \
  && rm 1.0.0.tar.gz

## install rmvtnorm
RUN wget https://cran.rstudio.com/src/contrib/mvtnorm_1.0-5.tar.gz \
  && R CMD INSTALL mvtnorm_1.0-5.tar.gz \
  && rm mvtnorm_1.0-5.tar.gz

## install roxygen2 and dependencies
RUN wget https://github.com/cran/brew/archive/1.0-6.tar.gz \
  && R CMD INSTALL 1.0-6.tar.gz \
  && rm 1.0-6.tar.gz \
  && wget https://cran.rstudio.com/src/contrib/roxygen2_5.0.1.tar.gz \
  && R CMD INSTALL roxygen2_5.0.1.tar.gz \
  && rm roxygen2_5.0.1.tar.gz
