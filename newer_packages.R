library(dplyr)
library(tibble)
installed.packages(priority = "NA") %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  select(Current = Version) %>%
  rownames_to_column("Package") %>%
  inner_join(
    available.packages() %>%
      as.data.frame(stringsAsFactors = FALSE) %>%
      select(Latest = Version) %>%
      rownames_to_column("Package"),
    by = "Package"
  ) %>%
  filter(Current != Latest)
