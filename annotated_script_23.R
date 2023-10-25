# # R DATA VISUALIZATION WORKSHOP CDSI----------
# March 8, 2023
# Violet Massie-Vereker
# edited by Jake Lawlor


# packages ----------------------------------------------------------------
# install.packages("dplyr")
# install.packages("ggplot2")


library(dplyr)
library(ggplot2)



# get mpg data ------------------------------------------------------------
data(mpg)
mpg
mpg %>% glimpse()
mpg %>% head()

# read about the dataset here:
# https://ggplot2.tidyverse.org/reference/mpg.html


# plot one variable -------------------------------------------------------

mpg %>% ggplot()
# you'll notice a blank box appears in your plot screen
# that's becuase we initiated ggplot, but didint' give it any directions

# we need to add a variable to be on the X axis

mpg %>%
  ggplot(aes(x=hwy)) +
  geom_histogram()

mpg %>%
  ggplot(aes(x=hwy)) +
  geom_density()

mpg %>%
  ggplot(aes(x=hwy)) +
  geom_freqpoly()

mpg %>%
  ggplot(aes(x=hwy)) +
  geom_histogram() +
  geom_freqpoly() 


# now plot one discrete variable
mpg %>%
  ggplot(aes(x = class)) + 
  geom_bar()





# plot two variables - discrete and numeric ------------------------------------------------------

mpg %>%
  ggplot(aes(x=manufacturer, y=hwy)) +
  geom_boxplot()


mpg %>%
  ggplot(aes(x=class, y=hwy)) +
  geom_boxplot()



#one discrete variable, one continuous variable
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy))

#two variables, continuous
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#aesthetics----------
#colour 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


#size 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

#labels----------------------
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )

#annotations
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

label <- mpg %>%
  summarise(
    displ = max(displ),
    hwy = max(hwy),
    label = "Increasing engine size is \nrelated to decreasing fuel economy."
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")

#scales------------------
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

#this is what defaults are that R fills in
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()

#axis ticks and legend keys
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")


#overplotting----------------------
#group
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

#facet
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)



#themes--------------
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()

#zooming--------------
ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

mpg %>%
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()


#saving-----------------------
ggsave("my-plot.pdf")
#> Saving 7 x 4.33 in image