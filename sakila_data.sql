use sakila;

# 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name.

SELECT upper(concat(first_name, ' ' , last_name)) as "Actor Name" FROM actor;

# 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 

SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN:

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name like '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. 
# This time, order the rows by last name and first name, in that order:

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

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

SELECT last_name, count(1) as "Number of Actors"
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors

SELECT last_name, count(1) as "Number of Actors"
FROM actor
GROUP BY last_name
HAVING COUNT(1) >= 2;

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
SELECT s.first_name, s.last_name, concat(a.address, ', ', c.city, ', ', t.country) AS Address
FROM staff s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country t ON c.country_id = t.country_id;
# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
# Use tables staff and payment.

SELECT s.first_name, s.last_name, sum(p.amount) as "Total Amount Rung Up"
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE payment_date like '2005-08%'
GROUP BY s.first_name, s.last_name;

# 6c. List each film and the number of actors who are listed for that film. 
# Use tables film_actor and film. Use inner join.

SELECT f.title, count(fa.actor_id) as "Number of Actors"
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(i.film_id) as "Number of Copies"
FROM film f
JOIN inventory i ON f.film_id = i.film_id
where f.title like 'Hunchback Impossible';

# 6e. Using the tables payment and customer and the JOIN command, 
# list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(p.amount) as "Total Amount Paid"
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

# 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title Movie
FROM film
WHERE (title LIKE "K%" OR title LIKE "Q%") 
	AND language_id in (
		SELECT language_id FROM language
		WHERE name = "English"
	);

# 7c. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (
	SELECT actor_id 
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id 
        FROM film 
        WHERE title = 'Alone Trip'
		)
	);

# 7d. Identify all movies categorized as family films.
SELECT f.title Movie, c.name Category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

# 7e. Display the most frequently rented movies in descending order.
SELECT f.title AS Movie, count(r.rental_id) AS "Number of Rentals"
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY count(r.rental_id) DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT  s.store_id, concat(a.address, ', ', c.city, ', ', t.country) AS Store, sum(p.amount) AS "Total Sales"
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country t ON c.country_id = t.country_id
GROUP BY s.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT  s.store_id, concat(a.address, ', ', c.city, ', ', t.country) AS Address
FROM store s 
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country t ON c.country_id = t.country_id;

# 7h. List the top five genres in gross revenue in descending order. 

SELECT c.name AS Genre, sum(p.amount) AS "Total Sales"
FROM category c 
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

# 8a. Create a view of 7h
CREATE OR REPLACE VIEW top_five_genres AS
SELECT c.name AS Genre, sum(p.amount) AS "Total Sales"
FROM category c 
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

# 8b. Display the view in 8a
SELECT * 
FROM top_five_genres;

# 8b. Delete top_five_genres view
DROP VIEW top_five_genres;

