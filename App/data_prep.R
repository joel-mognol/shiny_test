library(readr)
library(tidyr)
library(dplyr)

#nat2018l avec l pour longer, désigne nat2018 avec
#les valeurs des deux sexes dans la même colonne

nat2018l <- read_delim("App/nat2018.csv",
                   ";",
                   escape_double = FALSE,
                   col_types = cols(
                     sexe = col_character(),
                     preusuel = col_character(),
                     annais = col_integer(),
                     nombre = col_integer()),
                   trim_ws = TRUE) %>%
  filter(!is.na(annais))

saveRDS(nat2018l,file="prenoms_l.Rda")

#nat2018w avec w pour wider, désigne nat2018 avec
#les valeurs des deux sexessur la même ligne

nat2018w <- nat2018l %>%
  pivot_wider(id_cols = c(preusuel,annais), names_from = sexe,
              names_prefix = "sex_", values_from = nombre, values_fill = list(nombre=0)) %>%
  rename(homme=sex_1,femme=sex_2)

saveRDS(nat2018w,file="prenoms_w.Rda")

#nat2018l2 avec l pour longer, désigne nat2018 avec
#les valeurs des deux sexes dans la même colonne et
#des zéros dans les cas où il n'y a pas eu de naissance

nat2018l2 <- nat2018w %>%
  pivot_longer(cols = c(homme,femme), names_to = "sexe", values_to = "nombre") %>%
  select(sexe,preusuel,annais,nombre)
nat2018l2$sexe <- ifelse(nat2018l2$sexe == "homme", "1", "2")

saveRDS(nat2018l2,file="prenoms_l2.Rda")
