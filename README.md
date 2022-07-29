DML: The dvdrental db already has a pre-populated data in it, but let's assume that the business is still running in which case we need to not only analyze existing data but also maintain the database mainly by INSERTing data for new rentals and UPDATEing the db for existing rentals--i.e implementing DML (Data Manipulation Language). To this effect,
Write ALL the queries we need to rent out a given movie. (Hint: these are the business logics that go into this task: first confirm that the given movie is in stock, and then INSERT a row into the rental and the payment tables. You may also need to check whether the customer has an outstanding balance or an overdue rental before allowing him/her to rent a new DVD).
write ALL the queries we need to process return of a rented movie. (Hint: update the rental table and add the return date by first identifying the rental_id to update based on the inventory_id of the movie being returned.)
DQL: Now that we have an up-to-date database, let's write some queries and analyze the data to understand how our DVD rental business is performing so far.
Which movie genres are the most and least popular? And how much revenue have they each generated for the business?
What are the top 10 most popular movies? And how many times have they each been rented out thus far?
Which genres have the highest and the lowest average rental rate?
How many rented movies were returned late? Is this somehow correlated with the genre of a movie?
What are the top 5 cities that rent the most movies? How about in terms of total sales volume?
let's say you want to give discounts as a reward to your loyal customers and those who return movies they rented on time. So, who are your 10 best customers in this respect?
What are the 10 best rated movies? Is customer rating somehow correlated with revenue? Which actors have acted in most number of the most popular or highest rated movies?
Rentals and hence revenues have been falling behind among young families. In order to reverse this, you wish to target all family movies for a promotion. Identify all movies categorized as family films.
How much revenue has each store generated so far?
As a data analyst for the DVD rental business, you would like to have an easy way of viewing the Top 5 genres by average revenue. Write the query to get list of the top 5 genres in average revenue in descending order and create a view for it?
Note:
