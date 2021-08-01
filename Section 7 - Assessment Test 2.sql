----------------
-- Lecture 56 --
SELECT * FROM cd.bookings LIMIT 10;
SELECT * FROM cd.facilities LIMIT 10;
SELECT * FROM cd.members LIMIT 10;



----------------
-- Lecture 57 --
-- Assessment Test 2 --
-- 1. How can you retrieve all the information from the cd.facilities table?
SELECT * FROM cd.facilities;
-- Correct!



-- 2. You want to print out a list of all of the facilities and their cost to members. 
-- How would you retrieve a list of only facility names and costs?
SELECT cd.facilities.name, cd.facilities.membercost FROM cd.facilities;
-- Correct!



-- 3.	How can you produce a list of facilities that charge a fee to members?
SELECT cd.facilities.name, cd.facilities.membercost FROM cd.facilities
WHERE membercost > 0;
-- Correct!



-- 4. How can you produce a list of facilities that charge a fee to members, 
-- and that fee is less than 1/50th of the monthly maintenance cost? 
-- Return the facid, facility name, member cost, 
-- and monthly maintenance of the facilities in question.
-- Result is just two rows:
SELECT my_cd.facid, my_cd.name, my_cd.membercost, my_cd.monthlymaintenance
FROM cd.facilities AS my_cd
WHERE my_cd.membercost < (my_cd.monthlymaintenance / 50) 
AND my_cd.membercost > 0
-- Correct!



-- 5.	How can you produce a list of all facilities with the word 'Tennis' in their name?
SELECT cd.facilities.name FROM cd.facilities
WHERE cd.facilities.name ILIKE '%Tennis%'
-- Correct!



-- 6.	How can you retrieve the details of facilities with ID 1 and 5?
-- Try to do it without using the OR operator.
SELECT * FROM cd.facilities
WHERE cd.facilities.facid IN (1, 5)
-- Correct!



-- 7.	How can you produce a list of members who joined after the start of
-- September 2012? Return the memid, surname, firstname, and joindate of the members in question.
SELECT memid, surname, firstname, joindate FROM cd.members
WHERE joindate >= '2012-09-01'
-- Correct!



-- 8.	How can you produce an ordered list of the first 10 surnames in
-- the members table? The list must not contain duplicates.
SELECT DISTINCT(surname) FROM cd.members
ORDER BY surname ASC
LIMIT 10;
-- Correct!



-- 9.	You'd like to get the signup date of your last member. 
-- How can you retrieve this information?
SELECT joindate FROM cd.members
ORDER BY joindate DESC 
LIMIT 1;
-- It works, but it is not great...

-- The solution given is
SELECT MAX(joindate) AS latest_signup FROM cd.members;
-- It is the same result, but the code is shorter, more optimized perhaps also (using aggregate functions)



-- 10.	Produce a count of the number of facilities that have a 
-- cost to guests of 10 or more.
SELECT COUNT(*) FROM cd.facilities
WHERE guestcost >= 10;
-- Correct!



-- 11.	Produce a list of the total number of slots booked per 
-- facility in the month of September 2012. Produce an output 
-- table consisting of facility id and slots, sorted by the number of slots.
SELECT cd.bookings.facid, SUM(cd.bookings.slots) FROM cd.bookings
WHERE starttime BETWEEN DATE('2012-09-01') AND DATE('2012-10-01')
GROUP BY cd.bookings.facid;
-- Correct!



-- 12.	Produce a list of facilities with more than 1000 slots booked. 
-- Produce an output table consisting of facility id and 
-- total slots, sorted by facility id.
SELECT cd.facilities.facid, SUM(cd.bookings.slots) FROM cd.facilities
INNER JOIN cd.bookings ON cd.bookings.facid = cd.facilities.facid
GROUP BY cd.facilities.facid
HAVING SUM(slots) > 1000
ORDER BY cd.facilities.facid DESC;
-- Correct!



-- 13.	How can you produce a list of the start times for bookings
-- for tennis courts, for the date '2012-09-21'? 
-- Return a list of start time and facility name pairings,
-- ordered by the time.

-- I will start to break down the question
	-- WHERE cd.facilities.name ILIKE '%Tennis Court%'
	-- WHERE cd.bookings.starttime BETWEEN '2012-09-21' AND '2012-09-22'
SELECT cd.bookings.starttime, cd.facilities.name FROM cd.facilities
INNER JOIN cd.bookings ON cd.facilities.facid = cd.bookings.facid
WHERE cd.facilities.name ILIKE '%Tennis Court%'
AND cd.bookings.starttime BETWEEN '2012-09-21' AND '2012-09-22'
ORDER BY cd.bookings.starttime ASC;
-- Correct!, my code is fine but the solution given is slightly different.

SELECT cd.bookings.starttime AS "start", cd.facilities.name AS "name"
FROM cd.facilities INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid 
-- I would not use this, it requires one to know the facid
WHERE cd.facilities.facid IN (0,1)
AND cd.bookings.starttime >= '2012-09-21' 
AND cd.bookings.starttime < '2012-09-22' 
ORDER BY cd.bookings.starttime;
-- Just interesting to see the slight different things

-- Using IN and SubQuery results in the starttimes only
SELECT starttime FROM cd.bookings
WHERE cd.bookings.facid IN 
(SELECT cd.facilities.facid FROM cd.facilities
 WHERE cd.facilities.name ILIKE '%Tennis Court%') -- for tennis courts
AND cd.bookings.starttime BETWEEN '2012-09-21' AND '2012-09-22' -- for the date '2012-09-21'
-- to be clear, the above works but does not answer the question, I just wanted to play a bit



-- 14.	How can you produce a list of the start times for bookings by
-- members named 'David Farrell'?
SELECT memid, starttime FROM cd.bookings
WHERE memid =
(SELECT memid FROM cd.members
 WHERE firstname = 'David' AND surname = 'Farrell')
ORDER BY starttime ASC;
-- Correct! My solution is slightly different than the teachers solution:

SELECT cd.bookings.starttime 
FROM cd.bookings INNER JOIN cd.members 
ON cd.members.memid = cd.bookings.memid 
WHERE cd.members.firstname='David' 
AND cd.members.surname='Farrell';
-- No further comments, I used not a JOIN, but in essence it does not matter