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

	
/* g.What are the 10 best rated movies? Is customer rating somehow correlated with revenue? Which actors have acted in most number of the most popular or highest rated movies?*/


/* h.Rentals and hence revenues have been falling behind among young families. In order to reverse this, you wish to target all family movies for a promotion. Identify all movies categorized as family films.*/


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

