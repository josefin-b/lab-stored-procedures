-- Lab | Stored procedures --

use sakila;

-- 1 In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:

      select first_name, last_name, email
      from customer
      join rental on customer.customer_id = rental.customer_id
      join inventory on rental.inventory_id = inventory.inventory_id
      join film on film.film_id = inventory.film_id
      join film_category on film_category.film_id = film.film_id
      join category on category.category_id = film_category.category_id
      where category.name = "Action"
      group by first_name, last_name, email;


drop procedure if exists customer_details_proc;

delimiter //
create procedure customer_details_proc()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end;
//
delimiter ;

call customer_details_proc();


-- 2 Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.

drop procedure if exists customer_details_proc_2;

delimiter //
create procedure customer_details_proc_2(in param1 char(20))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name collate utf8mb4_general_ci = param1
  group by first_name, last_name, email;
end;
//
delimiter ;

call customer_details_proc_2("Action");


-- 3 Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

#query:
select c.name as category_name, count(fc.film_id) as nr_of_films from category c
join film_category fc
on c.category_id = fc.category_id
group by c.name
order by nr_of_films;

#stored procedure:
drop procedure if exists movies_released_proc;

delimiter //
create procedure movies_released_proc(in param1 int)
begin
	select c.name as category_name, count(fc.film_id) as nr_of_films
    from category c
	join film_category fc
	on c.category_id = fc.category_id
	group by c.name
    having nr_of_films > param1
	order by nr_of_films;
end;
//
delimiter ;

call movies_released_proc(60);
