source(here::here("02-codes", "utils", "setup.R"))

#' Création d'un procesus générateur de données de type 
#' Y = alpha + beta * X + epsilon , avec epsilon suivant une loi normale
#'
#' @param n Nombre d'observations dans l'échantillon
#' @param alpha Coefficient de la constante dans le DGP
#' @param beta1 Coefficient de pente dans le GDP
#' @param sigma_epsilon Ecart-type de loi normale suivie par les erreurs
#'
#' @returns Un Dataframe avec la valeur du coefficient de régression linéaire 
#' estimé et son écart-type
spec1_function <- function(n, alpha, beta1, sigma_epsilon){
  df <-
    tibble(
      x1 = runif(n, min = 0, max = 10),
      epsilon = rnorm(n, mean =  0, sd = sigma_epsilon),
      y = alpha + beta1 * x1 + epsilon
    )
  res_lm <- lm(y ~ x1, data = df)
  res_lm_summary <- summary(res_lm)
  df_res <-
    tibble(
      beta1 = res_lm_summary$coefficients["x1", "Estimate"],
      sigma_beta1 = res_lm_summary$coefficients["x1", "Std. Error"]
    )
  return(df_res)
}


#' Création d'un procesus générateur de données de type 
#' Y = alpha + beta * X + epsilon , avec epsilon suivant une loi normale mais hétéroscédastique
#'
#' @param n Nombre d'observations dans l'échantillon
#' @param alpha Coefficient de la constante dans le DGP
#' @param beta1 Coefficient de pente dans le GDP
#' @param sigma_epsilon Ecart-type de loi normale suivie par les erreurs
#'
#' @returns Un Dataframe avec la valeur du coefficient de régression linéaire 
#' estimé et son écart-type
spec2_function <- function(n, alpha, beta1){
  df <-
    tibble(
      x1 = runif(n, min = 1, max = 10),
      epsilon = rnorm(n, mean =  0, sd = 1*x1),
      y = alpha + beta1 * x1 + epsilon
    )
  res_lm_MCO <- lm(y ~ x1, data = df)
  res_lm_summary_MCO <- summary(res_lm_MCO)
  res_lm_MCP <- lm(y ~ x1, data = df, weights = 1/(df$x1^2))
  res_lm_summary_MCP <- summary(res_lm_MCP)
  df_res <-
    tibble(
      beta1_MCO = res_lm_summary_MCO$coefficients["x1", "Estimate"],
      sigma_beta1_MCO = res_lm_summary_MCO$coefficients["x1", "Std. Error"],
      beta1_MCP = res_lm_summary_MCP$coefficients["x1", "Estimate"],
      sigma_beta1_MCP = res_lm_summary_MCP$coefficients["x1", "Std. Error"]
    )
  return(df_res)
}

# Effets du nombre d'observations dans l'échantillon -----------------------
tictoc::tic()
set.seed(123)
MC_50_obs <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 50,  alpha = 1, beta1 = 2, sigma_epsilon = 1),
    .options = furrr_options(seed=123)
  ) |>
  print()
tictoc::toc()

tictoc::tic()
set.seed(123)
MC_100_obs <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 100,  alpha = 1, beta1 = 2, sigma_epsilon = 1),
    .options = furrr_options(seed=123)
  ) |>
  print()
tictoc::toc()

tictoc::tic()
set.seed(123)
MC_1000_obs <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 1000,  alpha = 1, beta1 = 2, sigma_epsilon = 1),
    .options = furrr_options(seed=123)
  ) |>
  print()
tictoc::toc()

tictoc::tic()
set.seed(123)
MC_2000_obs <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 2000,  alpha = 1, beta1 = 2, sigma_epsilon = 1),
    .options = furrr_options(seed=123)
  ) |>
  print()
tictoc::toc()



