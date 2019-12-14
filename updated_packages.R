if (!require(tidyverse)) {
  install.packages("tidyverse")
  library(tidyverse)
}
available.packages() %>%
  data.frame(stringsAsFactors = FALSE) %>%
  select(Package, Version, Depends, Imports, LinkingTo) %>%
  mutate_at(
    c("Depends", "Imports", "LinkingTo"),
    function(x) {
      ifelse(is.na(x), "", x)
    }
  ) %>%
  mutate(
    Dependency = Depends,
    Dependency = ifelse(
      Imports == "",
      Dependency,
      ifelse(
        Dependency == "",
        Imports,
        paste(Dependency, Imports, sep = ", ")
      )
    ),
    Dependency = ifelse(
      LinkingTo == "",
      Dependency,
      ifelse(
        Dependency == "",
        LinkingTo,
        paste(Dependency, LinkingTo, sep = ", ")
      )
    ) %>%
      str_split(",\\s*")
  ) %>%
  select(-Depends, -Imports, -LinkingTo) -> cran_packages
cran_packages %>%
  select(-Version) %>%
  unnest(cols = "Dependency") %>%
  mutate(
    Dependency = str_remove_all(Dependency, "\\n") %>%
      str_remove_all("\\(.*\\)") %>%
      str_remove_all("\\s"),
    Dependency = ifelse(
      Dependency %in% c(
        "R", "base", "boot", "class", "cluster", "codetools", "compiler",
        "datasets", "foreign", "graphics", "grDevices", "grid", "KernSmooth",
        "lattice", "littler", "MASS", "Matrix", "methods", "mgcv", "nlme",
        "nnet", "parallel", "splines", "stats", "stats4", "rpart", "spatial",
        "survival", "tcltk", "tinytex", "tools", "translations", "utils", "xfun"
      ),
      "",
      Dependency
    )
  ) %>%
  filter(Dependency != "") %>%
  left_join(
    cran_packages %>%
      select(Package, Version),
    by = c("Dependency" = "Package")
  ) -> dependencies

docker <- readLines("Dockerfile")
tibble(Package = docker) %>%
  mutate(
    CRAN = grepl("cran_install", docker),
    line = row_number(),
    order = (lead(CRAN, default = FALSE) | lag(CRAN, default = FALSE)) & !CRAN,
    order  = cumsum(order)
  ) -> docker

docker %>%
  filter(CRAN) %>%
  select(-CRAN) %>%
  group_by(order) %>%
  slice(n()) %>%
  ungroup() %>%
  mutate(
    Package = str_remove(Package, "^.*cran_install.sh ") %>%
      str_remove(" [0-9\\\\.-]* ? ?\\\\?$")
  ) %>%
  inner_join(
    cran_packages %>%
      select(Package, Version),
    by = "Package"
  ) %>%
  mutate(
    level = 0
  ) -> new_list

docker %>%
  anti_join(new_list, by = "order") -> docker

new_list %>%
  select(-Version) %>%
  inner_join(dependencies, by = "Package") %>%
  transmute(
    Package = Dependency,
    Version,
    order,
    level = level + 1
  ) -> extra
while (nrow(extra)) {
  new_list <- bind_rows(new_list, extra)
  extra %>%
    select(-Version) %>%
    inner_join(dependencies, by = "Package") %>%
    transmute(
      Package = Dependency,
      Version,
      order,
      level = level + 1
    ) -> extra
}
new_list %>%
  arrange(order, desc(level)) %>%
  mutate(command = sprintf("./cran_install.sh %s %s", Package, Version)) %>%
  group_by(Package) %>%
  slice(1) %>%
  group_by(order) %>%
  arrange(desc(level)) %>%
  summarise_at("command", paste, collapse = " \\\n && ") %>%
  inner_join(
    new_list %>%
      filter(level == 0) %>%
      select(order, Package),
    by = "order"
  ) %>%
  transmute(
    Package = sprintf("## Install %s from CRAN\nRUN %s", Package, command),
    order,
    line = 1
  ) %>%
  bind_rows(docker) %>%
  arrange(order, line) %>%
  pull(Package) %>%
  writeLines("Dockerfile")
