#*`SQL Queries for Pagila Database`*
==================================
###1a. You need a list of all the actors’ first name and last name?
>>**SELECT first_name,last_name 
FROM actor**;


###1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
>>**SELECT CONCAT(First_Name,' ',Last_Name) as Actor_Name 
FROM actor;**


###2a. You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." What is one query would you use to obtain this information?
>>**SELECT actor_id,first_name, last_name 
FROM actor 
WHERE first_name like upper('Joe%');**


###2b. Find all actors whose last name contain the letters GEN. Make this case insensitive
>>**SELECT actor_id,first_name, last_name 
FROM actor 
WHERE last_name like upper('%gen%');**


###2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. Make this case insensitive.
>>**SELECT actor_id,first_name, last_name 
FROM actor  
WHERE last_name like upper('%li%') 
ORDER BY last_name, first_name;**


###2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
>>**SELECT country_id, country 
FROM country 
WHERE country IN ('Afghanistan','Bangladesh','China');**


###3a. Add a middle_name column to the table actor. Specify the appropriate column type
>>**ALTER TABLE actor ADD middle_name character varying(45);**


###3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.
>>**ALTER TABLE actor 
ALTER COLUMN middle_name TYPE text;**
>or 
>>**ALTER TABLE actor 
ALTER COLUMN middle_name TYPE character varying;**


###3c: Now write a query that would remove the middle_name column.
>>**ALTER TABLE actor 
DROP COLUMN middle_name;**


###4a. List the last names of actors, as well as how many actors have that last name.
>>**SELECT last_name,count(*) 
FROM actor 
GROUP BY last_name 
ORDER BY count(*) desc;**


###4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
>>**SELECT last_name,count(*) 
FROM actor 
GROUP BY last_name 
HAVING count(*) >1 
ORDER BY count(*) desc;***


###4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
>>**UPDATE actor 
SET first_name = 'HARPO' 
WHERE last_name = 'WILLIAMS' and first_name = 'GROUCHO';**


###4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO
>>**UPDATE actor 
SET first_name = 
	CASE WHEN first_name = 'GROUCHO' 
		 THEN 'MUCHO GROUCHO' 
		 WHEN first_name = 'HARPO' 
		 THEN 'GROUCHO' 
	END 
WHERE first_name in (
					Select first_name 
					FROM actor 
					WHERE first_name in ('HARPO','GROUCHO'));**


###5a. What’s the difference between a left join and a right join. 
*The difference is simple:
In a LEFT JOIN, all of the rows from the “left” table will be displayed, regardless of whether there are any matching columns in the “right” table. 
In a RIGHT JOIN, all of the rows from the “right” table will be displayed, regardless of whether there are any matching columns in the “left” table.*
>SELECT * 
FROM Table1 
LEFT JOIN Table2 
ON table1.column_name = table2.column.name
--*This will give all the rows from Table1.*

>SELECT * 
FROM Table1 
RIGHT JOIN Table2 
ON table1.column_name = table2.column.name
--*This will give all the rows from Table2.*

###5b. What about an inner join and an outer join? 
* *Inner join - An inner join using either of the equivalent queries gives the intersection of the two tables, i.e. the two rows they have in common.*
* *Full outer join - A full outer join will give you the union of A and B, i.e. All the rows in A and all the rows in B. If something in A doesn't have a corresponding datum in B, then the B portion is null, and vice versa.*

