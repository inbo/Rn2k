#!/bin/bash
function exit_script(){
  echo "Caught SIGTERM"
  exit 0
}

trap exit_script SIGTERM

FIRST="remotes::install_github(\""
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
  MODEL=${OPTARG}
  ;;
 p)
  PROJECT=${OPTARG}
  ;;
 t)
  echo limiting network bandwith
  tc qdisc add dev eth0 root tbf rate 10mbit burst 64kbit latency 50ms
  ;;
 esac
done

./fit_model_aws.R $BUCKET $PROJECT $MODEL &
wait
