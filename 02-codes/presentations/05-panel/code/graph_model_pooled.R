func_graph <- function(){
  # Simuler les données de panel pooled --------------------------------------
  set.seed(42) 
  N <- 4       # Nombre d'individus (i)
  T_obs <- 20   # Nombre de périodes (t) par individu
  
  # Création de la structure du panel
  df_panel <- expand.grid(t = 1:T_obs, i = 1:N)
  df_panel$i <- as.factor(df_panel$i) 
  
  # Définition des paramètres théoriques
  alpha <- 10  # Ordonnée à l'origine (constante)
  beta <- 2    # Pente (effet de x sur y)
  
  # Génération de la variable explicative (x) et du terme d'erreur (epsilon)
  df_panel$x <- runif(N * T_obs, min = 5, max = 20)
  df_panel$epsilon <- rnorm(N * T_obs, mean = 0, sd = 4) 
  
  # Calcul de la variable dépendante (y)
  df_panel$y <- alpha + beta * df_panel$x + df_panel$epsilon
  
  
  # Création du graphique -----------------------------------------------------
  graph <-
    df_panel |> 
    ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(ggplot2::aes(color = i, shape = i), size = 3, alpha = 0.8) +
    # Relation théorique entre y et x
    ggplot2::geom_abline(intercept = alpha, slope = beta, color = "darkblue", linewidth = 1) +
    ggplot2::labs(
      title = expression(paste("Modèle de Panel pooled : ", y[i~t] == alpha + beta*x[i~t] + epsilon[i~t])),
      subtitle = expression(paste(alpha == 10," ; ", beta == 2)),
      x = expression(paste("Variable explicative ", (x[i~t]))),
      y = expression(paste("Variable dépendante ", (y[i~t]))),
      color = "Individu (i)",
      shape = "Individu (i)"
    ) +
    ggplot2::scale_color_brewer(palette = "Set1") +
    ggplot2::theme_bw() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 14),
      legend.position = "right",
      panel.grid = ggplot2::element_blank()
    )
  
  print(graph)
}

func_graph()

rm(func_graph)