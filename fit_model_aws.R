#!/usr/bin/env r

library(n2kanalysis)
fit_model(
  bucket = argv[1], x = argv[3], project = argv[2], local = "/n2kanalysis",
  status = c("new", "waiting", "error")
)
