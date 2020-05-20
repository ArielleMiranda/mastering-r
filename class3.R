install.packages("profvis")
library(profvis)
library(data.table)
library(dplyr)

profvis({
  get_bitcoin_price()
})

profvis({
  library(ggplot2)
  x <- ggplot(diamonds, aes(price, carat)) + geom_point()
  print(x)
})

dt <- data.table(diamonds)

profvis({
  dt[,sum(carat), by = color][order(color)]
  group_by(dt, color) %>% summarize(v1 = sum(carat))
})


library(microbenchmark)
microbenchmark(
  dt[,sum(carat), by = color][order(color)],
  group_by(dt, color) %>% summarize(v1 = sum(carat)),
  times = 100
)
