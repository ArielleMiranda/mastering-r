library(binancer)
library(data.table)
library(jsonlite)
library(httr)

# 1. We have 0.42 Bitcoin. Let's write an R script reporting on the current value of this asset in USD.
a <- as.data.table(binance_coins_prices(unit = "USDT"))
a[symbol =='BTC', 'usd'] * 0.42

# 2. Report on the current price of 0.42 BTC in HUF
## solution 1: run in terminal: GET https://api.exchangeratesapi.io/latest?base=USD HTTP/1.1
a[symbol =='BTC', 'usd'] * 0.42 * 350.7

## solution 2: 
resp<-GET("https://api.exchangeratesapi.io/latest?base=USD")
exch_rates<-content(resp,as="parsed") 
exch_rates$rates$HUF
a[symbol =='BTC', 'usd'] * 0.42 * exch_rates$rates$HUF

## solution 3: 
usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
0.42 * binance_coins_prices()[symbol == 'BTC', usd] * usdhuf

## solution 4: 
0.42 * binance_coins_prices()[symbol == 'BTC', usd] * fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF

