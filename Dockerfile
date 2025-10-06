FROM rhub/r-minimal:4.5.1-patched

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

## Install nano and wget
RUN apk add nano wget

RUN installr -d -t "libgit2 libssh2 openssl-dev" git2r

RUN installr -d -t "libxml2-dev" xml2

COPY .Rprofile .Rprofile
COPY renv renv
COPY renv.lock .
RUN installr -d -e \
  -t "cmake gdal-dev geos-dev gfortran icu-data-full libgit2 libssh2 libxml2-dev linux-headers openssl-dev postgresql-dev proj-dev sqlite-dev udunits-dev unixodbc-dev" \
	-a "libssl3 proj gdal geos expat udunits"

COPY fit_model_aws.R /analysis/fit_model_aws.R
COPY fit_model_aws.sh /analysis/fit_model_aws.sh
COPY fit_model_file.R /analysis/fit_model_file.R
COPY fit_model_file.sh /analysis/fit_model_file.sh

WORKDIR /analysis

CMD [ "sh" ]
