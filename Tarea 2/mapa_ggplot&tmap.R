################
### Tarea 5 ####
################

setwd("/Users/fernandacortes/Desktop/Herramientas/Clase5/videos2_3")
library(rgdal)
lnd <- readOGR(dsn = "data/london_sport.shp")


crime_data <- read.csv("data/mps-recordedcrime-borough.csv",
                       stringsAsFactors = FALSE)
crime_theft <- crime_data[crime_data$CrimeType == "Theft & Handling", ]
crime_ag <- aggregate(CrimeCount ~ Borough, FUN = sum, data = crime_theft)
lnd$name %in% crime_ag$Borough
lnd$name[!lnd$name %in% crime_ag$Borough]
library(dplyr)
lnd@data <- left_join(lnd@data, crime_ag, by = c('name' = 'Borough'))


# TMAP

lnd$Pop_2001 <- as.numeric(as.character(lnd$Pop_2001))
lnd$data$theft_pc <-lnd$data$CrimeCount/lnd$data$Pop_2001*100000


library(tmap)
map_thefts0 <- qtm(shp = lnd, fill = "theft_pc", fill.palette = "Blues", fill.title = "Thefts per 100.000 inhabitans", text = 'name', text.size = 0.5)+
  tm_layout(main.title = "Thefts in London", title.size = 0.5, title.position = c("right", "top"), legend.outside = TRUE)+
  tm_scale_bar(position = c("right", "bottom"), width = 0.1)+
  tm_compass(position = c("right", "top"), size = 2)
map_thefts0

tmap_save(map_thefts0, "tmap.png")

#--------------------------------------------------------------------------------

library(broom)
lnd$id <- row.names(lnd)
library(dplyr)
lnd_f <- left_join(lnd_f, lnd@data)
ltidy <- rename(ltidy, ons_label = Area.Code)
lnd_f <- left_join(lnd_f, ltidy)

lnd_f$Pop_2001 <- as.numeric(as.character(lnd_f$Pop_2001))
lnd_f$theft_pc <- lnd_f$CrimeCount/lnd_f$Pop_2001*100000

para_labels <- read.csv("/Users/fernandacortes/Desktop/Herramientas/Clase5/labels.csv",
                        stringsAsFactors = FALSE)

# GGPLOT

map_thefts <- ggplot(lnd_f, aes(long, lat, group = group, fill = theft_pc)) +
  geom_polygon(color = "black", size = 0.2) + coord_equal() +
  labs(x = "Longitud", y = "Latitud",
       fill = "Thefts per 100.000 inhabitans", subtitle = "Per 100.000 inhabitants") +
  ggtitle("Thefts in London")+
  scale_fill_gradient(low = "lightblue", high = "darkblue")+
  annotation_scale() +
  annotation_north_arrow(location='tr', height = unit(0.7, "cm"),
                         width = unit(0.8, "cm"))
map_thefts <- map_thefts + geom_text(data=para_labels,aes(label = name, x = x_c, y = y_c),size = 1.5,inherit.aes = FALSE) 
map_thefts

ggsave("map_theftsggplot.png")

