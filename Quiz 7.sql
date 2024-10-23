select *
from payment
where amount >= 9.99;

select MAX(amount)
from payment;

select title, amount
from payment
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
where amount = 11.99;

select first_name, last_name, email, address, city, country
from staff
inner join address on staff.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id;


--I am looking forward to working in cybersecurity and working
--for a company that pushes me to be the best version of myself.