![JOINS](http://4.bp.blogspot.com/-_HsHikmChBI/VmQGJjLKgyI/AAAAAAAAEPw/JaLnV0bsbEo/s1600/sql%2Bjoins%2Bguide%2Band%2Bsyntax.jpg "JOINS")

###5c. When would you use rank? 
*RANK function is used to rank the repeating values in a manner such that similar values are ranked the same. In other words, rank function returns the rank of each row within the partition of a result set. “equal” rows are ranked the same.*
>SELECT RANK() OVER (PARTITION BY Gender ORDER BY Age) AS [Partition by Gender], 
   FirstName, 
   Age,
   Gender 
 FROM Person

###5d. What about dense_rank? 
*DENSE_RANK() is a rank with no gaps, i.e. it is “dense”. Equal values are ranked same but the value after those values will be the consecutive number*

| V | ROW_NUMBER | RANK | DENSE_RANK |
|---|------------|------|------------|
| a |          1 |    1 |          1 |
| a |          2 |    1 |          1 |
| a |          3 |    1 |          1 |
| b |          4 |    4 |          2 |
| c |          5 |    5 |          3 |
| c |          6 |    5 |          3 |
| d |          7 |    7 |          4 |
| e |          8 |    8 |          5 |

###5e. When would you use a subquery in a select? 
*Subqueries provide a powerful means to combine data from two tables in to a single result.  Subqueries are sometimes called nested queries.  As the name implies, subqueries contain one or more queries, one inside the other.
Subqueries are very versatile and that can make them somewhat hard to understand.  For most cases a subquery can be used anywhere you can use an expression or table specification.
For example, you can use subqueries in the SELECT, FROM, WHERE, or HAVING clauses.  Depending on its use, a subquery may return one or more rows, or in other cases, such as when used in a SELECT clause, be restricted to returning a single value.
In later articles we’ll get into the specifics on using subqueries throughout your SELECT statements such as the SELECT, WHERE, FROM, and HAVING clauses.*
>*Eg:
Select *
from Employees
where emp_id IN (Select emp_id
				 from department
				 where department = 'Sales')*

###5f. When would you use a right join?
*Right join can be used when optimizing a large query. Keep joining all the tables to left is not optimized way.
Secondly, if you are using join in sql and join three tables in single query and with 2 tables using left join and you want all records of third table then you can't use left join with 3rd table, so you have to use right join with 3rd table.*

###5g. When would you use an inner join over an outer join?
*You can use inner join over an outer join when we need only common rows as the results from both the tables, all the non-matching rows are not required*

###5h. What’s the difference between a left outer and a left join
*There is no difference betwen LEFT OUTER JOIN and LEFT JOIN
both will give all the rows of the left tables and the matching rows of the right table.*
>SELECT * 
FROM Table1 
LEFT JOIN Table2 
ON table1.column_name = table2.column.name
OR
>SELECT * 
FROM Table1 
LEFT OUTER JOIN Table2 
ON table1.column_name = table2.column.name
--*both will give same results*

###5i. When would you use a group by?
*The SQL GROUP BY clause is used in collaboration with the SELECT statement to arrange identical data into groups. This GROUP BY clause follows the WHERE clause in a SELECT statement and precedes the ORDER BY clause.*
>SELECT column1, column2
FROM table_name
WHERE [ conditions ]
GROUP BY column1, column2
ORDER BY column1, column2

###5j. Describe how you would do data reformatting?
*There can be multiple way for data reformatting*
* Using formatting data type functions like to_char, to_number, cast etc
* We can name the coulmn names properly by using alias
* Formatting the date and time coulmns to be more more human readable.
* Changing the number coulmns of amount or payment to start with ($)

###5k. When would you use a with clause?
*The SQL WITH clause allows you to give a sub-query block a name a process also called sub-query refactoring, which can be referenced in several places within the main SQL query. The name assigned to the sub-query is treated as though it was an inline view or table. The SQL WITH clause is basically a drop-in replacement to the normal sub-query.*
>WITH emps as (SELECT * FROM Employees)
SELECT * FROM emps WHERE ID < 20
UNION ALL
SELECT * FROM emps where Sex = 'F'

###5l. bonus: When would you use a self join?
*A self join is simply when you join a table with itself. There is no SELF JOIN keyword, you just write an ordinary join where both tables involved in the join are the same table. One thing to notice is that when you are self joining it is necessary to use an alias for the table otherwise the table name would be ambiguous.
It is useful when you want to correlate pairs of rows from the same table, for example a parent - child relationship or employee - manager relationship*
>SELECT E.name, ME.name AS manager
FROM Employees E
LEFT JOIN Employees ME
ON ME.employeeid = E.managerid
--*This will return each empoyee name and their manager's name*


###6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
>>**SELECT s.first_name,s.last_name,a.address, a.address2, a.district, a.city_id,a.postal_code 
FROM staff s 
LEFT JOIN address a 
ON a.address_id = s.address_id;**

###6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. Use tables staff and payment. You’ll have to google for this one, we didn’t cover it explicitly in class. 
>>**SELECT s.staff_id, s.first_name, s.last_name, sum(amount) as Total_Amount 
FROM staff s 
JOIN payment p 
ON p.staff_id = s.staff_id 
WHERE payment_date <= '2007-01-31' 
GROUP BY s.staff_id,s.first_name, s.last_name;**

###6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
>>**SELECT f.film_id, f.title as Film_Name, count(actor_id) as No_of_Actors 
FROM film f 
JOIN film_actor fa  
ON f.film_id = fa.film_id 
GROUP BY f.film_id, f.title 
ORDER BY f.film_id;**

###6d. How many copies of the film Hunchback Impossible exist in the inventory system?
>>**SELECT f.title as Film_Name, count(inventory_id) 
FROM inventory inv 
JOIN film f 
ON f.film_id = inv.film_id 
WHERE f.title = upper('Hunchback Impossible') 
GROUP BY f.title;**

###6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
>>**SELECT c.customer_id,c.first_name, c.last_name, sum(amount) as Total_paid 
FROM customer c 
LEFT JOIN payment p 
ON p.customer_id = c.customer_id 
GROUP BY c.customer_id,c.first_name, c.last_name 
ORDER BY c.last_name;**


###7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. display the titles of movies starting with the letters K and Q whose language is English.
>>**SELECT * 
FROM film f 
JOIN language lan 
ON lan.language_id = f.language_id 
WHERE f.language_id = 1 
AND (f.title like 'K%' or f.title like 'Q%');**

###7b. Use subqueries to display all actors who appear in the film Alone Trip.
>>**SELECT f.title as film_Name, a.first_name, a.last_name , a.actor_id FROM film f
JOIN film_actor fa 
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id 
WHERE f.title = 'ALONE TRIP';**
>or 
>>**SELECT a.first_name, a.last_name, a.actor_id
FROM actor a
WHERE actor_id in (SELECT actor_id
                  FROM film f
                  JOIN film_actor fa
                  ON f.film_id = fa.film_id
                  WHERE f.title = 'ALONE TRIP') 
ORDER BY a.actor_id;**

###7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
>>**SELECT cus.customer_id, cus.first_name, cus.last_name, cus.email, co.country
FROM customer cus
JOIN address a
ON a.address_id = cus.address_id
JOIN city c
ON c.city_id = a.city_id
JOIN country co
ON co.country_id = c.country_id
WHERE country = 'Canada'
order by cus.customer_id;**


###7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.
>>**SELECT f.film_id, f.title, c.name as Film_category_name 
FROM film f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON c.category_id = fc.category_id
WHERE c.name = 'Family'
order by f.film_id**


###7e. Display the most frequently rented movies in descending order.
>>**SELECT *
FROM rental r
LEFT JOIN inventory inv
ON r.inventory_id = inv.inventory_id
LEFT JOIN film f
ON inv.film_id = f.film_id**


###7f. Write a query to display how much business, in dollars, each store brought in.
>>**SELECT sr.store_id, sum(p.amount) as Amount_in_Dollars
FROM store sr
JOIN staff sf
on sr.store_id = sf.store_id
JOIN payment p
ON p.staff_id = sf.staff_id
GROUP BY sr.store_id
ORDER BY sr.store_id**


###7g. Write a query to display for each store its store ID, city, and country.
>>**SELECT str.store_id, ci.city, co.country
FROM store str
JOIN address a 
ON a.address_id = str.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON co.country_id = ci.country_id**


###7h. List the top five genres in gross revenue in descending order. 
>>**SELECT ca.category_id,ca.name, sum(p.amount)
FROM category ca
JOIN film_category fc
ON fc.category_id = ca.category_id
JOIN inventory inv
ON inv.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = inv.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY ca.category_id,ca.name
ORDER BY sum(p.amount) desc
limit 5**


###8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
>>**CREATE OR REPLACE VIEW TOP_5_GENRES AS
SELECT ca.category_id,ca.name, sum(p.amount)
FROM category ca
JOIN film_category fc
ON fc.category_id = ca.category_id
JOIN inventory inv
ON inv.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = inv.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY ca.category_id,ca.name
ORDER BY sum(p.amount) desc
LIMIT 5**

###8b. How would you display the view that you created in 8a?
>>**SELECT * 
FROM TOP_5_GENRES;**

###8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
>>**DROP VIEW TOP_5_GENRES;**

======================================================================================





