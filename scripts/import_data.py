import pandas as pd
import json
import mysql.connector
from mysql.connector import errorcode

class Movie:
  def __init__(self, title, movie_type, description, actors,countries,directors):
    self.title = title
    self.movie_type = movie_type
    self.description = description
    self.actors = actors
    self.countries = countries
    self.directors = directors
df = pd.read_csv(r'netflix_titles.csv')
df.to_json(r'netflix_titles.json')
data_string = open("netflix_titles.json", mode='r', encoding='utf-8').read()
data_json = json.loads(data_string)
movies = set()
for i in range(0,len(data_json["show_id"])):
  title = data_json["title"][str(i)]
  movie_type = data_json["type"][str(i)]
  description = data_json["description"][str(i)]
  actors = map(lambda x: x.strip(" "), set(data_json["cast"][str(i)].split(',')) if data_json["cast"][str(i)] != None else [])
  countries = map(lambda x: x.strip(" "), set(data_json["country"][str(i)].split(',')) if data_json["country"][str(i)] != None else [])
  directors = map(lambda x: x.strip(" "), set(data_json["director"][str(i)].split(',')) if data_json["director"][str(i)] != None else [])
  movies.add(Movie( title, movie_type, description, actors,countries,directors))
directors = set()
countries = set()
actors = set()
for value_country in set(data_json["country"].values()):
  if value_country != None:
    for country in value_country.split(','):
      countries.add(country.strip(" "))
for value_director in set(data_json["director"].values()):
  if value_director != None:
    for director in value_director.split(','):
      directors.add(director.strip(" "))
for value_cast in set(data_json["cast"].values()):
  if value_cast != None:
    for cast in value_cast.split(','):
      actors.add(cast.strip(" "))
try:
  db_connection = mysql.connector.connect(host='localhost', user='root', password='root', database='dbexam')
  cursor = db_connection.cursor()
  add_country = ('INSERT INTO country (name) VALUES (%s)')
  for (name) in countries:
    if name != None and name:
      cursor.execute(add_country,(name,))
  add_director = ('INSERT INTO director (name) VALUES (%s)')
  for (name) in directors:
    if name != None and name:
      cursor.execute(add_director,(name,))
  add_actor = ('INSERT INTO actor (name) VALUES (%s)')
  for (name) in actors:
    if name != None and name:
      cursor.execute(add_actor,(name,))
  add_movie = ('INSERT INTO movie (title,type,description) VALUES (%s,%s,%s)')
  add_movie_country = ('INSERT INTO movie_country (movie_id,country_id) VALUES ((SELECT id FROM movie WHERE title=%s),(SELECT id FROM country WHERE name=%s))')
  add_movie_actor = ('INSERT INTO movie_actor (movie_id,actor_id) VALUES ((SELECT id FROM movie WHERE title=%s),(SELECT id FROM actor WHERE name=%s))')
  add_movie_director = ('INSERT INTO movie_director (movie_id,director_id) VALUES ((SELECT id FROM movie WHERE title=%s),(SELECT id FROM director WHERE name=%s))')
  for (movie) in movies:
    if movie != None:
      cursor.execute(add_movie,(movie.title,movie.movie_type,movie.description,))
      for country in movie.countries:
        if country != None and country:
          cursor.execute(add_movie_country,(movie.title,country,))
      for actor in movie.actors:
        if actor != None and actor:
          cursor.execute(add_movie_actor,(movie.title,actor,))
      for director in movie.directors:
        if director != None and director:
          cursor.execute(add_movie_director,(movie.title,director,))         
  db_connection.commit()
  print("success!")
except mysql.connector.Error as error:
	if error.errno == errorcode.ER_BAD_DB_ERROR:
		print("Database doesn't exist - create database dbexam")
	elif error.errno == errorcode.ER_ACCESS_DENIED_ERROR:
		print("User name or password is wrong")
	else:
		print(error)
else:
	db_connection.close()