/*
Section 2:
*/
----------------
-- Lecture 19 --

-- Challenge 1
-- What is the email of customer nancy thomas?
SELECT email FROM customer
WHERE first_name = 'Nancy' AND last_name = 'Thomas';



-- Challenge 2
-- Could you give the description for the movie 'Outlaw Hanky'?
SELECT description FROM film
WHERE title = 'Outlaw Hanky';
-- Ignore capitalization of letters 
SELECT description FROM film
WHERE UPPER(title) = UPPER('Outlaw Hanky');



-- Challenge 3
-- Can you get the phone number for the customer who lives at '259 Ipoh Drive'?
SELECT phone FROM address
WHERE address = '259 Ipoh Drive';
-- Ignore capitalization of letters 
SELECT phone FROM address
WHERE UPPER(address) = UPPER('259 Ipoh Drive');




----------------
-- Lecture 22 --

-- Challenge 1
-- What are the customer_ids of the first 10 customers who created a payment?
-- definion: payment is money > 0,00
SELECT customer_id FROM payment 
WHERE amount > 0
ORDER BY payment_date ASC
LIMIT 10;



-- What are the titles of the 5 shortest (in length of runtime) movies?
SELECT title FROM film
ORDER BY "length" ASC -- We need to use " " when it is a keyword. This is similar to [ ] in MS SQL Server Express
LIMIT 5;



-- How many movies shorter than 50 minutes runtime?
SELECT COUNT(title) FROM film
WHERE film.length <= 50;




/*
Section 3:
*/
----------------
-- Lecture 31 --
-- Challenge 1 --
-- How many payments did each staff member handle?
-- Note; not amount of dollars, but amount of transactions
SELECT * FROM payment LIMIT 10; -- Understand the data
SELECT staff_id, COUNT(*) FROM payment
GROUP BY staff_id;
-- Result staff_id 2, 7304, correct!



-- Challenge 2 --
-- What is the average replacement cost per MPAA rating?
SELECT * FROM film LIMIT 10; -- Understand the data
SELECT rating, ROUND(AVG(replacement_cost), 2) FROM film
GROUP BY rating;
-- Result: correct



-- Challenge 3 --
-- What are the customer_ids of the top 5 customers by total spent?
SELECT * FROM payment LIMIT 10; -- Understand the data
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;
-- Result: Correct!



----------------
-- Lecture 33 --
-- Challenge 1 --
-- What customer ids are eligible for platinum status (40 or more transaction payments)
SELECT * FROM payment; --understand the data

SELECT customer_id, COUNT(payment_id) AS CustTransactions FROM payment
GROUP BY customer_id
HAVING COUNT(payment_id) >= 40
ORDER BY CustTransactions DESC;
-- Result; correct!



-- Challenge 2 --
--What are the customers ids of customers who have spent more than $100 in payments, with staff_id 2?
SELECT * from payment; --understand the data

SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 100 -- more than
ORDER BY SUM(amount) DESC;
-- Result; correct!




/*
Section 4:
*/
-- See assessment test file



/*
Section 5:
*/
----------------
-- Lecture 45 --
-- JOIN Challenge task --
-- What are the emails of the customers who live in California?
SELECT * FROM customer LIMIT 5; -- understand the data, address id and email
SELECT * FROM address LIMIT 5; -- understand the data, State (district) and address_id

-- gather all emails
SELECT address.district, email FROM customer
INNER JOIN address
ON customer.address_id = address.address_id -- 603 rows

-- Make sure no empty data
SELECT address.district, email, address.address_id FROM customer
FULL OUTER JOIN address
ON customer.address_id = address.address_id 
WHERE customer.customer_id IS NULL OR 
address.address_id IS NULL -- 4 rows actually, address_id filled, but no customer (1-4)

-- gather all Californian emails, INNER JOIN assures no empty data
SELECT address.district, customer.email FROM customer
INNER JOIN address
ON customer.address_id = address.address_id 
WHERE address.district ILIKE 'California' -- 9 rows
-- Result: Correct!



-- Challenge 2 --
-- Get a list of all the movies 'Nick Wahlberg' has been in
SELECT film.title, actor.first_name, actor.last_name FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name ILIKE 'Nick' AND actor.last_name ILIKE 'Wahlberg';



/*
Section 6:
*/
----------------
-- Lecture 50 --
-- Challenge task --
-- Challenge 1 --
-- During which months did payments occur, format your answer to return back the full month name
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) FROM payment;
-- Result: correct!

-- I want to make it nicer
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')), SUM(amount) FROM payment;

SELECT TO_CHAR(payment_date, 'MONTH'), SUM(amount) FROM payment 
GROUP BY TO_CHAR(payment_date, 'MONTH');


-- Challenge 2 --
-- How many payments occurred on a monday
SELECT TO_CHAR(payment_date,'Day'), COUNT(*) FROM payment
WHERE TO_CHAR(payment_date,'Day') ILIKE 'Monday%'
GROUP BY TO_CHAR(payment_date,'Day')
-- Result: correct!

-- Solution teacher used
SELECT COUNT(*) FROM payment
WHERE EXTRACT(DOW FROM payment_date) = 1;




/*
Section 7:
*/
-- See assessment test file


/*
Section 8:
*/
-- No Challenges


/*
Section 9:
*/
-- See assessment test file



/*
Section 10:
*/
-- Lecture 74 --
-- CASE Challenge task
-- We want to know and compare the arious amounts of films we have
-- per movie rating use CASE
SELECT film.title, SUM(payment.amount) FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY film.title


-- 
SELECT * FROM film
--
SELECT
SUM(CASE rating WHEN 'R' THEN 1 ELSE 0 END) AS r,
SUM(CASE rating WHEN 'PG' THEN 1 ELSE 0 END) AS pg,
SUM(CASE rating WHEN 'PG-13' THEN 1 ELSE 0 END) AS "pg-13"
FROM film

-- OR 
SELECT rating, COUNT(film_id) FROM FILM
GROUP BY rating;