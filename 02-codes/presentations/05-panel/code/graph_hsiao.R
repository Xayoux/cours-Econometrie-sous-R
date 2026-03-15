graph_hsiao <- 
    DiagrammeR::grViz('
    digraph hsiao_procedure {
  
    # Paramètres généraux
    graph [layout = dot, rankdir = TB, nodesep = 0.8, ranksep = 0.8, ordering = out]
  
    # Noeuds de test dhypothèse
    node [shape = box, style = rounded, fontname = Helvetica, margin = 0.25]
    
    H01 [label = <
      <b>H0\u2081 :</b>\u03B1\u1D62 = \u03B1 ; \u03B2\u1D62 = \u03B2   \u2200 i \u2208 [1,N]
    >]
    
    H02 [label = <
      <b>H0\u2082 :</b>\u03B2\u1D62 = \u03B2    \u2200 i \u2208 [1,N]
    >]
    
    H03 [label = <
      <b>H0\u2083 :</b>\u03B1\u1D62 = \u03B1   sachant \u03B2\u1D62 = \u03B2   \u2200 i \u2208 [1,N]
    >]
    
  
    # Noeuds de conclusion du modèle à utiliser
    node [shape = ellipse, style = filled, fillcolor = "#f0f0f0", color = "#333333", fontsize = 15]
    
    H01_non_rejet [label = "y\u1D62\u209C = \u03B1 + \u03B2x\u1D62\u209C + \u03B5\u1D62\u209C"]
    
    H02_rejet [label = "y\u1D62\u209C = \u03B1\u1D62 + \u03B2\u1D62x\u1D62\u209C + \u03B5\u1D62\u209C"]
    
    H03_rejet [label = "y\u1D62\u209C = \u03B1\u1D62 + \u03B2x\u1D62\u209C + \u03B5\u1D62\u209C"]
    
    H03_non_rejet [label = "y\u1D62\u209C = \u03B1 + \u03B2x\u1D62\u209C + \u03B5\u1D62\u209C"]
    
  
    # Flèches
    edge [fontname = Helvetica, fontsize = 10, color = "#555555"]
    
    # --- NIVEAU 1 (H01) ---
    # 1. On déclare la flèche de GAUCHE (Rejet)
    H01 -> H02 [label = <
      Rejet de H0\u2081 
    >]
    # 2. On déclare la flèche de DROITE (Non rejet)
    H01 -> H01_non_rejet [label = <
      Non rejet de H0\u2081 
    >]
    
    # --- NIVEAU 2 (H02) ---
    # 1. GAUCHE (Rejet)
    H02 -> H02_rejet [label = <
      Rejet de H0\u2082 
    >]
    # 2. DROITE (Non rejet -> mène à H03)
    H02 -> H03 [label = <
      Non rejet de H0\u2082 
    >]
  
    # --- NIVEAU 3 (H03) ---
    # 1. GAUCHE (Rejet)
    H03 -> H03_rejet [label = <
      Rejet de H0\u2083 
    >]
    # 2. DROITE (Non rejet)
    H03 -> H03_non_rejet [label = <
      Non rejet de H0\u2083 
    >]
  
  }
')

graph_hsiao |> 
  DiagrammeRsvg::export_svg() |> 
  charToRaw() |> 
  rsvg::rsvg_png(here::here("02-codes", "presentations", "images", "hsiao-procedure.png"))

