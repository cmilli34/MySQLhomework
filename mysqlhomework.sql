use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name as "First Name", last_name as "Last Name" from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
select concat(first_name, " ", last_name) as "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name in('Joe');

-- 2b. Find all actors whose last name contain the letters GEN:
select*from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name, first_name
from actor 
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor add Description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop Description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as "Last Name Count"
from actor
group by last_name
having count(last_name) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name ='HARPO' WHERE first_name ='GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name ='GROUCHO' WHERE first_name ='HARPO' and last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address
from staff s
inner join address a
on (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name, last_name, sum(amount)
from staff s
inner join payment p
on s.staff_id = p.staff_id
where payment_date between "2005-08-01" and "2005-08-31"
group by p.staff_id
order by last_name asc;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, count(actor_id)
from film f
inner join film_actor a
on f.film_id = a.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(inventory_id) 
from film f
inner join inventory i
on f.film_id = i.film_id
where title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name, sum(amount)
from customer c
inner join payment p
on p.customer_id = c.customer_id
group by last_name, first_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film where ((title like 'K%') or (title like 'Q%')) and title in
(select title from film where language_id in
(select language_id from language where name = 'English')); 

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor where actor_id in
(select actor_id from film_actor where film_id in
(select film_id from film
where title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, email
from (((address inner join customer on address.address_id = customer.address_id)
join city on address.city_id = city.city_id)
join country on country.country_id = city.country_id) where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film_list where category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
select title, sum(rental_rate) from film group by title order by sum(rental_rate) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.


-- 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country 
from (((store inner join address on store.address_id = address.address_id)
join city on city.city_id = address.city_id)
join country on country.country_id = city.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category, total_sales from sales_by_film_category group by category ORDER BY total_sales DESC LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres as select category, total_sales from sales_by_film_category group by category ORDER BY total_sales DESC LIMIT 5;
select * from top_five_genres;

-- 8b. How would you display the view that you created in 8a?
show create view top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres;
