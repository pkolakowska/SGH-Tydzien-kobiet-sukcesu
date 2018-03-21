install.packages("plotly")
install.packages("leaflet")
library(leaflet)
library(plotly)
library(viridis)

#load("data/dane_czyste_2017-08-25.Rdata")

## GGplot2 => plotly
ggplotly()

dat <- dat[1:1000,]

## Prosty wykres
plot_ly(data = dat, x = ~surface, y = ~price,
        color = ~building_type)

## Zmienmy kolory
n_colors <- length(unique(dat$building_type))

plot_ly(data = dat, x = ~surface, y = ~price,
        color = ~building_type, colors =  magma(n_colors))

## Tooltip
plot_ly(data = dat, x = ~surface, y = ~price,
        color = ~building_type, colors =  viridis(n_colors),
        text = ~paste("Surface: ",
                      surface, 'm2<br>Price:', price, 'PLN'))

## Dodajmy rozmiar kropek
plot_ly(data = dat, x = ~surface, y = ~price,
        color = ~building_type, colors =  viridis(n_colors),
        text = ~paste("Surface: ", surface,
                      'm2<br>Price:', price, 'PLN<br>Number of rooms: ',
                      rooms),
        size = ~rooms)

## Ostylujmy
plot_ly(data = dane, x = ~surface, y = ~price, color = ~building_type, colors =  viridis(n_colors),
        text = ~paste("Surface: ", surface, 'm2<br>Price:', price, 'PLN'),
        size = ~rooms) %>% 
  layout(title = 'Surface vs. price',
         yaxis = list(title = "Price in PLN"),
         xaxis = list(title = "Surface in m2"))

## Wykres s³upkowy
house_type_price <- dat %>%
  group_by(building_type) %>%
  summarise(mean_price = mean(price), max_price =  max(price)) %>%
  arrange(-mean_price)

plot_ly(house_type_price, x = ~building_type, y = ~mean_price,
        type = 'bar', name = "avarage price") %>% 
  add_lines(y = ~max_price, x = ~building_type, yaxis = "y2",
            name = "minimal price") %>% 
  layout(yaxis2 = list(
    overlaying = "y",
    side = "right",
    range = c(0, 4e6)),
    yaxis = list(range = c(0, 4e6))
  )

## Posortujmy
plot_ly(house_type_price, x = ~building_type,
        y = ~mean_price, type = 'bar') %>% 
  layout(xaxis = list(categoryarray = ~names, categoryorder = "array"))


dat %>%
  leaflet() %>% 
  addTiles()

dat %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng = ~lon, lat = ~lat, popup = ~paste("Price:", price))

dat[1:10, ] %>% leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addMarkers(lng = ~lon, lat = ~lat, popup = ~paste("Price", price))

pal <- colorFactor(viridis(6), levels = unique(dat$building_type))
pal <- colorNumeric(viridis(nrow(dat)), domain = dat$price)

dat[1:50, ] %>% leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircleMarkers(lng = ~lon, lat = ~lat,
                   popup = ~paste("Price", price),
                   color = ~pal(price))

