USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS director_mapping_count
FROM director_mapping;
SELECT COUNT(*) AS genre_count
FROM genre;
SELECT COUNT(*) AS movie_count
FROM movie;
SELECT COUNT(*) AS names_count
FROM NAMES;
SELECT COUNT(*) AS ratings_count
FROM ratings;
SELECT COUNT(*) AS role_mapping_count
FROM role_mapping;

/* Anhad's Comment

Total Number of Rows in Director_Mapping Table = 3867
Total Number of Rows in Genre Table = 14662
Total Number of Rows in Movie Table = 7997
Total Number of Rows in Names Table = 25735
Total Number of Rows in Ratings Table = 7997
Total Number of Rows in Role_Mapping Table = 15615
*/ 


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
    SUM(case when id is null then 1 else 0 end) as id, 
    SUM(case when title is null then 1 else 0 end) as title, 
    SUM(case when year is null then 1 else 0 end) as year,
    SUM(case when date_published is null then 1 else 0 end) as date_published,
    SUM(case when duration is null then 1 else 0 end) as duration,
    SUM(case when country is null then 1 else 0 end) as country,
    SUM(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income,
    SUM(case when languages is null then 1 else 0 end) as languages,
    SUM(case when production_company is null then 1 else 0 end) as production_company
FROM movie;

/* Anhad's Comment

The columns 'country', 'worldwide_gross_income', 'languages' and 'production_company' have null values in them
*/ 

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

-- Year Wise movie released
SELECT YEAR, COUNT(title) AS number_of_movies
FROM movie
GROUP BY YEAR
ORDER BY YEAR ASC;

/* Anhad's Comment

Total Number of Movies released in 2017 = 3052
Total Number of Movies released in 2018 = 2944
Total Number of Movies released in 2019 = 2001
*/ 

-- Month wise movies released over the span of 3 years
SELECT MONTH(date_published) AS month_num, COUNT(title) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY number_of_movies DESC;

/* Anhad's Comment

March has the highest number of movies produced followed by September and January
*/ 



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT COUNT(*) AS movies_count
FROM movie
WHERE YEAR = 2019 AND
LOWER(country) LIKE '%usa%' OR LOWER(country) LIKE '%india%';



/* Anhad's Comment

USA and India produced 1818 movies in the year 2019.
*/ 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre)
FROM genre;

/* Anhad's Comment

List of unique Genres:
Drama, fantasy, thriller, comedy, horror, family, romance, adventure, action, sci-fi, crime, mystery, others
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(movie_id)
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC;

/* Anhad's Comment

The Genre 'Drama' had the highest number of movies produced overall
*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH distinct_genre AS
(
SELECT movie_id,genre
FROM genre
GROUP BY movie_id
HAVING COUNT(DISTINCT genre) = 1
)
SELECT COUNT(*) AS total_movies_with_one_genre
FROM distinct_genre;

/* Anhad's Comment

A total of 3289 movies belong to only one genre.
*/


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

SELECT g.genre, AVG(m.duration) AS agv_duration
FROM movie AS m
INNER JOIN genre AS g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY AVG(m.duration) DESC;

/* Anhad's Comment

Action films tend to have the highest average duration of 113 minutes followed by Romantic movies with 110 minutes
*/



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

