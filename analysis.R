#!/usr/bin/env r

library(n2kanalysis)
cat(argv, sep = "\n")
p <- profvis::profvis({
  fit_model(bucket = argv[1], x = argv[3], project = argv[2])
})
aws.s3::s3write_using(
  x = p,
  FUN = htmlwidgets::saveWidget,
  object = sprintf("%s/profile/%s.html", argv[2], argv[3]),
  bucket = argv[1]
)
