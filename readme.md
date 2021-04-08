> :speech_balloon: Project of the database discipline

# :notebook_with_decorative_cover: Project of the database discipline

"Utilizando as bases de informação listadas no material X, modelar um Banco de dados Relacional normalizado até BCNF, popular ele com todos os dados existentes na base de dados escolhida e confeccionar 5 consultas utilizando JUNÇÕES, PROJEÇÕES E RESTRIÇÕES.
Obs.:
1- Quanto mais complexas forem as consultas, melhor o trabalho será avaliado.
2- As consultas devem ser feitas de modo a executarem da forma mais eficiente possível."

material X: https://learnsql.com/blog/free-online-datasets-to-practice-sql/

# :movie_camera: Overview

The dataset used was https://www.kaggle.com/shivamb/netflix-shows and they were treated and transformed into json to facilitate the population of the following diagram:

<img src="/images/image-relations.png"></br>

- <a href="/queries/queries_database.sql">Queries</a>:

1. This query selects all films that are of the "Film" type and films that were made in Brazil or the United States, grouping the fields of the names of the actors, directors and countries in a single field:

```sql
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
```

<a href="preview-query-results/Result_1.md">see a preview of this query here </a>

2. Number of films made by each director with the number of different countries in which that director directs a film:

```sql
SELECT director.name, count(DISTINCT movie_director.movie_id) as 'amount_movies',
count(DISTINCT movie_country.country_id) 'amount_countries'
FROM director
INNER JOIN movie_director ON  movie_director.director_id = director.id
INNER JOIN movie ON  movie_director.movie_id = movie.id
INNER JOIN movie_country ON  movie_country.movie_id = movie.id
group by director.id
order by amount_movies desc;
```

<a href="preview-query-results/Result_2.md">see a preview of this query here </a>

3. Number of films made by each actor with the number of different countries in which this actor acted:

```sql
SELECT actor.name, count(DISTINCT movie_actor.movie_id) as 'amount_movies',
count(DISTINCT movie_country.country_id) 'amount_countries'
FROM actor
INNER JOIN movie_actor ON  movie_actor.actor_id = actor.id
INNER JOIN movie ON  movie_actor.movie_id = movie.id
INNER JOIN movie_country ON  movie_country.movie_id = movie.id
group by actor.id
order by amount_movies desc;
```

<a href="preview-query-results/Result_3.md">see a preview of this query here </a>

4. Number of actors, directors and countries related to each film:

```sql
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
```

<a href="preview-query-results/Result_4.md">see a preview of this query here </a>

5. Number of films recorded in each country:

```sql
SELECT country.name,
count(DISTINCT movie_country.movie_id) as 'amount_movies'
FROM country
INNER JOIN movie_country ON  movie_country.country_id = country.id
group by country.id
order by amount_movies desc;
```

<a href="preview-query-results/Result_5.md">see a preview of this query here </a>

# :construction_worker: Installation

1. first clone the repository

```
$ git clone https://github.com/pedrohsampaioo/database_exam_1.git

$ cd database_exam_1

```

2. Create the database, connect to it and create the schema:

- you can create normally using a valid mysql server and visual interface tools.

- **(RECOMMENDED)** create using a **Docker** (run from within the cloned directory ):

```bash
$ docker pull mysql

$ docker run -it --name dbexam -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql

$ docker exec -u root -it dbexam bash

$ mysql -u root -p

# Password is 'root'

mysql> create database dbexam;

```

- Establish a connection to the database and the dbexam schema and run the file <a href="dump-db-exam/dbexam_generate.sql">dbexam_generate.sql</a> to get everything ready to carry out the queries.

**the process for transforming one data into another is in the <a href="scripts/import_data.py">import_data.py</a> script**
