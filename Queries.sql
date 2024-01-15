--https://www.dbdiagrams.com/postgresql/online-er-diagram-postgresql-pagila-sample/



--1a. You need a list of all the actors’ first name and last name
--Tüm aktörlerin ad ve soyadlarının bir listesine ihtiyacınız var.

Select first_name,last_name
from actor;
--rows 200


--1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
--Her aktörün adını ve soyadını tek bir sütunda büyük harflerle görüntüleyin.
Select CONCAT(First_Name,' ',Last_Name) as Actor_Name
from actor;
--rows 200

--2a. You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." What is one query would you use to obtain this information?
--Sadece adını bildiğiniz "Joe" aktörünün kimliğini, adını ve soyadını bulmanız gerekiyor.

Select actor_id,first_name, last_name
from actor
where first_name like upper('Joe%');
--row 1


--2b. Find all actors whose last name contain the letters GEN. Make this case insensitive
--Soyadı GEN harflerini içeren tüm aktörleri bulun. Bu büyük/küçük harfe duyarsız hale getirin

Select actor_id,first_name, last_name
from actor
where last_name like upper('%gen%');
--rows 4

--2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. Make this case insensitive.

Select actor_id,first_name, last_name
from actor
where last_name like upper('%li%')
order by last_name, first_name;
--rows 10


--2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
--IN'i kullanarak şu ülkelerin country_id ve ülke sütunlarını görüntüleyin: Afganistan, Bangladeş ve Çin:

Select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh','China');
--rows 3

--3a. Add a middle_name column to the table actor. Specify the appropriate column type
ALTER TABLE actor
ADD middle_name character varying(45);

--3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor
ALTER COLUMN middle_name TYPE text;
--or 
ALTER TABLE actor
ALTER COLUMN middle_name TYPE character varying;

--3c: Now write a query that would remove the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

--4a. List the last names of actors, as well as how many actors have that last name.
--Aktörlerin soyadlarını ve aynı soyadına sahip kaç aktörün olduğunu listeleyin.

Select last_name,count(*)
from actor
group by last_name
order by count(*) desc;

--4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
--Aktörlerin soyadlarını ve bu soyadına sahip aktörlerin sayısını listeleyin; ancak yalnızca en az iki aktör tarafından paylaşılan isimler için

Select last_name,count(*)
from actor
group by last_name
having count(*) >1
order by count(*) desc;


--4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE last_name = 'WILLIAMS' and first_name = 'GROUCHO';

--4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO
UPDATE actor
SET first_name = 
   CASE
   WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
   WHEN first_name = 'HARPO' THEN 'GROUCHO'
   END
where first_name in (Select first_name
from actor
where first_name in ('HARPO','GROUCHO'));


--6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
--Her personelin adını, soyadını ve adresini görüntülemek için JOIN kullanın. Tablodaki personeli ve adresi kullanın:

Select s.first_name,s.last_name,a.address, a.address2, a.district, a.city_id,a.postal_code
from staff s
left join address a
on a.address_id = s.address_id;
--rows 2


--6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. Use tables staff and payment. You’ll have to google for this one, we didn’t cover it explicitly in class. 
Select s.staff_id, s.first_name, s.last_name, sum(amount) as Total_Amount
from staff s
join payment p
on p.staff_id = s.staff_id
where payment_date <= '2007-01-31'
group by s.staff_id,s.first_name, s.last_name;

--6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
-- Her filmi ve o filmde oynayan oyuncu sayısını getirin
Select f.film_id, f.title as Film_Name, count(actor_id) as No_of_Actors
from film f
join film_actor fa 
on f.film_id = fa.film_id
group by f.film_id, f.title
order by f.film_id;
--rows 997


--6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Envanter sisteminde Kambur İmkansız filminin kaç kopyası var?

Select f.title as Film_Name, count(inventory_id)
from inventory inv
join film f
on f.film_id = inv.film_id
where f.title = upper('Hunchback Impossible')
group by f.title;
--row 1


