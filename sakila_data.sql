use sakila;

# 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name.

SELECT upper(concat(first_name, ' ' , last_name)) as "Actor Name" FROM actor;

# 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 

SELECT actor_id, first_name, last_name FROM actor
where first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN:

SELECT actor_id, first_name, last_name FROM actor
where last_name like '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. 
# This time, order the rows by last name and first name, in that order:

SELECT actor_id, first_name, last_name FROM actor
where last_name like '%LI%'
order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: 
# Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. create a column in the table actor named description and use the data type BLOB

ALTER TABLE actor
ADD description BLOB;

# 3b. Delete the description column.

ALTER TABLE actor
DROP COLUMN description;

# 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(1) FROM actor
group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors

SELECT last_name, count(1) FROM actor
group by last_name
having count(1) >= 2;

# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
# Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# 4d. In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

# 5a. Re-create the address table schema
SHOW CREATE TABLE address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
# Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a ON s.address_id = a.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
# Use tables staff and payment.

SELECT s.first_name, s.last_name, sum(p.amount)
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE payment_date like '2005-08%'
GROUP BY s.first_name, s.last_name;

# 6c. List each film and the number of actors who are listed for that film. 
# Use tables film_actor and film. Use inner join.

SELECT f.title, count(fa.actor_id) num_actors
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
group by f.title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(i.film_id) 
FROM film f
JOIN inventory i ON f.film_id = i.film_id
where f.title like 'Hunchback Impossible';

# 6e. Using the tables payment and customer and the JOIN command, 
# list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(amount) as "Total Amount Paid"
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

