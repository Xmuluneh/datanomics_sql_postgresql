/*Q1
a.INSERT a row into the rental and the payment tables. 
check whether the customer has an outstanding balance 
or an overdue rental before allowing him/her to rent a new DVD).
*/

/*
 check the customer oustanding balnace
*/
select c.customer_id,count(amount) As balance
from payment p
join customer c 
using(customer_id)
where amount > 0
Group by customer_id
/*
SELECT fc.film_id,iv.inventory_id,r.rental_id,sr.store_id
FROM film f
JOIN film_category fc
USING(film_id)
JOIN inventory iv 
using(film_id)
JOIn rental r 
USING(inventory_id)
JOIN staff s
USING(staff_id)
JOIN store sr
USING(store_id)
*/

--Insert a row in to the rental table

INSERT INTO rental(rental_id,
				   rental_date,
				   inventory_id,
				   customer_id,
				   return_date,
				   staff_id,
				   last_update)
VALUES(17000,
	   '2022-07-22 20:20:33',
	   4287,
	   524,
	   '2022-09-10 19:40:55',
	   1,
	   '2022-07-05 20:30:55');


--Insert a row in to the payment table

INSERT INTO payment(payment_id,
				   customer_id,
				   staff_id,
				   rental_id,
				   amount,
				    payment_date)
VALUES(17000,
	  342,
	   1,
	   1520,
	   7.99,
	   '2022-07-05 20:30:55');














/*2.DQL.write some queries and analyze the data to understand how our DVD rental business is performing so far.*/

/* a.Which movie genres are the most and least popular? And how much revenue have they each generated for the business?*/

WITH table_1 AS(SELECT name AS genres,
			 COUNT(f.rental_rate) AS Total_rental_rate
			 FROM category c 
			 JOIN film_category fc
			 USING(category_id)
			 JOIN film f
			 USING(film_id)
			 JOIN inventory i
			 USING(film_id)
			 JOIN rental r
			 USING(inventory_id)
			 JOIN customer ca
			 USING(customer_id)
			 GROUP BY 1
			 ORDER BY 2 DESC),
    table_2 AS (SELECT c.name AS genres,
				SUM(p.amount) As revenu
			  FROM category c 
			 JOIN film_category fc
			 USING(category_id)
			 JOIN film f
			 USING(film_id)
			 JOIN inventory i
			 USING(film_id)
			JOIN rental r
			USING(inventory_id)
			JOIN payment p
			USING(rental_id)
			GROUP BY 1
			ORDER BY 2 DESC)
SELECT table_1.genres,
        table_1.Total_rental_rate,
		table_2.revenu
FROM table_1
JOIN table_2
ON table_1.genres = table_2.genres
		

/* b.What are the top 10 most popular movies? And how many times have they each been rented out thus far?*/

SELECT title,
       COUNT(r.rental_id) AS total_no_rent
FROM rental r
JOIN inventory  i
USING(inventory_id)
JOIN film f
USING(film_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/* c.Which genres have the highest and the lowest average rental rate?*/

SELECT c.name AS gener,
        ROUND(AVG(f.rental_rate),2) AS average_rental_rate
FROM category c
JOIN film_category fc
USING (category_id)
JOIN film f
USING(film_id)
GROUP BY 1
ORDER BY 2 DESC

/* d.How many rented movies were returned late? Is this somehow correlated with the genre of a movie?*/
WITH table_1 AS (SELECT *,(date(return_date) - date(rental_date)) AS diff
            FROM rental),
	table_2 As(SELECT rental_duration,diff
		  FROM film f
		  JOIN inventory i
		  USING(film_id)
		  JOIN table_1
		  USING(inventory_id)
		  where rental_duration < diff )  
SELECT COUNT(*) AS late_return_no_of_films
FROM table_2
/* e.What are the top 5 cities that rent the most movies? How about in terms of total sales volume?*/
SELECT city, 
       count(DISTINCT customer_id) AS customer_base,
	   SUM(amount) AS total_sales
FROM city
JOIN address
USING(city_id)
JOIN customer
USING(address_id)
JOIN rental
USING (customer_id)
JOIN payment
USING(customer_id)
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;
/* f.let's say you want to give discounts as a reward to your loyal customers and those who return movies they rented on time. So, who are your 10 best customers in this respect?*/

with table_1 AS (SELECT * ,(first_name || ' '|| last_name) as full_name
                FROM customer)
               (SELECT customer_id,full_name,email ,COUNT(*) AS total_count
			   FROM rental r
			   JOIN table_1
			   USING(customer_id)
			  JOIN inventory i
			  USING(inventory_id)
			  JOIN film f
			  USING(film_id)
			  WHERE (rental_duration >= (DATE(return_date)-DATE(rental_date))) AND return_date IS NOT  NULL
			  GROUP BY 1,2,3
			  ORDER BY 4 DESC 
			  LIMIT 10)
	
/* g.What are the 10 best rated movies? Is customer rating somehow correlated with revenue? Which actors have acted in most number of the most popular or highest rated movies?*/


/* h.Rentals and hence revenues have been falling behind among young families. In order to reverse this, you wish to target all family movies for a promotion. Identify all movies categorized as family films.*/
SELECT name AS family_genre, 
        title
FROM category 
JOIN film_category 
USING(category_id)
JOIN film 
USING(film_id) 
WHERE name = 'Family' 
GROUP BY family_genre, title
ORDER BY title

/* i.How much revenue has each store generated so far?*/
SELECT store_id, 
       SUM(amount) AS revenue
FROM payment
JOIN rental
USING(rental_id)
JOIN inventory
USING(inventory_id)
GROUP BY store_id

/* j.As a data analyst for the DVD rental business, you would like to have an easy way of viewing the Top 5 genres by average revenue. Write the query to get list of the top 5 genres in average revenue in descending order and create a view for it*/
SELECT name AS genere, 
    T(cr.customer_id) AS total_rented, 
		Round(AVG(pt.amount), 2) AS avg_revenue, SUM( pt.amount) AS total_sales
FROM category ct
INNER JOIN film_category fc
	ON fc.category_id = ct.category_id
	INNER JOIN inventory iv
	ON fc.film_id = iv.film_id
	INNER JOIN rental rn 
	ON iv.inventory_id = rn.inventory_id
	INNER JOIN customer cr 
	ON rn.customer_id = cr.customer_id
	INNER JOIN payment pt 
	ON rn.rental_id = pt.rental_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 5
CREATE VIEW Average_revenu AS
  SELECT *
  from table_1

