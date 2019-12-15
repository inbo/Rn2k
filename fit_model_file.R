#!/usr/bin/env r

library(n2kanalysis)
cat(argv, sep = "\n")
fit_model(base = argv[1], x = argv[3], project = argv[2])
