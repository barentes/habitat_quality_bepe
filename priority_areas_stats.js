// AUTORA: BARBARA RENTES BARBOSA
// UNIVERSIDADE FEDERAL DE SÃO CARLOS - SOROCABA
// CONTATO = bahrentes@gmail.com
// Data da última atualização: 07/11/2025

// ESTATÍSTICAS DOS MAPA FINAL

// Carregar raster critério 
var imageCONS = ee.Image('projects/ee-doc/assets/es_sp_biodiversidade_wlc_cons_025_ext_v2');
//var imageREST = ee.Image('projects/ee-doc/assets/es_sp_biodiversidade_wlc_rest_020_ext_v2')
var imageREST = ee.Image('projects/ee-doc/assets/es_sp_biodiversidade_wlc_rest_020_ext_v2_UGRHI2')

// Definir uma geometria para reduzir a região, aqui usamos a extensão da imagem
var geometry = imageCONS.geometry();

// Calcular estatísticas descritivas: média, mediana e desvio padrão
var extendedStatsREST = imageREST.reduceRegion({
  reducer: ee.Reducer.mean()
    .combine(ee.Reducer.median(), '', true)
    .combine(ee.Reducer.stdDev(), '', true)
    .combine(ee.Reducer.minMax(), '', true) // Mínimo e máximo
    .combine(ee.Reducer.mode(), '', true) // Moda
    .combine(ee.Reducer.skew(), '', true) // Assimetria
    .combine(ee.Reducer.kurtosis(), '', true), // Curtose
  geometry: geometry,
  scale: 30,
  maxPixels: 1e9
});

// Calcular os percentis
var percentisREST = imageREST.reduceRegion({
  reducer: ee.Reducer.percentile([1, 10, 20, 25, 30, 40, 50, 60, 61, 62, 65, 66, 67, 68, 70, 75, 80, 85, 86, 87, 90, 95, 99]),
  geometry: geometry,
  scale: 30,
  maxPixels: 1e9
});

// Imprimir os resultados no console
print('Estatísticas estendidas REST:', extendedStatsREST);
print('Percentis REST:', percentisREST);
