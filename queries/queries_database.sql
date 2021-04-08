-- this query selects all films that are of the "Film" type and films that were made in Brazil or the United States, grouping the fields of the names of the actors, directors and countries in a single field
SELECT movie.title,
group_concat(DISTINCT actor.name) as 'actors',
group_concat(DISTINCT director.name) as 'directors',
group_concat( DISTINCT country.name) as 'countries' ,
movie.type,
movie.description FROM movie
INNER JOIN movie_country ON  movie_country.movie_id = movie.id and movie.type = 'Movie'
INNER JOIN country ON movie_country.country_id = country.id and (country.name = 'Brazil' or country.name = 'United States' )
INNER JOIN movie_director ON movie_director.movie_id = movie.id
INNER JOIN director ON movie_director.id = director.id
INNER JOIN movie_actor ON movie_actor.movie_id = movie.id
INNER JOIN actor ON movie_actor.actor_id = actor.id
group by movie.id;

-- number of films made by each director with the number of different countries in which that director directs a film
SELECT director.name, count(DISTINCT movie_director.movie_id) as 'amount_movies',
count(DISTINCT movie_country.country_id) 'amount_countries'
FROM director
INNER JOIN movie_director ON  movie_director.director_id = director.id
INNER JOIN movie ON  movie_director.movie_id = movie.id
INNER JOIN movie_country ON  movie_country.movie_id = movie.id
group by director.id
order by amount_movies desc;

-- number of films made by each actor with the number of different countries in which this actor acted
SELECT actor.name, count(DISTINCT movie_actor.movie_id) as 'amount_movies',
count(DISTINCT movie_country.country_id) 'amount_countries'
FROM actor
INNER JOIN movie_actor ON  movie_actor.actor_id = actor.id
INNER JOIN movie ON  movie_actor.movie_id = movie.id
INNER JOIN movie_country ON  movie_country.movie_id = movie.id
group by actor.id
order by amount_movies desc;

-- number of actors, directors and countries related to each film
SELECT movie.title,
count(DISTINCT movie_actor.actor_id) as 'amount_actors',
count(DISTINCT movie_director.director_id) 'amount_directors',
count(DISTINCT movie_country.country_id) 'amount_countries'
FROM movie
INNER JOIN movie_actor ON  movie_actor.movie_id = movie.id
INNER JOIN movie_director ON  movie_director.movie_id = movie.id
INNER JOIN movie_country ON  movie_country.movie_id = movie.id
group by movie.id
order by amount_actors desc;

-- number of films recorded in each country
SELECT country.name,
count(DISTINCT movie_country.movie_id) as 'amount_movies'
FROM country
INNER JOIN movie_country ON  movie_country.country_id = country.id
group by country.id
order by amount_movies desc;