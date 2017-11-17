#!/usr/bin/env r

library(n2kanalysis)
cat(argv, sep = "\n")
p <- profvis::profvis({
  fit_model(bucket = argv[1], x = argv[3], project = argv[2])
})
aws.s3::s3saveRDS(
  p,
  object = sprintf("%s/profile/%s", argv[2], gsub("manifest", "rds", argv[3])),
  bucket = argv[1]
)
