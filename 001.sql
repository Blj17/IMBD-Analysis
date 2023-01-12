USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from director_mapping;
-- No.of number rows in director_mapping is 3867.
select count(*) from genre;
-- No.of number rows in genre is 14662.
select count(*) from movie;
-- No.of number rows in movie is 7997.
select count(*) from names;
-- No.of number rows in names is 25735.
select count(*) from ratings;
-- No.of number rows in ratings is 7997.
select count(*) from role_mapping;
-- No.of number rows in role_mapping is 15615.

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
(SELECT count(*) FROM movie WHERE id is NULL) as id,
(SELECT count(*) FROM movie WHERE title is NULL) as title,
(SELECT count(*) FROM movie WHERE year  is NULL) as year,
(SELECT count(*) FROM movie WHERE date_published  is NULL) as date_published,
(SELECT count(*) FROM movie WHERE duration  is NULL) as duration,
(SELECT count(*) FROM movie WHERE country  is NULL) as year, 
(SELECT count(*) FROM movie WHERE worlwide_gross_income  is NULL) as worlwide_gross_income,
(SELECT count(*) FROM movie WHERE languages  is NULL) as languages,
(SELECT count(*) FROM movie WHERE production_company  is NULL) as production_company
;

-- found null in below given columns ( count mentioned) 
-- Null values in year 20
-- Null values in worlwide_gross_income  3724
-- Null values in languages 194
-- Null values in production_company 528

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Highest number of movies released in 2017 (3052)

select Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY NUMBER_OF_MOVIES desc; 
-- March has highest number of movie releases and December has least number of movie releases.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(id) AS movie_produced
	,Year
FROM movie
WHERE (
		country LIKE '%INDIA%'
		OR country LIKE '%USA%'
		)
	AND year = 2019;


-- 1059 movies where produced in the USA or INDIA in the year of 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT (genre)
FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre
	,count(m.id) AS number_of_Movies
FROM movie AS m
INNER JOIN genre AS g
WHERE g.movie_id = m.id
GROUP BY genre
ORDER BY number_of_Movies DESC limit 1;


-- 4285 movies where produced in the Drama genre which is the highest Number of movies Produced.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(movie_id) AS number_of_movies
FROM (
	SELECT movie_id
		,COUNT(DISTINCT genre) AS movies_count
	FROM genre
	GROUP BY movie_id
	HAVING movies_count = 1
	) ZZ;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT gn.genre
	,ROUND(AVG(m.duration), 2) AS Average_Duration
FROM movie m
INNER JOIN genre gn ON m.id = gn.movie_id
GROUP BY genre
ORDER BY AVG(m.duration) DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select * from 
(
SELECT
genre, COUNT(movie_id),
RANK() OVER(ORDER BY COUNT(movie_id) DESC) gen_rank
FROM genre
GROUP BY genre
)ct_genre_rank
WHERE genre="Thriller";




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
    min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT * FROM 
(select title,
       avg_rating,
       dense_rank () over(ORDER BY avg_rating DESC) as movie_rank
from ratings as R
inner join movie as M
on M.id = R.movie_id)zz
where movie_rank<=10
order by movie_rank ;
     

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
select * from 
(select production_company,
       count(id) as movie_count,
       dense_rank() over(ORDER BY Count(movie_id) DESC ) AS prod_company_rank
from ratings as R
inner join  movie as M
on M.id = R.movie_id
where avg_rating > 8 
	  and production_company is not null 
group by production_company)zz
where prod_company_rank=1;

-- Production Company :Dream Warrior Pictures & National Theatre Live has produced the most number of hit movies of 3

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre,
       count(M.id) as movie_count
from movie as M
inner join genre as G
on G.movie_id = M.id
inner join ratings as R
on R.movie_id = M.id
where year = 2017
           AND Month(date_published) = 3
           AND country like '%USA%'
           AND total_votes > 1000
GROUP BY genre
order by movie_count DESC;

-- Drama genre had the maximum no. of releases with 24 movies whereas Family genre was least with 1 movie only

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT DISTINCT title
	,avg_rating
	,genre
FROM movie AS M
INNER JOIN genre AS G ON M.id = G.movie_id
INNER JOIN ratings AS R ON M.id = R.movie_id
WHERE title LIKE 'The%'
	AND avg_rating > 8
ORDER BY avg_rating DESC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating
	,count(*) AS movie_count
FROM movie AS M
INNER JOIN ratings AS R ON M.id = R.movie_id
WHERE median_rating = 8
	AND date_published BETWEEN '2018-04-01'
		AND '2019-04-01'
GROUP BY median_rating;
 

