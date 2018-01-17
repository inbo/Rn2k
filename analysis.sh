#!/bin/bash
FIRST="devtools::install_github(\""
LAST="\", dependencies = FALSE, upgrade_dependencies = FALSE)"
while getopts b:g:m:p:t: option; do
 case $option in
 b)
  BUCKET="--bucket=${OPTARG}"
  ;;
 g)
  echo installing ${OPTARG}
  r -e "${FIRST}${OPTARG}${LAST}"
  echo ${OPTARG} installed
  ;;
 m)
  MANIFEST="--x=${OPTARG}"
  ;;
 p)
  PROJECT="--project=${OPTARG}"
  ;;
 t)
  TIMEOUT="--timeout=${OPTARG}"
  ;;
 esac
done

./analysis.R $BUCKET $PROJECT $MANIFEST $TIMEOUT
