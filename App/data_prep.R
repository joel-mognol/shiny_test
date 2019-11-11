library(readr)
library(tidyr)
library(dplyr)

nat2018 <- read_delim("App/nat2018.csv",
                   ";",
                   escape_double = FALSE,
                   col_types = cols(
                     sexe = col_character(),
                     preusuel = col_character(),
                     annais = col_integer(),
                     nombre = col_integer()),
                   trim_ws = TRUE) %>%
  filter(!is.na(annais))

saveRDS(nat2018,file="prenoms.Rda")

nat2019 <- nat2018 %>%
  pivot_wider(id_cols = c(preusuel,annais), names_from = sexe,
              names_prefix = "sex_", values_from = nombre, values_fill = list(nombre=0)) %>%
  rename(homme=sex_1,femme=sex_2)

saveRDS(nat2019,file="prenoms2.Rda")