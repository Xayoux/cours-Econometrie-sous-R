# Importer (et télécharger si nécessaire) les packages ------------------------
# Packages pour la manipulation de données
library(tidyverse)
library(readr)
library(here)
library(modelsummary)
library(janitor)
library(glue)

# Package pour les données utilisées dans Wooldrige
require(wooldridge)

# PAckages pour les tests statistiques
library(performance)
library(qqplotr)
library(moments)
library(lmtest)
library(whitestrap)
library(car)
library(effects)
library(forcats)

# Importer les différents paths -----------------------------------------------
source(here("02-codes", "utils", "paths.R"))

# Options générales -----------------------------------------------------------
# Enlève les notations scientifiques
options(scipen=999)


# Style graphique ggplot2 -----------------------------------------------------
display <- 
  set_theme(
    theme_bw() +
      theme(
        panel.grid.minor = element_blank(), 
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 10, color = "black"),
        legend.title = element_text(size = 16, color = "black"),
        legend.text = element_text(size = 10, color = "black"),
        legend.key.size = unit(1, "cm")
    )
)






