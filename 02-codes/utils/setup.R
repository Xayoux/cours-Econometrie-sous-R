# Importer (et télécharger si nécessaire) les packages ------------------------
# PAckage pour télécharger depuis github
library(devtools)

# Packages pour la manipulation de données
library(tidyverse)
library(readr)
library(here)
library(modelsummary)
library(janitor)
library(glue)
library(conflicted)

# Package pour les données utilisées dans Wooldrige
require(wooldridge)
library(pdfetch)

# PAckages pour les tests statistiques
library(performance)
library(qqplotr)
library(moments)
library(lmtest)
library(whitestrap)
library(car)
library(effects)
library(forcats)
library(forecast)
library(fDMA)
library(runner)

# PAckage pour les ARDl
library(dynlm)
library(ARDL)

# PAckage maison pour le test ADF
library(dobby)

# Gérer les conflits de fonction entre package
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)
conflicts_prefer(dplyr::select)
conflicts_prefer(ggplot2::stat_qq_line)

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






