func_graph <- function(){
  # Simuler les données de panel à effets fixes ---------------------------
  set.seed(42) 
  N <- 4       # Nombre d'individus (i)
  T_obs <- 20  # Nombre de périodes (t) par individu
  
  # Création de la structure du panel
  df_panel <- expand.grid(t = 1:T_obs, i = 1:N)
  df_panel$i <- as.factor(df_panel$i) 
  
  # Définition des paramètres théoriques
  # NOUVEAUTÉ : Un alpha spécifique pour chaque individu (Effet fixe)
  alpha_i <- c(5, 15, 25, 35) 
  valeurs_alpha_texte <- paste(alpha_i, collapse = ", ")
  beta <- 2    # Pente (effet de x sur y commun à tous)
  
  # Assigner le bon alpha à chaque ligne selon l'individu
  df_panel$alpha <- alpha_i[as.numeric(df_panel$i)]
  
  # Génération de la variable explicative (x) et du terme d'erreur (epsilon)
  df_panel$x <- runif(N * T_obs, min = 5, max = 20)
  df_panel$epsilon <- rnorm(N * T_obs, mean = 0, sd = 4) 
  
  # Calcul de la variable dépendante (y) avec l'alpha individuel
  df_panel$y <- df_panel$alpha + beta * df_panel$x + df_panel$epsilon
  
  # Création d'un mini-tableau pour tracer les droites théoriques
  df_droites <- data.frame(i = as.factor(1:N), alpha = alpha_i)
  
  
  # Création du graphique -----------------------------------------------------
  graph <-
    df_panel |> 
    ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(ggplot2::aes(color = i, shape = i), size = 3, alpha = 0.8) +
    # NOUVEAUTÉ : Tracer les droites théoriques (une par individu)
    ggplot2::geom_abline(data = df_droites, ggplot2::aes(intercept = alpha, slope = beta, color = i), linewidth = 1) +
    ggplot2::labs(
      title = expression(paste("Modèle à Effets Fixes : ", y[i~t] == alpha[i] + beta*x[i~t] + epsilon[i~t])),
      subtitle = bquote("Pente commune " ~ beta == 2 ~ " ; Ordonnées à l'origine " ~ alpha[i] == "{" * .(valeurs_alpha_texte) * "}"),
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