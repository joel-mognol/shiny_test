library(readr)
library(tidyr)
library(dplyr)
nat2018 <- read_delim("App01/nat2018.csv",
                   ";",
                   escape_double = FALSE,
                   col_types = cols(
                     sexe = col_integer(),
                     preusuel = col_character(),
                     annais = col_integer(),
                     nombre = col_integer()),
                   trim_ws = TRUE)

saveRDS(nat2018,file="prenoms.Rda")

orions <- nat2018 %>%
  filter(preusuel=="ORION")

isiss <- nat2018 %>%
  filter(preusuel=="ISIS")

barplot(orions$nombre,names.arg = orions$annais,las=2)

barplot(isiss$nombre,names.arg = isiss$annais,border = NA, main = "Occurence du prénom ISIS depuis 1968", xlab = "Années", ylab = "Nombre", las=2, cex.names=0.8)
