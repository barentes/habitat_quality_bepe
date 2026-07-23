# AUTORA: BARBARA RENTES BARBOSA
# UNIVERSIDADE FEDERAL DE SÃO CARLOS - SOROCABA
# CONTATO = bahrentes@gmail.com
# Data da última atualização: 07/11/2025

/#Valor médio de prioridade por propriedade

# Pacotes
library(terra)
library(exactextractr)
library(sf)

# 1. Carregar os dados -----------------------------------------


# Polígonos
CUBO <- st_read("E:/DOUTORADO/BEPE/Bases_geograficas/CUBO/es_sp_codflo_vfinal_saa201911_tensao_cerrado_sma_cubo_135var_PARAIBA.shp")   # objeto sf

# Raster de prioridade
b_prioridade_rest <- rast("E:/DOUTORADO/Bases_geograficas/1_BANCO_DADOS_BASE_CRITERIOS/1_BIODIVERSIDADE/es_sp_biodiversidade_wlc_rest_020_ext_v2.tif")   # SpatRaster

# 2. Cálculo da média da prioridade por polígono ----------------

# exact_extract pode receber SpatRaster + sf diretamente
mean <- exact_extract(b_prioridade_rest, CUBO, "mean")


# 3. Adicionar os resultados ao shapefile ------------------------

CUBO$R_mean <- mean


# 4. Exportar o shapefile com o novo campo -----------------------

st_write(CUBO, "E:/DOUTORADO/BEPE/Bases_geograficas/CUBO/CUBO_b_prioridade_rest_mean.shp", append = FALSE)

getwd()


# ======================================================================================#

# Cálculo de estatística do campo "R_mean"


library(sf)

# Caminho do shapefile
shp <- st_read("E:/DOUTORADO/BEPE/Bases_geograficas/CUBO/CUBO_b_prioridade_rest_mean.shp")

#Indicar nome da coluna
vals <- shp$R_mean

# Criar a tabela com estatísticas
tabela_resultados <- data.frame(
  Estatistica = c("Média", "Mediana", "1º Quartil (Q1)", "2º Quartil (Q2)", "3º Quartil (Q3)"),
  Valor = c(
    mean(vals, na.rm = TRUE),
    median(vals, na.rm = TRUE),
    quantile(vals, 0.25, na.rm = TRUE),
    quantile(vals, 0.5, na.rm = TRUE),
    quantile(vals, 0.75, na.rm = TRUE)
  )
)

# Mostrar a tabela
tabela_resultados
