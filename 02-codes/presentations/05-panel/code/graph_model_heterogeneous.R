func_graph <- function(){
  # Simuler les données (hétérogénéité des pentes et des ordonnées) -------
  set.seed(42) 
  N <- 4       # Nombre d'individus (i)
  T_obs <- 20  # Nombre de périodes (t) par individu
  
  df_panel <- expand.grid(t = 1:T_obs, i = 1:N)
  df_panel$i <- as.factor(df_panel$i) 
  
  # NOUVEAUTÉ : Un alpha ET un beta spécifiques pour chaque individu
  alpha_i <- c(10, 40, -10, 60) 
  beta_i  <- c(2, 0.5, 3.5, -1.5) # Pentes différentes (l'individu 4 a un effet négatif)
  
  # Assigner les bons paramètres à chaque ligne selon l'individu
  df_panel$alpha <- alpha_i[as.numeric(df_panel$i)]
  df_panel$beta  <- beta_i[as.numeric(df_panel$i)]
  
  # Génération de la variable explicative (x) et de l'erreur (epsilon)
  df_panel$x <- runif(N * T_obs, min = 5, max = 20)
  df_panel$epsilon <- rnorm(N * T_obs, mean = 0, sd = 4) 
  
  # Calcul de (y) avec l'hétérogénéité totale
  df_panel$y <- df_panel$alpha + df_panel$beta * df_panel$x + df_panel$epsilon
  
  # Mini-tableau pour tracer les droites théoriques avec les bonnes pentes
  df_droites <- data.frame(i = as.factor(1:N), alpha = alpha_i, beta = beta_i)
  
  # Préparation du texte pour le sous-titre dynamique
  valeurs_alpha_texte <- paste(alpha_i, collapse = ", ")
  valeurs_beta_texte <- paste(beta_i, collapse = ", ")
  
  
  # Création du graphique -----------------------------------------------------
  graph <-
    df_panel |> 
    ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(ggplot2::aes(color = i, shape = i), size = 3, alpha = 0.8) +
    # NOUVEAUTÉ : La fonction geom_abline lit l'alpha ET le beta du sous-tableau
    ggplot2::geom_abline(data = df_droites, ggplot2::aes(intercept = alpha, slope = beta, color = i), linewidth = 1) +
    ggplot2::labs(
      title = expression(paste("Modèle avec Hétérogénéité Totale : ", y[i~t] == alpha[i] + beta[i]*x[i~t] + epsilon[i~t])),
      
      # Injection des deux vecteurs de paramètres dans le sous-titre
      subtitle = bquote(alpha[i] == "{" * .(valeurs_alpha_texte) * "}" ~ " ; " ~ beta[i] == "{" * .(valeurs_beta_texte) * "}"),
      
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