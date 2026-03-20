func_graph <- function() {
  # Paramètres de la distribution
  mu <- 0      # Moyenne
  sigma <- 1   # Écart-type
  alpha <- 0.01 # Seuil de la VaR (1%)
  
  # Calcul du seuil exact de la VaR (Z-score pour 1%)
  var_threshold <- qnorm(alpha, mean = mu, sd = sigma) 
  
  # Création du jeu de données pour la courbe (de -4 à 4 écarts-types)
  df <- 
    data.frame(x = seq(-4, 4, length.out = 1000)) |> 
    dplyr::mutate(y = dnorm(x, mean = mu, sd = sigma))
  
  # Création du graphique
  graph <- 
    df |> 
    ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
    # Tracer la courbe de la distribution
    ggplot2::geom_line(color = "#21618C", linewidth = 1) +
    # Zone 1-alpha : gains et pertes communes 
    ggplot2::geom_area(data = subset(df, x > var_threshold), 
                       fill = "#5DADE2", alpha = 0.8) +
    # Zone alpha de la VaR (Pertes extrêmes)
    ggplot2::geom_area(data = subset(df, x <= var_threshold), 
                       fill = "#FF4D4D", alpha = 0.9) +
    # Ligne verticale rouge de la VaR
    ggplot2::geom_vline(xintercept = var_threshold, color = "red", linewidth = 1.5) +
    # Ligne verticale en pointillés pour la moyenne
    ggplot2::geom_vline(xintercept = mu, linetype = "dashed", color = "#2C3E50", linewidth = 1) +
    # Ligne horizontale de base (Axe X)
    ggplot2::geom_hline(yintercept = 0, color = "black", linewidth = 1) +
    # Moyenne
    ggplot2::annotate("text", x = 0.8, y = 0.42, label = "Valeur Espérée\n(Moyenne \u03bc)", 
                      fontface = "bold", size = 3) +
    # Annotation VaR (Texte + Flèche)
    ggplot2::annotate("text", x = -3.2, y = 0.32, 
                      label = "Value at Risk (VaR)\nSeuil de Perte Maximale\n(99% de confiance)", 
                      fontface = "bold", size = 3, hjust = 0.5) +
    ggplot2::annotate("segment", x = -3.2, y = 0.28, xend = -2.4, yend = 0.22, 
                      arrow = ggplot2::arrow(length = ggplot2::unit(0.2, "cm"), type = "closed"), linewidth = 0.8) +
    # Annotation Zone de perte (Texte + Flèche)
    ggplot2::annotate("text", x = -3.2, y = 0.15, 
                      label = "Zone de Perte (\u03B1 = 1%) :\nLes 1% de Pertes les Plus\nExtrêmes", 
                      size = 3, hjust = 0.5) +
    ggplot2::annotate("segment", x = -3.2, y = 0.10, xend = -2.7, yend = 0.04, 
                      arrow = ggplot2::arrow(length = ggplot2::unit(0.2, "cm"), type = "closed"), linewidth = 0.8) +
    # Annotation Niveau de confiance (Texte + Flèche)
    ggplot2::annotate("text", x = 2.5, y = 0.22, 
                      label = "Niveau de Confiance (1-\u03B1 = 99%)\n: Gains et Pertes Communs", 
                      fontface = "bold", size = 3, hjust = 0.5) +
    ggplot2::annotate("segment", x = 2.5, y = 0.19, xend = 1.5, yend = 0.12, 
                      arrow = ggplot2::arrow(length = ggplot2::unit(0.2, "cm"), type = "closed"), linewidth = 0.8) +
    # Textes "Losses" et "Profits" aux extrémités
    ggplot2::annotate("text", x = -3.5, y = -0.02, label = "Losses", fontface = "bold", size = 4) +
    ggplot2::annotate("text", x = 3.5, y = -0.02, label = "Profits", fontface = "bold", size = 4) +
    # On étend un peu l'axe Y vers le bas pour laisser de la place aux labels
    ggplot2::coord_cartesian(ylim = c(-0.03, 0.45), xlim = c(-4.2, 4.2), expand = FALSE) +
    ggplot2::labs(
      title = "Illustration du Concept de Value At Risk (VaR)",
      subtitle = "Distribution Normale des Profits et Pertes (\u03B1=1%)",
      x = NULL, y = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", size = 14, color = "#2C3E50"),
      plot.subtitle = ggplot2::element_text(hjust = 0.5, size = 10, color = "#34495E", margin = ggplot2::margin(b=15)),
      axis.text = ggplot2::element_blank(),     # Cache les nombres sur les axes
      axis.ticks = ggplot2::element_blank(),    # Cache les petites graduations
      panel.grid.major.x = ggplot2::element_line(color = "grey90"), # Légère grille verticale
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(color = "grey90")
    )
  
  # Afficher le graphique
  print(graph)
}


func_graph()