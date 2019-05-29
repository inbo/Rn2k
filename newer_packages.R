library(tidyverse)
docker <- readLines("Dockerfile")
cran <- grep("cran_install", docker)

data.frame(current = docker[cran]) %>%
  extract(
    "current", c("Command", "Package", "Current", "Suffix"),
    regex =
      "^(.*cran_install.sh) ([a-zA-Z0-9\\\\.]*) ([0-9\\\\.-]*)( ? ?\\\\?)$"
  ) %>%
  left_join(
    available.packages() %>%
      as.data.frame(stringsAsFactors = FALSE) %>%
      select(Latest = Version) %>%
      rownames_to_column("Package"),
    by = "Package"
  ) %>%
  mutate(new = sprintf("%s %s %s%s", Command, Package, Latest, Suffix)) %>%
  pull(new) -> docker[cran]
writeLines(docker, "Dockerfile")

ubuntu_version <- function(package) {
  sprintf(
    "    %s=%s",
    package,
    gsub(
      ".*:\\s*",
      "",
      system(paste("apt-cache policy", package), intern = TRUE)[3]
    )
  )
}
system("apt-get update")
x <- sapply(
  c(
    "r-base-core","r-base-dev", "r-cran-boot", "r-cran-class", "r-cran-cluster",
    "r-cran-codetools", "r-cran-foreign", "r-cran-kernsmooth", "r-cran-lattice",
    "r-cran-mass", "r-cran-matrix", "r-cran-mgcv", "r-cran-nlme", "r-cran-nnet",
    "r-cran-rpart", "r-cran-spatial", "r-cran-survival", "r-recommended"
  ),
  ubuntu_version
)
cat(x, sep = " \\\n")

cat(ubuntu_version("littler"))
