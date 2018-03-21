library("dplyr")
library("ggplot2")

################################################################################
### MATERIALY:
################################################################################

# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

################################################################################
### WCZYTAJ DANE:
################################################################################


dat <- read.table("R_data.csv", sep=",", quote="", header=TRUE)
head(dat)
View(dat)
names(dat)
################################################################################
### STRUKTURA WYKRESU:
################################################################################

# ggplot(ramka_z_danymi, aes(x = ?, y = ?, color = ?, fill = ?, label = ?, 
#                            shape = ?, size = ?)) +
#     geom_point(...) +
#     geom_bar(...) +
#     geom_line(...) +
#     geom_text(...) +
#     ...
#     coord_flip(...) +
#     ...
#     facet_grid(...) +
#     ...     
#     theme_(bw/minimal/gray/...) +
#         theme(axis.title = element_text(...),
#               axis.text = element_text(...),
#               legend.position = "top/bottom/...") +
#         labs(title = "...", x = "...", y = "...") +
#     ...
#     scale_y_manual(values = ..., name = "...", label = ...) +
#     scale_y_discrete() +
#     scale_y_continuous() +
#     scale_color_manual() +
#     ...

################################################################################
### GEOMETRIE:
################################################################################

# punktowy:

ggplot(dat, aes(x = surface, y = price)) +
  geom_point()


ggplot(dat, aes(x = surface, y = price, 
                 color = building_type)) +
  geom_point()

ggplot(dat, aes(x = surface, y = price, 
                 color = building_type, shape = market)) +
  geom_point()

ggplot(dat, aes(x = surface, y = price)) +
  geom_point() +
  geom_smooth()
?ggplot2
?geom_smooth
# liniowy:

ggplot(dat, aes(x = year_of_construction, y = price)) +
  geom_point()

dat %>% 
  group_by(year_of_construction) %>% 
  summarise(avg_price = mean(price)) -> dat_tmp

ggplot(dat_tmp, aes(x = year_of_construction, y = avg_price)) +
  geom_point() +
  geom_line()

# slupkowy:

ggplot(dat, aes(x = building_type)) +
  geom_bar()

dat %>% 
  group_by(building_type) %>% 
  summarise(count = n(),
            avg_price_meter = round(mean(price_meter))) -> dat_tmp

ggplot(dat_tmp, aes(x = building_type, y = count, label =  avg_price_meter)) +
geom_bar(stat = "identity") +
geom_text()


# boxplot:

ggplot(dat, aes(x = building_type, y = price_meter)) +
  geom_boxplot()

################################################################################
### COORD_FLIP + FACET_GRID:
################################################################################

# coord_flip:

ggplot(dat, aes(x = building_type, y = price_meter)) +
  geom_boxplot() +
  coord_flip()

# facet_grid:

ggplot(dat, aes(x = surface, y = price, shape = market)) +
  geom_point() +
  facet_grid(building_type ~ .)

ggplot(dat, aes(x = surface, y = price)) +
  geom_point() +
  facet_grid(building_type ~ market)

################################################################################
### THEME:
################################################################################

ggplot(dat %>% head(1000), 
       aes(x = surface, y = price, color = building_type, shape = market)) +
  geom_point() -> wyk

wyk + 
  theme_bw()

wyk + 
  theme_minimal()

wyk + 
  theme_linedraw()

wyk + 
  theme_bw() +
  ggtitle("Correlation between price and surface") +
  ylab("Price") +
  xlab("Surface [m2]")  # xlab(expression(paste("Surface [", m^{2}, "]")))

wyk + 
  theme_bw() +
  ggtitle("Correlation between price and surface") +
  ylab("Price") +
  xlab(expression(paste("Surface [", m^{2}, "]"))) +
  theme(axis.title.x = element_text(size = 20, family = "serif"),
        axis.text.y = element_blank(),
        legend.position = "left")

################################################################################
### SCALE:
################################################################################

ggplot(dat %>% head(1000), 
       aes(x = surface, y = price, color = building_type, shape = market)) +
  geom_point() +
  theme_minimal() +
  ggtitle("Correlation between price and surface") +
  ylab("Price") +
  xlab(expression(paste("Surface [", m^{2}, "]"))) +
  scale_y_continuous(limits = c(0, 4e6),
                     labels = function(x){format(x, scientific = FALSE, big.mark = " ", small.mark = " ")}) +
  scale_color_discrete(name = "Building type:") +
  scale_shape_manual(values = 4:5, name = "Market:")

