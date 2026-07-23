# AUTORA: BARBARA RENTES BARBOSA
# UNIVERSIDADE FEDERAL DE SÃO CARLOS - SOROCABA
# CONTATO = bahrentes@gmail.com

# Articles (10) derived from the literature review - Threats analysis

#Answers:
# Which threats are most commonly used?
# Which have the greatest absolute impact?
# Which dominate the internal hierarchy?
# Does a consistent pattern exist?

library(readxl)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(forcats)

# Importar dados
dados <- read_excel("E:/DOUTORADO/BEPE/Web of Science/meta_analysis_from_savedrecs_10_atual.xlsx")

#colnames(dados)

#str(dados)

#Conferência rápida

summary(dados$T_weight)
summary(dados$T_max_dist_km)

any(dados$T_weight > 1)
any(dados$T_weight < 0)


# Fequency analysis for each threat
# Se no mesmo artigo aparece uma ameaça mais de uma vez (como o caso do artigo 36) ele vai contar apenas como 1

freq_threat <- dados %>%
  distinct(ID_article, padr_threat) %>%
  count(padr_threat, sort = TRUE) %>%
  mutate(percent = n / n_distinct(dados$ID_article) * 100)

#freq_threat

# Weight (T_weight) statistics
# Dentro de cada artigo, cada ameaça apareça apenas uma vez com seu valor máximo eu fiz o teste e mesmo se contar mais de uma vez a diferença não é grande)
  
