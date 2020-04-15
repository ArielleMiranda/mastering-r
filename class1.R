library(binancer)
library(data.table)
library(jsonlite)
library(logger)
library(checkmate)
library(scales)
log_threshold(TRACE)

#### push to github

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD in HUF: {dollar(usdhuf, prefix ="", suffix = \' Ft\')}')

forint <- function(x) {
  dollar(x, prefix = '', suffix = 'Ft')
}

log_info('The value of 1 USD: {forint(usdhuf)}')

log_eval(usdhuf)
assert_number(usdhuf, lower = 250, upper = 500)


## sometimes binancer fails.. 
tryCatch(binance_coins_prices()[symbol == 'BTC', usd],
         error = function(e) {
           binance_coins_prices()[symbol == 'BTC', usd]
         })

# use diff function
get_bitcoin_price <- function(){}
get_bitcoin_price <- function(retried = 0) {
  tryCatch(binance_coins_prices()[symbol == 'BTC', usd],
           error = function(e) {
             # exponential backoff retries
             Sys.sleep(1)
             get_bitcoin_price(retried = retried + 1)})
}
get_bitcoin_price()

btcusdt <-  binance_coins_prices()[symbol == 'BTC', usd]
log_info('The value of 1 Bitcoin in USD: {dollar(btcusdt)}')
log_eval(btcusdt)
assert_number(btcusdt, lower = 1000)

log_info(BITCOINS * btcusdt * usdhuf) ## TODO formatting
log_eval(forint(BITCOINS * btcusdt * usdhuf))


## install the created package from github
library(devtools)
install_github('ArielleMiranda/mr')
