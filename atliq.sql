SELECT year(fs.date) as year, MONTHNAME(fs.date) as month,
sum(fs.sold_quantity*gp.gross_price) as gross_total_price 
FROM gdb023.fact_sales_monthly fs 
  left join gdb023.fact_gross_price gp on fs.product_code=gp.product_code 
  left join gdb023.dim_customer dc on dc.customer_code= fs.customer_code
 where customer="Atliq Exclusive"
group by year,month
order by year,month DESC;

with gross_cte AS(
SELECT dc.channel, 
sum(fs.sold_quantity*gp.gross_price) as gross_total_price
FROM gdb023.fact_sales_monthly fs 
  left join gdb023.fact_gross_price gp on fs.product_code=gp.product_code 
  left join gdb023.dim_customer dc on dc.customer_code= fs.customer_code
group by dc.channel
order by dc.channel DESC)
SELECT channel,gross_total_price,
ROUND(gross_total_price*100/ (select sum(gross_total_price) from gross_cte),1) as percentage FROM gross_cte
LIMIT 1;



