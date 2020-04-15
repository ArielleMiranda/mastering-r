library(binancer)
library(data.table)
library(jsonlite)
library(logger)
library(checkmate)

#### push to github

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD in HUF: {usdhuf}')
assert_number(usdhuf, lower = 250, upper = 500)


## sometimes binancer fails.. 
tryCatch(binance_coins_prices()[symbol == 'BTC', usd],
         error = function(e) {
           binance_coins_prices()[symbol == 'BTC', usd]
         })

# use diff function
get_bitcoin_price <- function(){}
get_bitcoin_price <- function() {
  tryCatch(binance_coins_prices()[symbol == 'BTC', usd],
           error = function(e) get_bitcoin_price())
}
get_bitcoin_price()

btcusdt <-  binance_coins_prices()[symbol == 'BTC', usd]
log_info('The value of 1 Bitcoin in USD: {btcusdt}')
assert_number(btcusdt, lower = 1000)

BITCOINS * btcusdt * usdhuf
