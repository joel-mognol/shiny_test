library(readr)
library(tidyr)
library(dplyr)
data <- read_delim("App01/nat2018.csv",
                   ";",
                   escape_double = FALSE,
                   col_types = cols(
                     sexe = col_integer(),
                     preusuel = col_character(),
                     annais = col_integer(),
                     nombre = col_integer()),
                   trim_ws = TRUE)
orions <- data %>%
  filter(preusuel=="ORION")

isiss <- data %>%
  filter(preusuel=="ISIS")