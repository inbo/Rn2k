FROM rhub/r-minimal:4.5.1-patched

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Rn2k" \
      org.label-schema.description="A docker image with stable versions of R and a bunch of packages. The full list of packages is available in the README." \
      org.label-schema.url="https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inbo/Rn2k" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
      org.opencontainers.image.authors="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# n2kanalysis dependencies on CRAN
RUN installr -p -c -a "gfortran icu-data-full linux-headers postgresql-dev" DBI@1.2.3 KernSmooth@2.23-26 MASS@7.3-65 R6@2.6.1 RODBC@1.3-26 RPostgreSQL@0.7-8 Rcpp@1.1.0 assertthat@0.2.1 base64enc@0.1-3 bit@4.6.0 bit64@4.6.0-1 boot@1.3-32 cli@3.6.5 cpp11@0.5.2 curl@7.0.0 digest@0.6.37 fs@1.6.6 generics@0.1.4 git2r@0.36.2 glue@1.8.0 jsonlite@2.0.0 lattice@0.22-7 lazyeval@0.2.2 magrittr@2.0.4 mime@0.13 mvtnorm@1.3-3 nloptr@2.2.1 pkgconfig@2.0.3 proxy@0.4-27 rbibutils@2.3 rlang@1.1.6 splancs@2.01-45 stringi@1.8.7 sys@3.4.3 timechange@0.3.0 utf8@1.2.6 withr@3.0.2 wk@0.9.4 yaml@2.3.10 Matrix@1.7-4 RcppEigen@0.3.4.0.2 Rdpack@2.6.4 askpass@1.2.1 aws.signature@0.6.0 class@7.3-23 git2rdata@0.5.0 lifecycle@1.0.4 lubridate@1.9.4 minqa@1.2.8 nlme@3.1-168 plyr@1.8.9 s2@1.1.9 sp@2.2-0 units@0.8-7 xml2@1.4.0 MatrixModels@0.5-4 e1071@1.7-16 openssl@2.3.4 reformulas@0.4.1 vctrs@0.6.5 blob@1.2.4 classInt@0.4-11 hms@1.1.3 httr@1.4.7 lme4@1.1-37 pillar@1.11.1 purrr@1.1.0 stringr@1.5.2 tidyselect@1.2.1 aws.s3@0.3.22 odbc@1.6.3 sf@1.0-21 tibble@3.3.0 dplyr@1.1.4 fmesher@0.5.0 tidyr@1.3.1

# sn dependencies
RUN installr -p -c SparseM@1.84-2 mnormt@2.1.1 numDeriv@2016.8-1.1 survival@3.8-3 quantreg@6.1 sn@2.1.1

# n2kanalysis dependencies not on CRAN
RUN installr -p -c INLA@25.06.07
RUN installr -p -c inbo/multimput@v0.2.15
RUN installr -p -c inbo/n2khelper@v0.5.0

RUN installr -p -c inbo/n2kanalysis@v0.4.0

COPY fit_model_aws.R /analysis/fit_model_aws.R
COPY fit_model_aws.sh /analysis/fit_model_aws.sh
COPY fit_model_file.R /analysis/fit_model_file.R
COPY fit_model_file.sh /analysis/fit_model_file.sh

#entrypoint
CMD [ "sh" ]
