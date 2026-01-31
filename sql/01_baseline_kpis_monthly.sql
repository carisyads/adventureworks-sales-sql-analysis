-- Purpose: showing monthly beaseline KPIs (Orders, Revenue, Profit, AOV)
-- Database: postgresql
select 
	to_char(dd."calendardate", 'YYYY-mm') as MonthYear ,
	count(distinct t."orderkey") as total_order,
	ROUND(
		(SUM((t."OrderQuantity" * apl."ProductPrice")::numeric)/COUNT(distinct t."orderkey"))	
			,2
			) as "AOV",
	ROUND(
		SUM(
			(t."OrderQuantity" * apl."ProductPrice")::numeric)
			,2
			) total_price,
	ROUND(
		SUM(
			(t."OrderQuantity" * apl."ProductCost")::numeric)
			,2
			) total_cost,
	ROUND(
			(SUM((t."OrderQuantity" * apl."ProductPrice")::numeric) 
			- 
			SUM((t."OrderQuantity" * apl."ProductCost")::numeric))
			,2
			) profit
from 
	fact_sales t 
left join 
	"MySales"."DimDate" dd on t."DateKey" =dd."datekey"
left join 
	"MySales"."adventureworks_product_lookup" apl on t."ProductKey" = apl."ProductKey" 
group by 
	to_char(dd."calendardate", 'YYYY-mm')
order by 
	to_char(dd."calendardate", 'YYYY-mm');
