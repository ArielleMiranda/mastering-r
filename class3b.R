download.file('http://bit.ly/CEU-R-ecommerce', 'ecommerce.zip', mode='wb')
unzip('ecommerce.zip')

# do this in terminal: 
# ls -l
# sqlite3 ecommerce.sqlite3
# .TABLES
# .schema sales
# SELECT * FROM sales LIMIT 5;
# .headers on
# .mode column
# SELECT * FROM sales LIMIT 5;

## count number of rows in January 2011
#  select count(1), substr(invoicedate,1,2)||substr(invoicedate,7,4) as dt from sales group by substr(invoicedate,1,2)||substr(invoicedate,7,4);
#  select count(1) from sales where substr(invoicedate,1,2)||substr(invoicedate,7,4) = '012011';

## count number of rows per month

library(dbr)
options('dbr.db_config_path' = 'week3.yaml')
options('dbr.output_format' = 'data.table')

sales <- db_query('SELECT * FROM sales', 'ecommerce')
str(sales)

sales[,sample(InvoiceDate, 25)]
sales <- sales[,InvoiceDate := as.POSIXct(InvoiceDate, format= "%m/%d/%Y %H:%M")]

## invoice summary
invoices <- sales[,.(date = min(as.Date(InvoiceDate)),
                    value = sum(Quantity*UnitPrice)),
                    by=list(InvoiceNo, CustomerID,Country, InvoiceDate )]
str(invoices)
db_insert(invoices, 'invoices', 'ecommerce')

invoices <- db_query('SELECT * from invoices', 'ecommerce')
invoices[, date := as.Date(date, origin = '1970-01-01')]
str(invoices)

## report in Excel on daily revenue
revenue <- invoices[, .(revenue = sum(value)), by = date]

library(openxlsx)
wb <- createWorkbook()
sheet <- 'Revenue'
addWorksheet(wb, sheet)
writeData(wb, sheet, revenue)

freezePane(wb, sheet, firstRow = TRUE)
poundstyle <- createStyle(numFmt = '$0,000.00')
addStyle(wb, sheet, poundstyle,
         cols = 2, rows = 1:nrow(revenue),
         gridExpand = TRUE)

#openXL(wb)
filename <- 'report.xlsx'
saveWorkbook(wb, filename, overwrite = TRUE)


