USE mydb;



SHOW COLUMNS
FROM cleaned_movie_data;


#find the number of movies per genre
SELECT genre, COUNT(genre) AS number_of_movies_in_genre
FROM cleaned_movie_data
GROUP BY genre;

#find the average rating of movies per genre
SELECT genre, COUNT(genre) AS number_of_movies_in_genre, ROUND(AVG(score)) AS " AVG Score%"
FROM cleaned_movie_data
GROUP BY genre
ORDER BY AVG(score) DESC;

# Count everything where score(ratings) is > 80 than sort and order by genre
SELECT genre, COUNT(*) AS "number_of_top_movies_above_80%"
FROM cleaned_movie_data
WHERE score > 80
GROUP BY genre
ORDER BY genre;

# same as above but creating a column for multiple score thresholds
SELECT genre,
       COUNT(CASE WHEN score > 60 THEN 1 END) AS "approval_rating_above_60%",
       COUNT(CASE WHEN score > 70 THEN 1 END) AS "approval_rating_above_70%",
       COUNT(CASE WHEN score > 80 THEN 1 END) AS "approval_rating_above_80%",
       COUNT(CASE WHEN score > 90 THEN 1 END) AS "approval_rating_above_90%"
FROM cleaned_movie_data
GROUP BY genre
ORDER BY genre;


#2 Checking for what genre was most popular per year
# first builds a table called ranked_movies while iterating over every year and order movies by score. This column is simply numbered 1,2,3,... and is called movie_rank
SELECT *,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY score DESC) AS movie_rank
  FROM cleaned_movie_data;
  
# then we use this table (the FROM part) select our desired rows (we can't use * because movie_rank is in there) and display only those rows, where movie_rank = 1

SELECT *,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY score DESC) AS movie_rank
  FROM cleaned_movie_data;
WITH ranked_movies AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY score DESC) AS movie_rank
  FROM cleaned_movie_data
)
SELECT unique_name, year, genre, score, tickets_sold, budget, gross, inflation_adjusted_gross
FROM ranked_movies
WHERE movie_rank = 1;


#3 Shows the avg gross per genre with information on datapoints use to acquire the average
SELECT genre, COUNT(DISTINCT year) AS number_of_years, ROUND(AVG(gross)) AS average_gross, ROUND(AVG(inflation_adjusted_gross)) AS average_inflation_adjusted_gross
FROM cleaned_movie_data
GROUP BY genre
ORDER BY average_inflation_adjusted_gross DESC;


#Adventure is the most highly rated genre
#Find how ratings relate to gross profit.
SELECT genre, ROUND(AVG(score)) AS average_rating, ROUND(AVG(gross)) AS gross_average
FROM cleaned_movie_data
GROUP BY genre
ORDER BY gross_average DESC;



#Interesting. Though Adventure scored first in terms of rating and fourth in terms of gross profit,
#Adventure scored second when the gross profit was adjusted for inflation.
#I'm not quite sure what this means, so let's look how the popularity of different genres over the years by using rating as a proxy
#...
#Let's look at budgets, and how they affected profits. We will drop the adjusted_gross_profit since we don't have inflation adjusted budgets
SELECT genre, ROUND(AVG(budget)) AS budget_average, ROUND(AVG(gross)) AS gross_average
FROM cleaned_movie_data
GROUP BY genre
ORDER BY budget_average DESC;


#Just making sure that the weighted average correlates to the average, 
#given that there is a large variance of number of movies per genre
SELECT genre, COUNT(*) AS number_of_movies, ROUND(AVG(score)) AS average_rating, ROUND(AVG(score) / MAX(AVG(score)) OVER () * 100) AS normalized_weighted_rating
FROM cleaned_movie_data
GROUP BY genre
ORDER BY normalized_weighted_rating DESC;


#interesting. Though Adventure scores the highest ratings, it is behind Action, Drama, and Comedy in terms of gross.
#Let's check for gross profit after it's been adjusted for inflation
SELECT genre, ROUND(AVG(score)) AS average_rating, ROUND(AVG(inflation_adjusted_gross)) AS adjusted_gross_average
FROM cleaned_movie_data
GROUP BY genre
ORDER BY adjusted_gross_average DESC;




SELECT genre, ROUND(AVG(budget)) AS budget_average, ROUND(AVG(gross)) AS gross_average
FROM cleaned_movie_data
GROUP BY genre
ORDER BY gross_average DESC;



#Shows the correlation between ticket sold, gross, inflation_adjusted_gross
SELECT year, tickets_sold, gross, inflation_adjusted_gross
FROM cleaned_movie_data
ORDER BY year;
 
# same as above but calculates averages of tickets_sold, gross and infl. adj gross for all movies per year
# shows that gross and infl. adj gross are correlating but also shows a stong variance in the gross data
SELECT year,
	   ROUND(AVG(tickets_sold)) AS average_tickets_sold,
       ROUND(AVG(gross)) AS average_gross,
       ROUND(AVG(inflation_adjusted_gross)) AS average_inflation_adjusted_gross
FROM cleaned_movie_data
GROUP BY year
ORDER BY year;

#Shows the top 3 highest rated movies, their genre and year
SELECT year, genre, unique_name, MAX(score) AS highest_score
FROM cleaned_movie_data
GROUP BY year, genre, unique_name
ORDER BY highest_score DESC
LIMIT 3;

#Shows the least 3 rated movies, their genre and year
SELECT year, genre, unique_name, MIN(score) AS lowest_score
FROM cleaned_movie_data
GROUP BY year, genre, unique_name
ORDER BY lowest_score ASC
LIMIT 3;

#Retrieves the unique number of genre per year
SELECT year, COUNT(unique_name) AS unique_name_count
FROM cleaned_movie_data
GROUP BY year
ORDER BY year;







