library(mr)

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
assert_number(usdhuf, lower = 250, upper = 500)

balance <- btcusdt[, .(date = as.Date(close_time), btcusdt = close, btchuf = close * usdhuf)]
balance[, value := BITCOINS * btchuf]
str(balance)

forint <- function(x) {
  dollar(x, prefix = '', suffix = 'Ft')
}

library(ggplot2)
ggplot(balance, aes(date, value)) + geom_line() + xlab('') + ylab('')+
  scale_y_continuous(labels = forint) + theme_bw() +
  ggtitle('My crypto fortune', subtitle = paste(BITCOINS, "Bitcoins"))



# get historical exchange rate
#GET https://api.exchangeratesapi.io/history?start_at=2020-04-13&end_at=2020-05-12 HTTP/1.1
a<- fromJSON('https://api.exchangeratesapi.io/history?start_at=2020-04-14&end_at=2020-05-13&latest?base=USD&symbols=HUF')$rates
b <- unlist(a)
b <- as.data.frame(b)
b

library(httr)
usdhuf <- GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 30,
    end_at = Sys.Date(),
    base = 'USD',
    symbols = 'HUF'
  )
)
usdhuf <- content(usdhuf)$rates
library(data.table)
usdhuf <- data.table(date = names(usdhuf), usdhuf = unlist(usdhuf))
setorder(usdhuf, date)
setkey(balance, date)
setkey(usdhuf, date)
balance <- usdhuf[balance, roll = TRUE]
merge(balance, usdhuf, by="date", all=TRUE)

balance <- btcusdt[, .(date = as.Date(close_time), btcusdt = close)]
balance[, value := BITCOINS * btchuf]
str(balance)

library(dplyr)
setDT(left_join(balance, usdhuf, by = c("date")))


## Report on the price of 0.42 BTC in the past 30 days (daily, line plot) in HUF
## PLEASE NOTE: USD/HUF has changed in the past 30 days

BITCOINS <- 0.42
log_info('Number of Bitoins: {BITCOINS}')

btcusdt <- binance_klines('BTCUSDT', '1d', limit = 30)

#usdhuf <- fromJSON(paste0('https://api.exchangeratesapi.io/history?start_at=', substr(btcusdt$close_time[1],1,10), '&end_at=', substr(btcusdt$close_time[nrow(btcusdt)],1,10), '&base=USD&symbols=HUF'))$rates

usdhuf <- GET(
  'https://api.exchangeratesapi.io/history?',
  query = list(
    start_at = Sys.Date() - 30,
    end_at = Sys.Date(),
    base = 'USD',
    symbols = 'HUF'
  )
)

usdhuf <- content(usdhuf)$rates

usdhuf <- data.table(date = as.Date(names(usdhuf)),
                     usdhuf = unlist(usdhuf))

setorder(usdhuf, date)

balance <- btcusdt[, .(date = as.Date(close_time),
                       btcusdt = close)] # . is shorthand for a list

merge(balance, usdhuf, by = 'date', all = TRUE) # rolling join is the solution

setkey(balance, date)
setkey(usdhuf, date)
balance <- usdhuf[balance, roll = TRUE]

balance[, btchuf := btcusdt * usdhuf]

balance[, value := BITCOINS * btchuf]

ggplot(balance, aes(date, value)) +
  geom_line() +
  xlab('') +
  ylab('') +
  scale_y_continuous(labels = forint) +
  theme_bw() +
  ggtitle('My crypto fortune', subtitle = paste(BITCOINS, 'Bitcoins'))


ggplot(balance) + geom_bar()

devtools::install_github('daroczig/dbr')
