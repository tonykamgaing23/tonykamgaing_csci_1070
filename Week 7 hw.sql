--1
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'T%'
ORDER BY first_name ASC;

--2
SELECT *
FROM rental
WHERE return_date BETWEEN '2005-05-28' AND '2005-06-01';

--3
SELECT title, COUNT(rental.rental_id)
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY title
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 10;

--4
SELECT customer.customer_id, SUM(amount)
FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(amount);

--5
SELECT actor.first_name ||' '|| actor.last_name as actor_name, COUNT(actor.actor_id) as total_movies
from actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.release_year = 2006
GROUP BY actor_name
ORDER BY total_movies DESC
LIMIT 1;

--6

--4
SELECT customer.customer_id, SUM(amount)
FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(amount);
--processing 599 rows using quicksort (memory: 48kB) in 5.969–5.986 ms.
--With a memory consumption of 297kB (5.794–5.851 ms), --HashAggregate: Combines all spending for each customer, --grouped by customer.customer_id.
--processing 14596 rows (0.132–3.412 ms) --Hash Join: Joins payment and customer tables based on customer_id.
--Sequential Exams:
--Scans the 14596-row payment table (0.009–0.881 ms).
--Searches the 599-row customer table (0.004–0.057 ms).
--Planning and Execution: The entire execution time was 6.068 ms, with 0.307 ms spent on planning.
--5
SELECT actor.first_name ||' '|| actor.last_name as actor_name, COUNT(actor.actor_id) as total_movies
from actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.release_year = 2006
GROUP BY actor_name
ORDER BY total_movies DESC
LIMIT 1;

--After sorting, just one result is returned
--(actual time: 1.590 ms).
--Using top-N heapsort (25kB RAM), actors are 
--arranged according to the number of films they have starred in.
--HashAggregate: Counts the number of films in 
--which each actor appeared and aggregates their names
--(actual time: 1.571 ms). Hash Join: Using sequential scans, 
--joins the film_actor and film tables to obtain --the list of actors 
--and films that were released in 2006.
--Planning and Execution: It took 1.609 ms to finish the query.

--7
SELECT category.name as genre, AVG(film.rental_rate)
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY genre;

--8
SELECT category.name as genre, COUNT(rental.rental_id), SUM(payment.amount)
FROM rental
INNER JOIN payment ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY genre
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 5;

--EC
SELECT to_char(rental.rental_date, 'Month') AS month, category.name AS genre, COUNT(rental.rental_id)
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY month, genre
ORDER BY month