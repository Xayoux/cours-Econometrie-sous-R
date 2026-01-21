# README

## R version

Ce cours a été créé en utilisant la version 4.5.2 de R. Pour éviter tout problème majeur, il est recommandé d'utiliser une version de R de type 4.5.

## Packages

Afin d'assurer au maximum une reproductivité des codes, le package [`renv`](https://rstudio.github.io/renv/articles/renv.html) (version 1.1.6) a été utilisé. Ce package permet à tous les utilisateurs d'utiliser la même version des différents packages utilisés au sein des différents scripts. ATTENTION : pour les utilisateurs de Windows, il est nécessaire d'installer le logiciel [Rtools](https://cran.r-project.org/bin/windows/Rtools/) dans une version compatible avec la version de R utilisée (ici [Rtools 4.5](https://cran.r-project.org/bin/windows/Rtools/rtools45/rtools.html)).

Lors de la première utilisation des codes, l'utilisateur doit télécharger et récupérer les packages à partir du fichier *renv.lock* grâce à la fonction `renv::snapshot()` (peut s'exécuter dans la commande. Aucun argument n'est requis). Cela va installer tous les packages nécessaires en local. Attention cela peut prendre du temps. Une fois cette première opération faite, l'utilisateur peut utiliser les librairies comme il en a l'habitude. La commande `renv::snapshot()` est à répéter si le fichier *renv.lock* est modifié (donc que des packages ont été modifié ou ajouté dans le cours).

En cas de difficultés pour télécharger les packages avec `renv`, il est possible de le désactiver avec la commande `renv::deactivate()`. Dans ce cas il est nécessaire de télécharger les packages de la manière habituelle en exécutant le script *02-codes/utils/install-packages.R*.

## Organisation

Le dossier *02-codes* contient les présentations (le cours) dans le dossier *02-codes/présentations* en format quarto (permettant d'exécuter le code manuellement) et html (où tous est déjà exécuté et indiqué). Chaque cours se décompose de la même façon, la première partie est un rappel (rapide) de la théorie économétrique expliquant les grands principes à avoir en tête. La seconde partie consiste en une démonstration de code utile et d'interprétation à partir de jeux de données (souvent prises à partir du package `wooldridge`). Les codes montrés n'ont pas vocation à être exhaustifs ou parfaitement optimaux. Ils correspondent à l'état de mes connaissances actuelles et servent à montrer ce qu'il est possible de faire et montrer comment mener les opérations courantes d'économétrie.

Le dossier *02-codes/exercices* contient des exercices pour chaque cours plus ou moins détaillés.
