func_graph <- function(){
  # Création des données ---------------------------------------------------
  set.seed(123) 
  N <- 4       # 4 individus
  T_obs <- 50  # 50 observations par individu pour dessiner de belles ellipses
  
  df <- expand.grid(t = 1:T_obs, i = as.factor(1:N))
  
  # Définition des paramètres théoriques
  alpha_i <- c(10, 20, 30, 40) # Effets fixes par individus (hétérogénéité)
  beta_true <- -0.2             # Pente identique pour tous les individus
  
  df$alpha <- alpha_i[as.numeric(df$i)]
  
  # Corrélation positive entre l'effet fixe (alpha) et X
  # L'individu 1 a des X autour de 10, l'individu 4 a des X autour de 40.
  # Chaque individu est centré autour de son effet fixe
  mu_x_i <- c(10, 20, 30, 40) 
  df$mu_x <- mu_x_i[as.numeric(df$i)]
  
  # Génération des données
  df$x <- rnorm(nrow(df), mean = df$mu_x, sd = 3)
  df$epsilon <- rnorm(nrow(df), mean = 0, sd = 1.5)
  
  # Le vrai modèle de la population (Effets Fixes)
  df$y <- df$alpha + beta_true * df$x + df$epsilon
  
  
  # Création du graphique ---------------------------------------------------
  # On calcule le centre Y de chaque groupe pour placer les étiquettes alpha
  y_centers <- alpha_i + beta_true * mu_x_i
  
  # 1. On définit une palette unique qui gère TOUT (Les individus + la ligne Pooled)
  # Les codes hexadécimaux correspondent à la palette "Set1"
  vector_colors <- c("1" = "#E41A1C", "2" = "#377EB8", "3" = "#4DAF4A", "4" = "#984EA3", "Pooled" = "black")
  
  # 2. Le graphique corrigé
  graph <- 
    ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(ggplot2::aes(color = i), alpha = 0.4, size = 1.5) +
    # B. Les ellipses autour de chaque individu
    ggplot2::stat_ellipse(ggplot2::aes(color = i), type = "norm", linetype = "dashed", linewidth = 1) +
    # C. Le modèle POOLED
    ggplot2::geom_smooth(ggplot2::aes(color = "Pooled"), method = "lm", se = FALSE, linewidth = 1.5, formula = y~x) +
    # D. Les VRAIES pentes (Effets Fixes) 
    ggplot2::geom_abline(intercept = alpha_i, slope = beta_true, color = "gray40", linetype = "dotted", linewidth = 1) +
    # E. Annotations des alpha
    ggplot2::annotate("text", x = 2, y = y_centers, 
                      label = paste0("alpha[", 1:4, "]"), parse = TRUE, size = 7, fontface = "bold") +
    ggplot2::labs(
      title = "Le Biais d'Hétérogénéité (Modèle Pooled vs Effets Fixes)",
      subtitle = "La droite noire (Pooled) est biaisée vers le haut car l'effet fixe est corrélé avec X",
      x = expression(paste("Variable explicative ", (x[i~t]))),
      y = expression(paste("Variable dépendante ", (y[i~t]))),
      color = "Individus (i)" 
    ) +
    ggplot2::scale_color_manual(values = vector_colors) +
    ggplot2::coord_cartesian(xlim = c(0, 50)) + 
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 14),
      legend.position = "right",        
      axis.text.y = ggplot2::element_blank(),   
      axis.ticks.y = ggplot2::element_blank(),
      axis.line.y = ggplot2::element_line(arrow = grid::arrow(length = ggplot2::unit(0.3, "cm"), ends = "last")),
      axis.line.x = ggplot2::element_line(arrow = grid::arrow(length = ggplot2::unit(0.3, "cm"), ends = "last"))
    )
  
  print(graph)
}

func_graph()

rm(func_graph)
