library(tidyverse)

available.packages() |>
  as.data.frame() |>
  transmute(
    package = .data$Package, version = .data$Version,
    depends = str_replace_all(.data$Depends, "\n", "") |>
      str_remove_all("\\s*\\(.*?\\)") |>
      str_split(", *"),
    imports = str_replace_all(.data$Imports, "\n", "") |>
      str_remove_all("\\s*\\(.*?\\)") |>
      str_split(", *"),
    suggests = str_replace_all(.data$Suggests, "\n", "") |>
      str_remove_all("\\s*\\(.*?\\)") |>
      str_split(", *")
  ) -> available
available |>
  filter(.data$package == "n2kanalysis") |>
  transmute(.data$package, .data$version, level = 0) -> required
available |>
  filter(.data$package == "n2kanalysis") |>
  select("depends", "imports", "suggests") |>
  unlist() |>
  sort() -> deps

while (length(deps)) {
  available |>
    filter(.data$package %in% deps) |>
    transmute(.data$package, .data$version, level = max(required$level) + 1) |>
    bind_rows(required) -> required
  available |>
    filter(.data$package %in% deps) |>
    select("depends", "imports") |>
    unlist() |>
    unique() |>
    sort() -> deps
}
required |>
  group_by(.data$package) |>
  slice_max(.data$level, n = 1) |>
  ungroup() |>
  arrange(desc(.data$level), .data$package) |>
  transmute(
    cmd = sprintf(
      "RUN Rscript -e 'remotes::install_version(\"%s\", version = \"%s\")'",
      .data$package, .data$version
    )
  ) |>
  pull("cmd") -> mid

docker <- readLines("Dockerfile")
grep("# packages start", docker) |>
  head(x = docker) -> before
tail(docker, 1 - grep("# packages end", docker)) -> after
c(before, mid, after) |>
  writeLines("Dockerfile")