--6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
-- En çok ödeme yapan müşterileri büyükten küçüğe doğru sıralayın.
select c.customer_id,c.first_name, c.last_name, sum(amount) as Total_paid
from customer c
Left join payment p
on p.customer_id = c.customer_id
group by c.customer_id,c.first_name, c.last_name
order by c.last_name;
--rows 599

--7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. display the titles of movies starting with the letters K and Q whose language is English.
Select *
from film f
join language lan
on lan.language_id = f.language_id
where f.language_id = 1
and f.title like 'K%' or f.title like 'Q%';
--rows 15

--7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select f.title as film_Name, a.first_name, a.last_name , a.actor_id
from film f
join film_actor fa
on f.film_id = fa.film_id
join actor a
on a.actor_id = fa.actor_id
where f.title = 'ALONE TRIP';
--or 
Select a.first_name, a.last_name, a.actor_id
from actor a
where actor_id in (select actor_id
                  from film f
                  join film_actor fa
                  on f.film_id = fa.film_id
                  where f.title = 'ALONE TRIP') 
order by a.actor_id;
--rows 8

--7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

Select cus.customer_id, cus.first_name, cus.last_name, cus.email, co.country
from customer cus
join address a
on a.address_id = cus.address_id
join city c
on c.city_id = a.city_id
join country co
on co.country_id = c.country_id
where country = 'Canada'
order by cus.customer_id;
--rows 5

--7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.
Select f.film_id, f.title, c.name as Film_category_name 
from film f
join film_category as fc
on f.film_id = fc.film_id
join category as c
on c.category_id = fc.category_id
where c.name = 'Family'
order by f.film_id;
--rows 69

--7e. Display the most frequently rented movies in descending order.
Select *
from rental r
left join inventory inv
on r.inventory_id = inv.inventory_id
left join film f
on inv.film_id = f.film_id;


--7f. Write a query to display how much business, in dollars, each store brought in.
Select sr.store_id, sum(p.amount) as Amount_in_Dollars
from store sr
join staff sf
on sr.store_id = sf.store_id
join payment p
on p.staff_id = sf.staff_id
group by sr.store_id
order by sr.store_id;
--Rows 2

--7g. Write a query to display for each store its store ID, city, and country.
Select str.store_id, ci.city, co.country
from store str
join address a 
on a.address_id = str.address_id
join city ci
on a.city_id = ci.city_id
join country co
on co.country_id = ci.country_id;
--Rows 2

--7h. List the top five genres in gross revenue in descending order. 
Select ca.category_id,ca.name, sum(p.amount)
from category ca
 join film_category fc
on fc.category_id = ca.category_id
 join inventory inv
on inv.film_id = fc.film_id
 join rental r
on r.inventory_id = inv.inventory_id
 join payment p 
on p.rental_id = r.rental_id
group by ca.category_id,ca.name
order by sum(p.amount) desc
limit 5;
--Rows 5


--8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 

CREATE OR REPLACE VIEW TOP_5_GENRES AS
Select ca.category_id,ca.name, sum(p.amount)
from category ca
 join film_category fc
on fc.category_id = ca.category_id
 join inventory inv
on inv.film_id = fc.film_id
 join rental r
on r.inventory_id = inv.inventory_id
 join payment p 
on p.rental_id = r.rental_id
group by ca.category_id,ca.name
order by sum(p.amount) desc
limit 5;

--8b. How would you display the view that you created in 8a?
Select * from TOP_5_GENRES;

--8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TOP_5_GENRES;

-- Kiralanan filmleri henüz getirmemiş müşterileri listele. Adı, soyadı, telefonu, aldığı film ve kiralama tarihi

SELECT
	CONCAT(customer.last_name, ', ', customer.first_name) AS customer,
	address.phone,
	film.title
FROM
	rental
	INNER JOIN customer ON rental.customer_id = customer.customer_id
	INNER JOIN address ON customer.address_id = address.address_id
	INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
	INNER JOIN film ON inventory.film_id = film.film_id
WHERE
	rental.return_date IS NULL
	AND rental_date < CURRENT_DATE
ORDER BY
	title
LIMIT 5;

-- Full textseach örneği
SELECT * FROM film WHERE fulltext @@ to_tsquery('fate&india'); 

