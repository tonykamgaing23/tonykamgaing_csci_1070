--1
ALTER TABLE rental
ADD COLUMN status VARCHAR(10);

UPDATE rental
SET status = 
    CASE 
        WHEN rental.return_date > rental.rental_date + INTERVAL '1 day' * (
            SELECT film.rental_duration 
            FROM film
            INNER JOIN inventory ON film.film_id = inventory.film_id 
            WHERE inventory.inventory_id = rental.inventory_id
        ) THEN 'Late'
        WHEN rental.return_date < rental.rental_date + INTERVAL '1 day' * (
            SELECT film.rental_duration 
            FROM film 
            INNER JOIN inventory ON film.film_id = inventory.film_id 
            WHERE inventory.inventory_id = rental.inventory_id
        ) THEN 'Early'
        ELSE 'On time'
    END;

--2
SELECT SUM(payment.amount) AS total_amount
FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN city ON city.city_id = address.city_id
WHERE city.city IN ('Kansas City', 'Saint Louis');

--3
SELECT category.name, COUNT(film.film_id)
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

--4
--film_category table is a type of table that handles
--relationship between category and film.

--5
SELECT film.film_id, film.title, film.length
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date BETWEEN '2005-05-15' AND '2005-05-31';

--6
SELECT film.film_id, film.title, film.rental_rate
FROM film
WHERE film.rental_rate < (SELECT AVG(film.rental_rate) FROM film);

--7
SELECT status, COUNT(*) AS count
FROM rental
GROUP BY status;

--8
SELECT film.title, film.length, 
       PERCENT_RANK() OVER (ORDER BY film.length) AS duration_percentile
FROM film;

--9
SELECT city, SUM(amount) AS total_payments
FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city IN ('Kansas City', 'Saint Louis')
GROUP BY city;


SELECT film.film_id, film.title, film.rental_rate
FROM film
WHERE film.rental_rate < (SELECT AVG(rental_rate) FROM film);

--Query 1 Payments per City includes several connects 
--between the payment, customer, address, and city fields. 
--Numerous Hash Join or Nested Loop operations are visible.
--Query 2 Movies Below Average Price should be simpler, utilizing 
--a second Seq Scan to filter films and a potential Seq Scan to extract 
--the average. Because this query just scans one table, its cost will be cheaper.

--Extra Credit
--Without defining a looping strategy, set-based programming 
--(SQL) works with data sets all at once. The focus is on "what" outcome is required. 
--For instance, SQL queries use a condition to return complete sets of rows.
--Python procedural programming carries out instructions step-by-step, utilizing loops and 
--conditionals to explicitly define "how" to do tasks. Each stage modifies distinct data points.