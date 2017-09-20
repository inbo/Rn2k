args <- commandArgs(trailingOnly = TRUE)
n2kanalysis::fit_model(bucket = args[1], x = args[3], project = args[2])
