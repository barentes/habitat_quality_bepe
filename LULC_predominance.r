

#Uso do solo predominante por propriedade CUBO

library(terra)
library(sf)
library(exactextractr)

# Ler dados (ajuste o caminho)
CUBO <- st_read("E:/DOUTORADO/BEPE/Bases_geograficas/CUBO/CUBO_b_prioridade_rest_mean.shp")
uso_solo <- rast("E:/GIS/MAPBIOMAS/Colecao9/es_sp_landuse_col9_30m_MAPBIOMAS_2023_A.tif")

# Função para pegar a classe predominante dentro do polígono
classe_predominante <- function(values, coverage) {
  # coverage: fração da célula dentro do polígono
  w <- tapply(coverage, values, sum, na.rm = TRUE) # soma da área ponderada por classe
  as.numeric(names(w)[which.max(w)])               # retorna a classe com maior área
}

# Aplicar por polígono
CUBO$uso_23 <- exact_extract(uso_solo, CUBO, classe_predominante)

st_write(CUBO, "E:/DOUTORADO/BEPE/Bases_geograficas/CUBO/CUBO_b_prioridade_rest_mean_uso23.shp", append = FALSE, layer_options = "ENCODING=UTF-8")


head(CUBO)
plot(CUBO["R_mean"])
