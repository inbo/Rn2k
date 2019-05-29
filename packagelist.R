tmp <- installed.packages()[, c("Version", "Priority")]
rec <- subset(tmp, tmp[, "Priority"] == "recommended")
rec <- rec[order(rownames(rec)), ]
other <- subset(tmp, is.na(tmp[, "Priority"]))
other <- other[order(rownames(other)), ]
tmp2 <- rbind(
  Ubuntu = gsub("Ubuntu ", "", sessionInfo()$running),
  R = c(paste(version$major, version$minor, sep = ".")),
  rec,
  other
)
cat("\n\n", sprintf("\n| %18s | %15s |", rownames(tmp2), tmp2[, "Version"]), "\n\n")