ggplot() +
  geom_density(data = MC_50_obs, aes(x = beta1, color = "n = 50"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_100_obs, aes(x = beta1, color = "n = 100"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_1000_obs, aes(x = beta1, color = "n = 1000"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_2000_obs, aes(x = beta1, color = "n = 2000"), linewidth = 1, key_glyph = "path") +
  scale_color_manual(
    breaks = c("n = 50", "n = 100", "n = 1000", "n = 2000"),
    values = c(
      "n = 50" = "blue",
      "n = 100" = "red",
      "n = 1000" = "purple",
      "n = 2000" = "gold"
      )
    ) +
  labs(
    x = expression(beta[1]),
    y = expression(paste("Distribution de ", beta[1], " sur l'ensemble des échantillons")),
    colour = NULL
  )


MC_50_obs |> 
  summarize(
    beta1_mean = mean(beta1),
    se_beta1_mean = mean(sigma_beta1),
    specifiction = "n = 50"
  ) |> 
  full_join(
    MC_100_obs |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "n = 100"
      )
  ) |> 
  full_join(
    MC_1000_obs |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "n = 1000"
      )
  ) |> 
  full_join(
    MC_2000_obs |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "n = 2000"
      )
  )


# Effet de la variance des erreurs
set.seed(123)
MC_sigma_epsilon_1 <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 1000,  alpha = 1, beta1 = 2, sigma_epsilon = 1),
    .options = furrr_options(seed=123)
  ) |>
  print()

set.seed(123)
MC_sigma_epsilon_2 <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 1000,  alpha = 1, beta1 = 2, sigma_epsilon = 2),
    .options = furrr_options(seed=123)
  ) |>
  print()

set.seed(123)
MC_sigma_epsilon_3 <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 1000,  alpha = 1, beta1 = 2, sigma_epsilon = 3),
    .options = furrr_options(seed=123)
  ) |>
  print()

set.seed(123)
MC_sigma_epsilon_4 <-
  future_map_dfr(
    1:10000,
    \(nb) spec1_function(n = 1000,  alpha = 1, beta1 = 2, sigma_epsilon = 4),
    .options = furrr_options(seed=123)
  ) |>
  print()


ggplot() +
  geom_density(data = MC_sigma_epsilon_1, aes(x = beta1, color = "s1"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_sigma_epsilon_2, aes(x = beta1, color = "s2"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_sigma_epsilon_3, aes(x = beta1, color = "s3"), linewidth = 1, key_glyph = "path") +
  geom_density(data = MC_sigma_epsilon_4, aes(x = beta1, color = "s4"), linewidth = 1, key_glyph = "path") +
  scale_color_manual(
    breaks = c("s1", "s2", "s3", "s4"),
    values = c(
      "s1" = "blue",
      "s2" = "red",
      "s3" = "purple",
      "s4" = "gold"
    ),
    labels = c(
      expression(sigma[epsilon] == 1),
      expression(sigma[epsilon] == 2),
      expression(sigma[epsilon] == 3),
      expression(sigma[epsilon] == 4)
    )
  ) +
  labs(
    x = expression(beta[1]),
    y = expression(paste("Distribution de ", beta[1], " sur l'ensemble des échantillons")),
    color = NULL
  )


MC_sigma_epsilon_1 |> 
  summarize(
    beta1_mean = mean(beta1),
    se_beta1_mean = mean(sigma_beta1),
    specifiction = "sigma_epsilon = 1"
  ) |> 
  full_join(
    MC_sigma_epsilon_2 |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "sigma_epsilon = 2"
      )
  ) |> 
  full_join(
    MC_sigma_epsilon_3 |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "sigma_epsilon = 3"
      )
  ) |> 
  full_join(
    MC_sigma_epsilon_4 |> 
      summarize(
        beta1_mean = mean(beta1),
        se_beta1_mean = mean(sigma_beta1),
        specifiction = "sigma_epsilon = 4"
      )
  )







x1 = runif(10, min = 0, max = 10)
rnorm(10, mean =  0, sd = 1/x1)


test <-
  future_map_dfr(
    1:10000,
    \(nb) spec2_function(n = 1000,  alpha = 1, beta1 = 2),
    .options = furrr_options(seed=123)
  ) |>
  print()

test |> 
  summarize(
    across(.col = everything(), var)
  )


ggplot(data = test, aes(x = beta1)) +
  geom_density()
  