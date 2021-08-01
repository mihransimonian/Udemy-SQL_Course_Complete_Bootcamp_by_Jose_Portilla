-- Lecture 34 --
-- ASSESSMENT TEST 1 --
-- COMPLETE THE FOLLOWING TASKS!

-- 1. Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.
-- The answer should be customers 187 and 148.
SELECT * FROM payment LIMIT 5; -- understand the data

SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) >= 110-- at least
ORDER BY SUM(amount) DESC;
-- Result; correct!



-- 2. How many films begin with the letter J? --
-- The answer should be 20.
SELECT * FROM film LIMIT 5; -- understand the data

SELECT COUNT(DISTINCT(title)) FROM film
WHERE title ILIKE 'J%';
-- Result: correct!



-- 3. What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?
-- The answer is Eddie Tomlin
SELECT * FROM customer LIMIT 5; -- understand the data
-- Breakdown of question:
	-- select first_name, last_name
	-- highest customer id (DESC)
	-- name starts with E ('E%')
	-- Addres_id < 500
SELECT first_name, last_name, customer_id FROM customer
WHERE address_id < 500 AND first_name LIKE 'E%' -- Eddie is the first_name
ORDER BY customer_id DESC;
-- Result: correct!