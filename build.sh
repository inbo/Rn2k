docker build --pull --no-cache --rm --tag inbobmk/rn2k:dev-0.10 .
docker build --pull --rm --tag inbobmk/rn2k:dev-0.10 .
docker build --pull --rm --progress=plain --tag inbobmk/rn2k:dev-0.10 .
docker login
docker push inbobmk/rn2k:dev-0.10

docker run -it --rm inbobmk/rn2k:dev-0.10

docker run -v /home/ssm-user/batanalysis:/n2kanalysis/batanalysis:rw -it --rm inbobmk/rn2k:dev-0.10
