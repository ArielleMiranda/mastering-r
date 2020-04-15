library(binancer)
library(data.table)
library(jsonlite)
library(logger)

#### push to github

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD in HUF: {usdhuf}')

btcusdt <-  binance_coins_prices()[symbol == 'BTC', usd]
log_info('The value of 1 Bitcoin in USD: {btcusdt}')

BITCOINS * btcusdt * usdhuf
