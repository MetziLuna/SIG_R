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
library(tidyr)
library(dplyr)
#lectura de sismos de El Salvador ocurridos en un período de 10 años. Fuente: Ministerio de Medio Ambiente de El Salvador (MARN)
df_sismos <- 
  read.csv(
    "https://raw.githubusercontent.com/BigDreamsCoders/Tremor/master/static/Sismos-el-salvador.csv")
# first 100 quakes
df.100 <- df_sismos[1:100,]

#Obtención de la latitud, longitud y magnitud de los sismos
lat = df.100$Latitud.N...
long = df.100$Longitud.W...
mag = df.100$Magnitud


mutate(df.100, group = cut(mag, breaks = c(0, 4, 5, Inf), labels = c("azul", "verde", "rojo"))) -> df.100

### iconos creados a partir de la imagen https://raw.githubusercontent.com/lvoogdt/Leaflet.awesome-markers/master/dist/images/markers-soft.png
quakeIcons <- iconList(azul = makeIcon("https://raw.githubusercontent.com/MetziLuna/Img/main/icono_azul.png", iconWidth = 24, iconHeight =32),
                       verde = makeIcon("https://raw.githubusercontent.com/MetziLuna/Img/main/icono_verde.png", iconWidth = 24, iconHeight =32),
                       rojo = makeIcon("https://raw.githubusercontent.com/MetziLuna/Img/main/icono_rojo.png", iconWidth = 24, iconHeight =32))

leaflet(df.100) %>% addTiles() %>% setView(-89.09389,13.998889, zoom = 8)%>%
addTiles() %>%
addMarkers(~long, ~lat, icon = ~quakeIcons[group])


