library(tidyverse)
deps <- pak::pkg_deps("n2kanalysis")
deps |>
  filter(.data$repotype == "cran") |>
  select(main = "package", "deps") |>
  unnest("deps") |>
  filter(.data$type == "imports") |>
  select("main", "package") |>
  filter(
    !.data$package %in%
      c(
        "graphics",
        "grDevices",
        "grid",
        "methods",
        "parallel",
        "splines",
        "stats",
        "tools",
        "utils"
      )
  ) -> imports
deps |>
  filter(.data$repotype == "cran") |>
  select(main = "package", "version") |>
  left_join(imports, by = "main") |>
  distinct(
    .data$main,
    .data$version,
    level = ifelse(is.na(.data$package), 1, NA)
  ) -> cran_deps
while (any(is.na(cran_deps$level))) {
  cran_deps |>
    filter(!is.na(.data$level)) |>
    left_join(x = imports, by = c("package" = "main")) |>
    group_by(.data$main) |>
    summarise(extra = max(.data$level) + 1) |>
    filter(!is.na(.data$extra)) |>
    left_join(x = cran_deps, by = "main") |>
    transmute(
      .data$main,
      .data$version,
      level = ifelse(is.na(.data$level), .data$extra, .data$level)
    ) -> cran_deps
}
cran_deps |>
  arrange(.data$level, .data$main) |>
  transmute(
    output = sprintf("%s@%s", .data$main, .data$version)
  ) |>
  pull(output) |>
  paste(collapse = " ") |>
  sprintf(
    fmt = paste(
      "RUN installr -p -c -a \"gfortran icu-data-full linux-headers",
      "postgresql-dev\" %s"
    )
  ) -> cran_dep_docker


deps <- pak::pkg_deps("sn")
deps |>
  filter(.data$repotype == "cran") |>
  select(main = "package", "deps") |>
  unnest("deps") |>
  filter(.data$type == "imports") |>
  select("main", "package") |>
  filter(
    !.data$package %in%
      c(
        "graphics",
        "grDevices",
        "grid",
        "methods",
        "parallel",
        "splines",
        "stats",
        "tools",
        "utils"
      )
  ) -> imports
deps |>
  filter(.data$repotype == "cran") |>
  select(main = "package", "version") |>
  left_join(imports, by = "main") |>
  distinct(
    .data$main,
    .data$version,
    level = ifelse(is.na(.data$package), 1, NA)
  ) -> sn_deps
while (any(is.na(sn_deps$level))) {
  sn_deps |>
    filter(!is.na(.data$level)) |>
    left_join(x = imports, by = c("package" = "main")) |>
    group_by(.data$main) |>
    summarise(extra = max(.data$level) + 1) |>
    filter(!is.na(.data$extra)) |>
    left_join(x = sn_deps, by = "main") |>
    transmute(
      .data$main,
      .data$version,
      level = ifelse(is.na(.data$level), .data$extra, .data$level)
    ) -> sn_deps
}
sn_deps |>
  anti_join(cran_deps, by = "main") |>
  arrange(.data$level, .data$main) |>
  transmute(
    output = sprintf("%s@%s", .data$main, .data$version)
  ) |>
  pull(output) |>
  paste(collapse = " ") |>
  sprintf(
    fmt = "RUN installr -p -c %s"
  ) -> sn_dep_docker

c(
  "FROM rhub/r-minimal:4.5.1-patched",
  "",
  "ARG BUILD_DATE",
  "ARG VCS_REF",
  "LABEL org.label-schema.build-date=$BUILD_DATE \\",
  "      org.label-schema.name=\"Rn2k\" \\",
  paste(
    "      org.label-schema.description=\"A docker image with stable versions",
    "of R and a bunch of packages. The full list of packages is available in",
    "the README.\" \\"
  ),
  "      org.label-schema.url=\"https://www.inbo.be/\" \\",
  "      org.label-schema.vcs-ref=$VCS_REF \\",
  "      org.label-schema.vcs-url=\"https://github.com/inbo/Rn2k\" \\",
  paste(
    "      org.label-schema.vendor=\"Research Institute for Nature and",
    "Forest\" \\"
  ),
  paste(
    "      org.opencontainers.image.authors=\"Thierry Onkelinx",
    "<thierry.onkelinx@inbo.be>\""
  ),
  "",
  "COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site",
  "",
  "# n2kanalysis dependencies on CRAN",
  cran_dep_docker,
  "",
  "# sn dependencies",
  sn_dep_docker,
  "",
  "# n2kanalysis dependencies not on CRAN",
  "RUN installr -p -c INLA@25.06.07",
  "RUN installr -p -c inbo/multimput@v0.2.15",
  "RUN installr -p -c inbo/n2khelper@v0.5.0",
  "",
  "RUN installr -p -c inbo/n2kanalysis@v0.4.0",
  "",
  "COPY fit_model_aws.R /analysis/fit_model_aws.R",
  "COPY fit_model_aws.sh /analysis/fit_model_aws.sh",
  "COPY fit_model_file.R /analysis/fit_model_file.R",
  "COPY fit_model_file.sh /analysis/fit_model_file.sh",
  "",
  "#entrypoint",
  "CMD [ \"sh\" ]"
) |>
  writeLines("Dockerfile")
