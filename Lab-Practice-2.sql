#Exercise 2: Single-Relation Queries 
#2.1 Display all the records of the tables- actor, movie, mcast in a database

SELECT * FROM actor;
SELECT * FROM movie;
SELECT * FROM mcast;

#2.2 For each actor in the actor table, list the first name only
SELECT first_name FROM actor; 

#2.3 List first names of actors whose first name starts with 'm' (Hint: see LIKE operator in MySQL documentation.)
SELECT first_name FROM actor
WHERE first_name LIKE " M%"; #wildcard

#2.4 List first names of actors born in the year 1950 
SELECT first_name 
FROM actor 
WHERE YEAR(DOB) = 1950; 

#2.5 List last names of actors with a name Patricia and born before the year 1950
SELECT last_name 
FROM actor 
WHERE first_name = 'Patricia' AND YEAR(dob) < 1950;

#2.6 List distinct last_names of actors in our database and compare to listings actors last_names without the DISTINCT clause.)
# Order the result in ascending order

##Option 1
SELECT last_name
FROM actor
ORDER BY last_name ASC;

##Option 2
SELECT DISTINCT last_name #DISTINCT clause is used to remove duplicate rows from your query results, returning only unique values.
FROM actor
ORDER BY last_name ASC; #ORDER BY clause sorts query results in ascending/descending order 

#2.7 How many years ago was each movie released? List movie title and number of years
SELECT title,
YEAR(CURRENT_DATE()) - release_year AS years_ago
FROM movie;
 
#2.8 List actor's name and age for all actors who are not deceased 
SELECT first_name, last_name, TIMESTAMPDIFF(YEAR, DOB,CURDATE()) AS "age" #Calculates the difference between two dates/times
FROM actor
WHERE DECEASED=0;

#2.9 How many actors are listed in our database? How many movies are listed in our database?
SELECT COUNT(*) # Tells SQL to count rows
FROM actor;

SELECT COUNT(*)
FROM movie;

#2.10 How many actors do play in movies listed in our DB?
SELECT COUNT(DISTINCT aid)
FROM mcast; 

#With this query we would count twice actors who plau in more than one movie:
SELECT COUNT(*) FROM mcast;

SELECT COUNT(aid)
FROM mcast;

#2.11 How many movies were released before 1950?
SELECT COUNT(movie_id)
FROM movie
WHERE releaseyear < 1950;

#Exercise 3: Set Operations
## 3.1 List the first and last names of actors born before 1930 or after 1950 (use UNION).

(SELECT first_name, last_name FROM actor WHERE YEAR(DOB) < 1930)
UNION
(SELECT first_name, last_name FROM actor WHERE YEAR(DOB) > 1950);


#alternative:
SELECT first_name , last_name
FROM actor  
WHERE YEAR(DOB) < 1930 OR YEAR(DOB) > 1950; #YEAR(DOB) extracts only the year - not complete date.

## 3.2 List actors (full record) with a name Margot or George (use UNION)
SELECT * FROM actor 
WHERE first_name = "Margot"
UNION
SELECT * FROM actor
WHERE first_name = "George";

#Exercise 4: Working with NULL
##4.1 List titles of movies where the IMDB rank is unknown
SELECT title 
FROM movie
WHERE imdbrank is NULL; 

##4.2 List titles of movies where IMDB rank is not NULL
SELECT title
FROM movie
WHERE imdbrank IS NOT NULL; 

#Exercise 5: Aggregate Functions - perform a caluclation across a set of rows and returns a single summary value
##5.1 Find Average imdbrank among all movies.
SELECT AVG(imdbrank)
FROM movie; 

##5.2 Find the minimum and maximum imdbrank among all movies
SELECT MIN(imdbrank) as "minimum rank", MAX(imdbrank) as "maximum rank" #aliases 
FROM movie;

##5.3 In one query, find average IMDB rank using two approaches:
#5.3.1 AVG(IMDB rank)
#5.3.2 Add up all the IMDB ranks divided by the total number of movies

SELECT AVG(imdbrank), sum(imdbrank)/COUNT(*)
FROM movie; 

#Exercise 6: Aggregation with Grouping
##6.1 Find average imdb rank of movies for each movie genre
SELECT genre, AVG(imdbrank)
FROM movie
GROUP BY genre; 

##6.2 Query as in 6.1, but name the result "average IMDB rank" using AS command
SELECT genre, AVG(imdbrank) AS "Average IMDB rank"
FROM movie
GROUP BY genre;

##6.3 For each movie (list movie_id), find total number of actors who play in it
SELECT movie_id, COUNT(aid) AS "Number of actors"
FROM mcast
GROUP BY movie_id; 

##6.4 List movies and associated numbers of actors for movies with more than 1 actor
SELECT movie_id, COUNT(aid) AS number_of_actors #COUNT(aid) counts actors within each movie's group
FROM mcast
GROUP BY movie_id
HAVING number_of_actors > 1; #Clause
