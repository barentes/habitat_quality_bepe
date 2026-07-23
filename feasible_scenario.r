# AUTORA: BARBARA RENTES BARBOSA
# UNIVERSIDADE FEDERAL DE SÃO CARLOS - SOROCABA
# CONTATO = bahrentes@gmail.com

#Feasible scenario (properties that has predominance lulc PST and Mosaic of Uses)  AND  pt_ls_mr ≥ 1 OR pt_ls_hr ≥ 1 AND R_mean ≥ P75 OR P60 (depending on scenario)
# Number of properties = 248 (feasible25) / 631 (feasible50)

library(terra)

#Ler dados de entrada
uso <- rast("E:/DOUTORADO/BEPE/Bases_geograficas/es_sp_landuse_col9_30m_MAPBIOMAS_2023_A_UGRHI2buff1500.tif")
pol <- vect("E:/DOUTORADO/BEPE/Bases_geograficas/FEASIBLE/CUBO_b_prioridade_uso15e21_rest_mean_co_mean_Q3_631.shp")
clip_area <- vect("E:/DOUTORADO/Bases_geograficas/BASE/es_sp_UGRHI2_DAEE_2019_A.shp")  


# Criar raster com valores somente dentro dos polígonos
uso_mask <- mask(uso, pol)              # pixels outside the polygon=NA


# ETAPA 1 : Criar cenário "feasible"
#Substituir valores 15 e 21 por 99 dentro dos polígonos
vals <- values(uso_mask)
vals[vals %in% c(15, 21)] <- 99
values(uso_mask) <- vals


# Combinar com o raster original (cover mantém o original em áreas fora do polígono)
cenario <- cover(uso_mask, uso)


#ETAPA 2: Reclassificar (agrupar) usos do solo para INVEST (1 a 88 e 99)
#matriz de reclassificação
m <- c(3, 1,   # Formação Florestal -> 1
       12, 2,  # Formação Campestre -> 2
       29, 2,  # Afloramento Rochoso -> 2
       15, 3,  # Pastagem -> 3
       21, 3,  # Mosaico de Usos -> 3
       9, 4,   # Silvicultura -> 4
       20, 5,  # Cana -> 5
       39, 5,  # Soja -> 5
       41, 5,  # Outras Lavouras -> 5
       46, 5,  # Café -> 5
       48, 5,  # Outras Lavouras Perenes -> 5
       24, 6,  # Área Urbanizada -> 6
       25, 6,  # Outras Áreas não Vegetadas -> 6
       30, 7,  # Mineração -> 7
       31, 8,  # Aquicultura -> 8
       33, 8,  # Rio, Lago e Oceano -> 8
       99, 99) # Áreas de Intervenção -> 99

rcl_mat <- matrix(m, ncol=2, byrow=TRUE)

cenario_reclass <- classify(cenario, rcl_mat, others=NA)



# ETAPA 3: Exportação

cenario_clip <- mask(crop(cenario_reclass, clip_area), clip_area)  #clip

# Definir explicitamente o NoData como 0 para o arquivo de saída (opcional, mas seguro)
NAflag(cenario_clip) <- 0

writeRaster(cenario_clip,
            "E:/DOUTORADO/BEPE/Bases_geograficas/FEASIBLE/feasbile_scenario_631.tif",
            overwrite = TRUE,
            datatype = "INT1U")


# ---------- Cálculo de contagem de pixels e área -----------
library(terra)
library(knitr)

#Carregar o raster final que já foi salvo
cenario_clip <- rast("E:/DOUTORADO/BEPE/Bases_geograficas/FEASIBLE/feasbile_scenario_631.tif")

# Contar número de pixels por classe
pixel_count <- freq(cenario_clip)

# Se sua resolução é 30m:
# 30m x 30m = 900 m² = 0.09 ha
pixel_count$area_ha <- pixel_count$count * 0.09

#print(pixel_count)

# Mostrar no console em formato de tabela organizada
kable(pixel_count, align = "c", caption = "Contagem de pixels e área por classe")