-- 361 movies where published  1 April 2018 and 1 April 2019 with median rating of 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country
	,sum(total_votes) AS total_votes
FROM movie AS M
INNER JOIN ratings AS R ON M.id = R.movie_id
WHERE lower(country) = 'germany'
	OR lower(country) = 'italy'
GROUP BY country;


-- Answer is Yes , Germany movies get more votes than Italian movies

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
(SELECT count(*) FROM names WHERE name is NULL) as name_nulls,
(SELECT count(*) FROM names WHERE height is NULL) as height_nulls,
(SELECT count(*) FROM names WHERE date_of_birth is NULL) as date_of_birth_nulls,
(SELECT count(*) FROM names WHERE known_for_movies is NULL) as known_for_movies_nulls;


/* There are no Null value in the column 'name' and rest all fields have null.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genres
AS (
	SELECT genre
		,Count(m.id) AS movie_count
		,Rank() OVER (
			ORDER BY Count(m.id) DESC
			) AS genre_rank
	FROM movie AS m
	INNER JOIN genre AS g ON g.movie_id = m.id
	INNER JOIN ratings AS r ON r.movie_id = m.id
	WHERE avg_rating > 8
	GROUP BY genre limit 3
	)
	,top_directors
AS (
	SELECT n.NAME AS director_name
		,Count(d.movie_id) AS movie_count
		,Rank() OVER (
			ORDER BY Count(d.movie_id) DESC
			) dr_rank
	FROM director_mapping AS d
	INNER JOIN genre gen ON d.movie_id = gen.movie_id
	INNER JOIN names AS n ON n.id = d.name_id
	INNER JOIN ratings rn ON rn.movie_id = d.movie_id
	INNER JOIN top_3_genres tg ON tg.genre = gen.genre
	WHERE rn.avg_rating > 8
	GROUP BY n.NAME
	)
SELECT director_name
	,movie_count
FROM top_directors
WHERE dr_rank <= 3 limit 3;

-- Top 3 directors are : James Mangold, Soubin Shahir, Joe Russo


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT NN.NAME AS actor_name
	,count(N.movie_id) AS movie_count
FROM role_mapping AS N
INNER JOIN ratings AS R ON R.movie_id = N.movie_id
INNER JOIN names AS NN ON NN.id = N.name_id
WHERE R.median_rating >= 8
	AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC limit 2;

-- top two actors are : Mammootty, Mohanlal


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company
	,sum(r.total_votes) AS vote_count
	,rank() OVER (
		ORDER BY sum(r.total_votes) DESC
		) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY vote_count DESC limit 3;


-- Top three production houses based on the number of votes : Marvel Studios, Twentieth Century Fox, Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT nm.NAME AS actor_name
	,sum(r.total_votes) AS total_votes
	,count(m.id) AS movie_count
	,ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
	,rank() OVER (
		ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC
			,sum(r.total_votes) DESC
		) AS actor_rank
FROM movie m
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names nm ON rm.name_id = nm.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = "actor"
	AND m.country = "India"
GROUP BY nm.NAME
HAVING count(m.id) >= 5;


-- Top actor is Vijay Sethupathi with 23114 total_votes , 5 movie counts , 8.42 as average ratings.
-- Rating clash is seen for Naseeruddin Shah & Anandraj , but as Naseeruddin Shah has more total votes so he tops in the actor ranking.

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT nm.NAME AS actress_name
	,sum(r.total_votes) AS total_votes
	,count(m.id) AS movie_count
	,ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
	,rank() OVER (
		ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC
			,sum(r.total_votes) DESC
		) AS actress_rank
FROM movie m
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names nm ON rm.name_id = nm.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = "actress"
	AND m.country = "India"
	AND m.languages LIKE '%Hindi%'
GROUP BY nm.NAME
HAVING count(m.id) >= 3 LIMIT 5;



/* Taapsee Pannu tops with average rating 7.74 and total votes of 18061 , with 3 movies count.

Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title
	,avg_rating
	,CASE 
		WHEN avg_rating > 8
			THEN "Superhit movies"
		WHEN avg_rating BETWEEN 7
				AND 8
			THEN "Hit movies"
		WHEN avg_rating BETWEEN 5
				AND 7
			THEN "One-time-watch movies"
		ELSE "Flop Movies"
		END AS rating_category
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON r.movie_id = m.id
WHERE genre = "Thriller";


-- Example : Back Roads is categorized as  Hit movies , Fahrenheit 451 as Flop Movies category ,etc.


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT g.genre
	,round(avg(m.duration), 2) AS avg_duration
	,round(SUM(AVG(duration)) OVER (
			ORDER BY genre
			), 1) AS running_total_duration
	,round(AVG(AVG(duration)) OVER (
			ORDER BY genre
			), 2) AS moving_avg_duration
FROM genre g
INNER JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre;

-- Example : We can see Comedy genre has average duration of 102.62 mins , running total duration as 317.4 mins and moving average duration as 105.79 mins


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Here we will first find the top 3 genres 
-- As we have to sort based on worldwide gross income , we need to make sure to convert all currency to dollar 
-- Assuming 1 dollar = 83 INR value and converting the INR to dollar 
-- Finally using the modified worldwide gross income field to calculate the five highest-grossing movies of each year

WITH top_3_genres
AS (
	SELECT genre
		,Count(m.id) AS movie_count
	FROM movie AS m
	INNER JOIN genre AS g ON g.movie_id = m.id
	GROUP BY genre
	ORDER BY movie_count DESC limit 3
	)
	,Modified_movies
AS (
	SELECT *
		,CASE 
			WHEN worlwide_gross_income LIKE '%INR%'
				THEN ROUND(substr(worlwide_gross_income, 5, length(worlwide_gross_income)) / 83, 0)
			ELSE ROUND(substr(worlwide_gross_income, 2, length(worlwide_gross_income)), 0)
			END AS worlwide_gross_income_in_dollar
	FROM movie
	ORDER BY 2 DESC
	)
	,top_movies
AS (
	SELECT g.genre
		,m.year
		,m.title AS movie_name
		,CONCAT (
			'$ '
			,m.worlwide_gross_income_in_dollar
			) AS worldwide_gross_income
		,dense_rank() OVER (
			PARTITION BY m.year ORDER BY m.worlwide_gross_income_in_dollar DESC
			) AS movie_rank
	FROM Modified_movies m
	INNER JOIN genre g ON m.id = g.movie_id
	INNER JOIN top_3_genres tp3_g ON tp3_g.genre = g.genre
	)
SELECT *
FROM top_movies
WHERE movie_rank <= 5;

    

-- We can observe the 3 top genre are Drama,Comedy and Thriller.
-- In year 2017 , movie title The Fate of the Furious belonging to Thriller genre is at rank 1 with total gross income of $ 1236005118



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company
	,COUNT(id) AS movie_count
	,ROW_NUMBER() OVER (
		ORDER BY COUNT(id) DESC
		) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE median_rating >= 8
	AND POSITION(',' IN languages) > 0
	AND production_company IS NOT NULL
GROUP BY production_company LIMIT 2;



-- We saw null values in production company so added a extra null check condition 
-- production_company: Star cinema, with movie count : 7 ,ranks 1
-- production_company: Twentieth Century Fox, with movie count : 4 ,ranks 2


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME AS actress_name
	,SUM(total_votes) AS total_votes
	,COUNT(rm.movie_id) AS movie_count
	,Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
	,RANK() OVER (
		ORDER BY COUNT(rm.movie_id) DESC
		) AS actress_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN ratings r ON r.movie_id = rm.movie_id
INNER JOIN genre g ON g.movie_id = r.movie_id
WHERE g.genre = "Drama"
	AND category = "actress"
	AND avg_rating > 8
GROUP BY NAME LIMIT 3;


-- Actress : Parvathy Thiruvothu, Susan Brown,Amanda Lawrence are the top 3 actress having Super Hit movies in drama genre 
-- You can observe that all the 3 actress have same rank because the movie count is same in all 3.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- Here we need to find the inter movie days for which we need to find using LAG or Lead , lets use lead for this.

WITH ctf_date_summary
AS (
	SELECT d.name_id
		,n.NAME
		,d.movie_id
		,m.duration
		,r.avg_rating
		,r.total_votes
		,m.date_published
		,Lead(date_published, 1) OVER (
			PARTITION BY d.name_id ORDER BY date_published
				,movie_id
			) AS next_published_date
	FROM director_mapping AS d
	INNER JOIN names AS n ON n.id = d.name_id
	INNER JOIN movie AS m ON m.id = d.movie_id
	INNER JOIN ratings AS r ON r.movie_id = m.id
	)
SELECT name_id AS director_id
	,NAME AS director_name
	,COUNT(movie_id) AS number_of_movies
	,ROUND(AVG(Datediff(next_published_date, date_published)), 2) AS avg_inter_movie_days
	,ROUND(AVG(avg_rating), 2) AS avg_rating
	,SUM(total_votes) AS total_votes
	,MIN(avg_rating) AS min_rating
	,MAX(avg_rating) AS max_rating
	,SUM(duration) AS total_duration
FROM ctf_date_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC limit 9;

-- Director Andrew Jones and A.L. Vijay tops the director ranking list with 5 number of movies each.