stats_weight <- dados %>%
  group_by(ID_article, padr_threat) %>%
  summarise(
    T_weight = max(T_weight, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  
  # Sobre os dados consolidados
  group_by(padr_threat) %>%
  summarise(
    n = n(), # Agora este 'n' é o número de artigos 
    mean = mean(T_weight, na.rm = TRUE),
    median = median(T_weight, na.rm = TRUE),
    sd = sd(T_weight, na.rm = TRUE),
    min = min(T_weight, na.rm = TRUE),
    max = max(T_weight, na.rm = TRUE),
    IQR = IQR(T_weight, na.rm = TRUE)
  ) %>%
  arrange(desc(median))



  #Boxplot wheights ro show consensus, variability, outliers and visual hierarchy
#todas as ameaças
ggplot(dados, aes(x = fct_rev(padr_threat), y = T_weight)) +
  geom_boxplot(fill = "orange", color = "black") +
  coord_flip() +
  labs(
    x = "Threat", 
    y = "Weight",
  ) +
  theme_bw()

# BOXPLOT PARA AMEAÇAS DE INTERESSE
ameacas_interesse <- c("Agriculture", "Forest plantation", "Mining", "Pasture", "Rail", "Roads", "Urban areas")

dados %>%
  filter(padr_threat %in% ameacas_interesse) %>% 
  ggplot(aes(x = fct_rev(padr_threat), y = T_weight)) +
  geom_boxplot(fill = "orange", color = "black") +
  coord_flip() +
  labs(
    x = "Threat", 
    y = "Weight"
  ) +
  theme_bw()


# Distance (T_max_dist_km) statistics 
stats_dist <- dados %>% 
group_by(ID_article, ameacas_interesse) %>%
  summarise(
    T_max_dist_km = max(T_max_dist_km, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  
  # BOXPLOT PARA AMEAÇAS DE INTERESSE
  
ameacas_interesse <- c("Agriculture", "Forest plantation", "Mining", "Pasture", "Rail", "Roads", "Urban areas")

dados %>%
  filter(padr_threat %in% ameacas_interesse) %>% 
  ggplot(aes(x = fct_rev(padr_threat), y = T_max_dist_km)) +
  geom_boxplot(fill = "green", color = "black") +
  coord_flip() +
  labs(
    x = "Threat", 
    y = "Distance (km)"
  ) +
  theme_bw()
  
  
  # Sobre os dados consolidados
  group_by(padr_threat) %>%
  summarise(
    n = n(),
    mean = mean(T_max_dist_km, na.rm = TRUE),
    median = median(T_max_dist_km, na.rm = TRUE),     # IMPORTANT
    sd = sd(T_max_dist_km, na.rm = TRUE),
    min = min(T_max_dist_km, na.rm = TRUE),
    max = max(T_max_dist_km, na.rm = TRUE),
    IQR = IQR(T_max_dist_km, na.rm = TRUE)           # IMPORTANT
  ) %>%
  arrange(desc(median))
  


#stats_dist

  #Boxplot distance ro show consensus, variability, outliers and visual hierarchy

ggplot(dados, aes(x = fct_rev(padr_threat), y = T_max_dist_km)) +
  geom_boxplot(fill = "steelblue", alpha = 0.7) +
  coord_flip() +
  labs(x = "Threat", y = "Distance (km)") +
  theme_minimal()

  # Internal hierarchy 

# Consolidando para garantir que cada ameaça conte apenas 1x por artigo considerando seu valor maximo de peso
dados_comp <- dados %>%
  group_by(ID_article, padr_threat) %>%
  summarise(T_weight = max(T_weight, na.rm = TRUE), .groups = "drop")
  
  # 1. Internal rank for EACH article (inside each article the threat with highest T_eight receive rank_interno=1)
dados_rank <- dados_comp %>%
  group_by(ID_article) %>%
  mutate(rank_interno = rank(-T_weight, ties.method = "min")) %>%
  ungroup()

  # 2. How many threats are "Rank 1" internally (on step 1) (Which threats were the MOST significant within each individual article?)
  #If there are two threats with same weights, both receive Rank 1.
rank1 <- dados_rank %>%
  filter(rank_interno == 1) %>%
  group_by(padr_threat) %>%
  summarise(
    n = n(),                           # How many times is Rank 1
    avg_weight_at_top = mean(T_weight) # Peso médio quando está no topo
  ) %>%
  arrange(desc(n))

    # Checking if two or more threats has the same highest weight and which one is
dados %>%
  group_by(ID_article) %>%
  summarise(max_weight = max(T_weight),
            n_max = sum(T_weight == max_weight)) %>%
  filter(n_max > 1)

  # Percentage of how many times when is "Rank 1" (considering only in articles where it appears)
  # It answers "When this threat appears, is it usually the most important one?"
  # Sempre que essa ameaça aparece, qual a chance de ela ser a número 1?
rank_percent <- dados_rank %>%
  group_by(padr_threat) %>%
  summarise(
    vezes_rank1 = sum(rank_interno == 1),
    total_aparece = n_distinct(ID_article),
    perc_rank1 = vezes_rank1 / total_aparece * 100
  ) %>%
  arrange(desc(perc_rank1))

  # Relative difference within the article (Removes scaling effect)
  # If mean_diff > 0: This threat is generally scored above average in the articles where it appears. It is seen as a priority or dominant threat.
  # If mean_diff < 0: This threat is generally scored below the article average. It is seen as a secondary threat.

  # Which threats are consistently considered more important than others
dados_rel <- dados_comp %>%                    # Interno
  group_by(ID_article) %>%
  mutate(
    median_art = median(T_weight, na.rm = TRUE),
    diff_center = T_weight - median_art
  ) %>%
  ungroup()

rel_summary <- dados_rel %>%  #Com relação à ameaça em todos os artigos em que aparece
  group_by(padr_threat) %>%
  summarise(
    mean_diff = mean(diff_center, na.rm = TRUE),
    n_artigos = n()
  ) %>%
  mutate(
    threat_status = case_when(
      mean_diff > 0.1  ~ "High Dominance",
      mean_diff > 0    ~ "Slightly Dominant",
      mean_diff < -0.1 ~ "High Secondary",
      TRUE             ~ "Secondary/Neutral"
    )
  ) %>%
  arrange(desc(mean_diff))


#Dominant: Acima do 3º Quartil (Q3).
#Typical: Entre a média e o Q3.
#Secondary: Abaixo da média.



# Comparação Direta (Agriculture vs. Urban)

# 1. Preparar os dados consolidados (Max por artigo/ameaça)
# Vamos focar apenas nas duas ameaças de interesse
comp_par_dados <- dados %>%
  filter(padr_threat %in% c("Agriculture", "Urban areas")) %>%
  group_by(ID_article, padr_threat) %>%
  summarise(T_weight = max(T_weight, na.rm = TRUE), .groups = "drop") %>%
  # Transformar em formato "largo" (uma coluna para cada ameaça)
  pivot_wider(names_from = padr_threat, values_from = T_weight) %>%
  # Remover artigos que só tinham uma das duas
  filter(!is.na(Agriculture) & !is.na(`Urban areas`))

# 2. Criar a coluna de comparação
resultado_comparativo <- comp_par_dados %>%
  mutate(
    vencedora = case_when(
      Agriculture > `Urban areas` ~ "Agriculture is heavier",
      `Urban areas` > Agriculture ~ "Urban areas is heavier",
      TRUE                        ~ "Equal Weights"
    )
  )

# 3. Resumo estatístico do padrão
padrao_final <- resultado_comparativo %>%
  count(vencedora) %>%
  mutate(percentual = n / sum(n) * 100)


#Visualizações

n_distinct(dados$padr_threat) # Numero de ameaças únicas


View(freq_threat)

View(stats_weight)
View(stats_dist)

View(dados_rank)
View(rank1)
View(rank_percent)

View(dados_rel)
View(rel_summary)


View(padrao_final)

n_distinct(dados$ID_article)
View(dados)


getwd()

write.csv(freq_threat, "freq_threat.csv", row.names = FALSE, fileEncoding = "UTF-8")
write.csv(stats_weight, "stats_weight", row.names = FALSE, fileEncoding = "UTF-8")
write.csv(stats_dist, "stats_dist", row.names = FALSE, fileEncoding = "UTF-8")
write.csv(rank_percent, "rank_percent", row.names = FALSE, fileEncoding = "UTF-8")
