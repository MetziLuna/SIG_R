# Copyright (C) Metzi Aguilar
# This file is part of SIG_R <https://github.com/MetziLuna/SIG_R/>.
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
# along with SIG_R.  If not, see <http://www.gnu.org/licenses/>.

library(leaflet) 

# Data frame de municipios
# Lectura de la capa de municipios de El Salvador desde un archivo GeoJSON
sf_municipios <-
  st_read(
    "https://raw.githubusercontent.com/MetziLuna/Datos_SV/main/municipios.geojson", 
    quiet = T
  )

pal_fun <- colorQuantile("YlOrRd", NULL, n = 5)

p_popup <- paste0("<strong>Densidad: </strong>", sf_municipios$densidad)

leaflet(sf_municipios) %>%
  addPolygons(
    stroke = FALSE, # remove polygon borders
    fillColor = ~pal_fun(densidad), # set fill color with function from above and value
    fillOpacity = 0.8, smoothFactor = 0.5, # transparencia y suavización
    popup = p_popup,
    group = "municipios") %>%
  addTiles(group = "OSM") %>%
  addProviderTiles("CartoDB.DarkMatter", group = "Carto") %>%
  addLegend("bottomright",  # location
            pal=pal_fun,    # palette function
            values=~densidad,  # value to be passed to palette function
            title = 'Densidad poblacional 2007')%>%
  addLayersControl(baseGroups = c("OSM", "Carto"), 
                   overlayGroups = c("municipios"))  
