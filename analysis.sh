#!/bin/bash
FIRST="devtools::install_github(\""
LAST="\", dependencies = FALSE, upgrade_dependencies = FALSE)"
while getopts b:g:m:p: option; do
 case $option in
 b)
  BUCKET=${OPTARG}
  ;;
 g)
  echo installing ${OPTARG}
  r -e "${FIRST}${OPTARG}${LAST}"
  echo ${OPTARG} installed
  ;;
 m)
  MANIFEST=${OPTARG}
  ;;
 p)
  PROJECT=${OPTARG}
  ;;
 esac
done

./analysis.R $BUCKET $PROJECT $MANIFEST
