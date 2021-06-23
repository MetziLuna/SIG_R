# Copyright (C) Metzi Aguilar
# This file is part of dogtag <https://github.com/MetziLuna/SIG_R/>.
#
# SIG_R is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SIG_R is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dogtag.  If not, see <http://www.gnu.org/licenses/>.

############################## PLOT

library(tidyr)
library(dplyr)
library(sf)

# Data frame de casos activos por cantón, con fechas en las columnas
# Lectura de la capa de cantones de un archivo GeoJSON
sf_municipios <-
  st_read(
    "https://raw.githubusercontent.com/MetziLuna/Datos_SV/main/municipios.geojson", 
    quiet = T
  )
# Seleccionamos paleta de 7 colores de Color rojo
library(RColorBrewer)
pal <- brewer.pal(6, "OrRd") 
class(pal)

# Mapeo cuantitativo de la población usando método Cuantiles con 7 clases
plot(sf_municipios["densidad"], main = "Población total por municipio 2007",
     breaks = "quantile", 
     nbreaks = 6,
     pal = pal,
     axes = TRUE,
     graticule = TRUE
)

summary(sf_municipios["densidad"])

############################## GGPLOT
library(ggplot2)
ggplot(sf_municipios) + 
  geom_sf(aes(fill=densidad))

library(classInt)

# get quantile breaks. Add .00001 offset to catch the lowest value
breaks_qt <- classIntervals(c(min(sf_municipios$densidad) - .00001, sf_municipios$densidad), n = 6, style = "quantile")

breaks_qt

sf_municipios <- mutate(sf_municipios, densidad_cat = cut(densidad, breaks_qt$brks))

ggplot(sf_municipios) + 
  geom_sf(aes(fill=densidad_cat)) +
  scale_fill_brewer(palette = "OrRd")

## Mapa estático con GGMAP

library(ggmap)

us <- c(left = -90.233, bottom = 13, right = -87.5, top = 14.456)
#bbox <- expand_bbox(st_bbox(nc_centers), X = -89.09389, Y =  13.998889)
#location=c(lon = -89.09389, lat = 13.998889)
ph_basemap <- get_stamenmap(us, zoom=8, maptype = 'terrain', source = 'osm')

#  Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL.
#ggmap(ph_basemap)
ggmap(ph_basemap) +
  geom_sf(data = sf_municipios, aes(alpha = 0.8, fill=densidad_cat), inherit.aes = FALSE) +
  scale_fill_brewer(palette = "OrRd") +   coord_sf(crs = st_crs(4326))

############################## TMAP

library(tmap)
tm_shape(sf_municipios) +
  tm_polygons("densidad", 
              style="quantile", 
              title="Densidad poblacional El Salvador 2007, cuantiles")
tmap_mode("view")
tmap_last()

tm_shape(sf_municipios) +
  tm_polygons("densidad", 
              style="jenks", 
              title="Densidad poblacional El Salvador 2007, jenks")
tmap_mode("view")
tmap_last()

tm_shape(sf_municipios) +
  tm_polygons("densidad", 
              style="equal", 
              title="Densidad poblacional El Salvador 2007, intervalo igual")
tmap_mode("view")
tmap_last()

tm_shape(sf_municipios) +
  tm_polygons("densidad", 
              style="pretty", 
              title="Densidad poblacional El Salvador 2007, pretty")
tmap_mode("view")
tmap_last()

