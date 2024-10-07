docker build --pull --no-cache --rm --tag inbobmk/r2nk:dev-0.10 .
docker build --pull --rm --tag inbobmk/r2nk:dev-0.10 .
docker build --pull --rm --progress=plain --tag inbobmk/r2nk:dev-0.10 .
docker login
docker push inbobmk/r2nk:dev-0.10