WITH genre_rank_table AS (
SELECT genre, COUNT(movie_id) AS movie_count, RANK() over(
ORDER BY COUNT(movie_id) DESC
) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT *
FROM genre_rank_table AS g
WHERE LOWER(g.genre) = 'thriller';

/* Anhad's Comment

Thriller genre has a rank of 3
*/

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

SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS m_median_rating
FROM ratings;

/* Anhad's Comment

Min and Max values are as expected and thus confirms that there is no outlier
*/

   

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

WITH avg_rating_rank AS
(
SELECT m.title AS title,
 r.avg_rating AS avg_rating, DENSE_RANK() OVER(
ORDER BY r.avg_rating DESC
) AS movie_rank
FROM ratings AS r
INNER JOIN
movie AS m ON r.movie_id = m.id
)
SELECT *
FROM avg_rating_rank
WHERE movie_rank <= 10;

/* Anhad's Comment

Kirket, Love in Kilnerry and Gini Helida Kathe are the top 3 among the top 10 movies
*/ 



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

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY COUNT(movie_id) DESC;

/* Anhad's Comment

Most number of movies have a median count of 7 followed by a median count of 6
*/


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


SELECT m.production_company, COUNT(m.id) AS movie_count, DENSE_RANK() OVER(
ORDER BY COUNT(m.id) DESC
) AS prod_company_rank
FROM movie AS m
INNER JOIN 
	ratings AS r ON m.id = r.movie_id
WHERE r.avg_rating > 8 AND
 m.production_company IS NOT NULL
GROUP BY m.production_company;

/* Anhad's Comment

Both Dream Warrior Pictures and National Theatre Live have produced the most number of hit movies
*/


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

SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN movie AS m ON g.movie_id = m.id
INNER JOIN ratings AS r ON r.movie_id = g.movie_id
WHERE m.year = 2017 AND MONTH(m.date_published) = 3 AND 
		r.total_votes > 1000 AND LOWER(m.country) LIKE '%usa%'
GROUP BY g.genre
ORDER BY movie_count DESC;

/* Anhad's Comment

The highest number of movies released during 
March 2017 in the USA which got more than 1000 votes belong to Drama genre.
*/

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

SELECT m.title AS title,
		 r.avg_rating AS avg_rating,
		 g.genre AS genre
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
INNER JOIN genre AS g ON m.id = g.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY avg_rating DESC, genre DESC;

/* Anhad's Comment

The movie 'The Brighton Miracle' has the highest average rating of 9.5 and belongs to the Drama genre.
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.id) AS count_of_movies_with_median_rating_8
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND 
		r.median_rating = 8;
		
		
/* Anhad's Comment

A total of 361 movies released between 1 April 2018 and 1 April 2019 got the median rating of 8 .
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT SUM(r.total_votes) AS total_votes,
       CASE
           WHEN LOWER(m.languages) LIKE '%german%' THEN 'German'
           WHEN LOWER(m.languages) LIKE '%italian%' THEN 'Italian'
       END AS movie_languages
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE LOWER(m.languages) LIKE '%german%' OR LOWER(m.languages) LIKE '%italian%'
GROUP BY movie_languages
ORDER BY total_votes DESC;

/* Anhad's Comment

Yes. German movies do get more votes than that of the italian ones .
*/

-- Answer is Yes

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

SELECT SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id, 
       SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name, 
		 SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height, 
		 SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth, 
		 SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies
FROM names;

/* Anhad's Comment

The columns 'height', 'date_of_birth', 'known_for_movies' have null values in them.
*/


/* There are no Null value in the column 'name'.
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


WITH top_3_genres AS (
SELECT genre, COUNT(g.movie_id) AS movie_counts
FROM genre AS g
JOIN ratings AS r ON r.movie_id=g.movie_id
WHERE avg_rating>8
GROUP BY genre
ORDER BY movie_counts DESC
LIMIT 3
)
SELECT n.name AS director_name, COUNT(g.movie_id) AS movie_count
FROM NAMES n
JOIN director_mapping AS d ON n.id=d.name_id
JOIN genre AS g ON d.movie_id=g.movie_id
JOIN ratings AS r ON r.movie_id=g.movie_id,
top_3_genres
WHERE g.genre in (top_3_genres.genre) AND avg_rating> 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

/* Anhad's Comment

James Mangold seem to be the highest ranking director with 6 movies to his name .
*/

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

SELECT n.name AS actor_name, COUNT(r.movie_id) AS movie_count, DENSE_RANK() OVER(
ORDER BY COUNT(r.movie_id) DESC) AS ranks
FROM NAMES AS n
INNER JOIN role_mapping AS rm ON n.id = rm.name_id
INNER JOIN ratings AS r ON r.movie_id = rm.movie_id
WHERE r.median_rating >= 8
GROUP BY actor_name
LIMIT 2;

/* Anhad's Comment

Mammootty and Mohanlal are the two actors with movies having median rating > 8 .
*/

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

WITH production_comp_rank AS 
(
SELECT m.production_company, SUM(r.total_votes) AS vote_count, DENSE_RANK() OVER(
ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY prod_comp_rank
)
SELECT *
FROM production_comp_rank
WHERE prod_comp_rank <=3;

/* Anhad's Comment

Marvel Studios, Twentieth Century Fox and Warner Bros. are the top 3 production houses.
*/

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

SELECT n.name AS actor_name, 
       SUM(r.total_votes) AS total_votes, 
		 COUNT(r.movie_id) AS movie_count, 
		 ROUND(SUM(r.avg_rating*total_votes)/ SUM(r.total_votes),2) AS actor_avg_rating, 
		 DENSE_RANK() OVER(ORDER BY avg_rating DESC,total_votes DESC) AS actor_rank
FROM
	movie AS m
LEFT JOIN
	ratings AS r ON
	m.id = r.movie_id
INNER JOIN
	role_mapping AS rm ON m.id = rm.movie_id
INNER JOIN NAMES AS n ON
	n.id = rm.name_id
WHERE LOWER(country) LIKE '%india%' AND LOWER(category) = 'actor'
GROUP BY 
 actor_name
HAVING movie_count >= 5;

/* Anhad's Comment

Vijay Sethupathi is the top actor with an average rating of 8.42.
*/

-- Top actor is Vijay Sethupathi

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

SELECT NAME AS
 actress_name, SUM(total_votes) AS total_votes, COUNT(rm.movie_id) AS
 movie_count, ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS
 actress_avg_rating, DENSE_RANK()
 OVER(
ORDER BY avg_rating DESC, SUM(total_votes) DESC) AS
 actress_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN NAMES n ON n.id = rm.name_id
WHERE LOWER(country) LIKE "%india%" AND LOWER(category) = "actress" AND LOWER(languages) = "hindi"
GROUP BY actress_name
HAVING movie_count >= 3;

/* Anhad's Comment

Taapsee Pannu tops with average rating 7.74 and total votes of 18,061.
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT m.title,
       CASE
           WHEN r.avg_rating > 8 THEN 'Superhit Movies'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN r.avg_rating < 5 THEN 'Flop movies'
       END AS movie_category
FROM movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id
                INNER JOIN genre AS g ON m.id = g.movie_id
WHERE LOWER(g.genre) = 'thriller'
ORDER BY movie_category;

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

SELECT genre,
       ROUND(AVG(duration),2) AS avg_duration,
       ROUND(SUM(AVG(duration)) OVER (ORDER BY AVG(duration)), 2) AS running_total_duration,
       ROUND(AVG(AVG(duration)) OVER (ORDER BY AVG(duration) ROWS BETWEEN 2 preceding AND CURRENT ROW), 2) AS moving_avg_duration
FROM movie AS m INNER JOIN genre AS g ON m.id = g.movie_id
GROUP BY genre;

/* Anhad's Comment

Action Movies seem to have the highest running total duration
*/


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

WITH top_genre AS
(
SELECT genre,COUNT(m.id) AS movie_count,
       RANK() OVER(ORDER BY COUNT(m.id) DESC) AS movie_count_rank
FROM genre AS g, movie AS m
WHERE g.movie_id = m.id
GROUP BY genre
),
top_gross_movie AS
(
SELECT g.genre,m.year,m.title,
       CAST(TRIM(LEADING '$' FROM worlwide_gross_income) AS DECIMAL) AS worldwide_gross_income,
       RANK() OVER(PARTITION BY m.year ORDER BY CAST(TRIM(LEADING '$' FROM worlwide_gross_income) AS DECIMAL) DESC) AS movie_rank
FROM genre AS g, movie AS m, top_genre AS tg
WHERE g.movie_id = m.id
AND g.genre = tg.genre
AND tg.movie_count_rank<=3
)
SELECT genre,YEAR,title,worldwide_gross_income,movie_rank
FROM top_gross_movie
WHERE movie_rank<=5;


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

WITH production_company_rank AS
(
SELECT m.production_company, COUNT(m.id) AS movie_count, DENSE_RANK() OVER(
ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND POSITION(',' IN m.languages)>0 AND m.production_company IS NOT NULL
GROUP BY m.production_company
)
SELECT * FROM production_company_rank WHERE prod_comp_rank <=2;


/* Anhad's Comment

Star Cinemas and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.
*/

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

SELECT n.name, SUM(total_votes) AS total_votes, COUNT(r.movie_id) AS movie_count, 
 avg_rating AS actress_avg_rating, ROW_NUMBER() over (
ORDER BY COUNT(movie_id) DESC) AS actess_rank
FROM ratings AS r
JOIN movie AS m ON r.movie_id=m.id
JOIN role_mapping AS rm ON m.id=rm.movie_id
JOIN NAMES AS n ON rm.name_id=n.id
JOIN genre AS g ON m.id=g.movie_id
WHERE category = 'actress' AND avg_rating>8 AND genre = 'drama'
GROUP BY name
LIMIT 3;


/* Anhad's Comment

Top 3 actress are Parvathy, Susan and Amanda.
*/



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

WITH date_in AS
(
SELECT d.name_id, name, d.movie_id,
	 m.date_published, 
 lead(date_published, 1) over (PARTITION BY d.name_id
ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
JOIN NAMES n ON d.name_id=n.id
JOIN movie m ON d.movie_id=m.id
),
date_dif AS
(
SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
FROM date_in
),
 avg_inter_days AS
 (
SELECT name_id, AVG(diff) AS avg_inter_movie_days
FROM date_dif
GROUP BY name_id
),
 final AS
 (
SELECT d.name_id AS director_id,
	 name AS director_name, COUNT(d.movie_id) AS number_of_movies, ROUND(avg_inter_movie_days) AS avg_inter_movie_days, ROUND(AVG(avg_rating),2) AS avg_rating, SUM(total_votes) AS total_votes, MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating, SUM(duration) AS total_duration, ROW_NUMBER() over(
ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
FROM NAMES n
JOIN director_mapping d ON n.id=d.name_id
JOIN ratings r ON d.movie_id=r.movie_id
JOIN movie m ON m.id=r.movie_id
JOIN avg_inter_days a ON a.name_id=d.name_id
GROUP BY director_id
)
SELECT director_id, director_name, number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
FROM final
WHERE director_row_rank <=9
ORDER BY avg_rating DESC;