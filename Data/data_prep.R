#Script de préparation des données pour App/App.R
library(readr)
library(tidyr)
library(dplyr)

#nat2018w avec w pour wider, désigne nat2018 :
#- sans les années vides ou XXXX ;
#- avec les valeurs des deux sexes sur la même ligne.
#Le pivot_wider permet de générer les zéros nécessaires au graph1 de App/App.R

nat2018w <- read_delim("Data/nat2018.csv",
                   ";",
                   escape_double = FALSE,
                   col_types = cols(
                     sexe = col_character(),
                     preusuel = col_character(),
                     annais = col_integer(),
                     nombre = col_integer()),
                   trim_ws = TRUE) %>%
  filter(!is.na(annais)) %>%
  pivot_wider(id_cols = c(preusuel,annais),
              names_from = sexe,
              names_prefix = "sex_",
              values_from = nombre,
              values_fill = list(nombre=0))

saveRDS(nat2018w,file="App/prenoms_w.Rda")
