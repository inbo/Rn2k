#!/usr/bin/env r

cat("\n")
y <- as.list(gsub("--(.*)=(.*)", "\\2", argv))
names(y) <- gsub("--(.*)=(.*)", "\\1", argv)
library(n2kanalysis)
p <- profvis::profvis({
  do.call(
    function(bucket, project, x, timeout) {
      if (missing(timeout)) {
        fit_model(bucket = bucket, x = x, project = project)
      } else {
        fit_model(
          bucket = bucket,
          x = x,
          project = project,
          timeout = as.integer(timeout)
        )
      }
    },
    y
  )
})
aws.s3::s3saveRDS(
  p,
  object = sprintf("%s/profile/%s", y[["project"]], gsub("manifest", "rds", y[["x"]])),
  bucket = y[["bucket"]]
)
