SELECT * FROM customer_shopping
LIMIT 10;

--Q1. what is the total revenue generatedby male vs female customers?
select gender, sum(purchase_amount_usd) as revenue
from customer_shopping
group by gender;

--Q2 which customers used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount_usd
from customer_shopping
where discount_applied = 'Yes' and purchase_amount_usd >=(select avg(purchase_amount_usd) from customer_shopping)

--Q3. which are the top 5 products with the highest average review rating?
select item_purchased, avg(review_rating::numeric),2 as "Average Product Rating"
from customer_shopping
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4. Compare the average Purchase Amounts between Standard and Express shipping.
select shipping_type,
round(avg(purchase_amount_usd),2)
from customer_shopping
where shipping_type in('Standard','Express')
group by shipping_type

--Q5. Do subscribed customers spend more? compare average and total revenue
--between subscibers and non-subscribers.
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount_usd),2) as avg_spend,
round(sum(purchase_amount_usd),2) as total_revenue
from customer_shopping
group by subscription_status
order by total_revenue, avg_spend desc;

--Q6. Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
round(100* sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer_shopping
group by item_purchased
order by discount_rate desc
limit 5;

--Q7. segment customers into New, Returning, and loyal based on their total
--number of previous purchases, and show the count of each segment.
with customer_type as(
select customer_id, previous_purchases,
case
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returing'
	else 'Loyal'
	end as customer_segment
from customer_shopping	
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment 

--Q8. What are teh top 3 most purchased products within each category?
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc)as item_rank
from customer_shopping
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) alse likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer_shopping
where previous_purchases > 5
group by subscription_status

--Q10. What is the revenue contribution of each age group?
select age,
sum(purchase_amount_usd) as total_revenue
from customer_shopping
group by age
order by total_revenue desc;

