FIRST='devtools::install_github("'
LAST='", dependencies = FALSE, upgrade_dependencies = FALSE)'
while getopts b:g:h:p: option
do
 case "${option}"
 in
 b) BUCKET=${OPTARG};;
 h) HASH=${OPTARG};;
 g) Rscript -e $FIRST${OPTARG}$LAST;;
 p) PROJECT=${OPTARG};;
 esac
done

Rscript 'analysis.R' $BUCKET $PROJECT $HASH
