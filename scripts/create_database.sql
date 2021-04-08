drop database if exists dbexam;
CREATE DATABASE if not exists dbexam ;
USE dbexam;
CREATE TABLE if not exists director (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) BINARY NOT NULL UNIQUE
);
CREATE TABLE if not exists actor (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) BINARY NOT NULL UNIQUE
);
CREATE TABLE if not exists country (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) BINARY NOT NULL UNIQUE
);
CREATE TABLE if not exists movie (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(255) BINARY,
type ENUM('movie','tv_show') NOT NULL,
date_time DATETIME NOT NULL,
description TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS movie_country(
    movie_id  integer REFERENCES movie(id) ON UPDATE CASCADE ON DELETE CASCADE,
    country_id integer REFERENCES country(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (movie_id, country_id)
);
CREATE TABLE IF NOT EXISTS movie_actor(
    movie_id  integer REFERENCES movie(id) ON UPDATE CASCADE ON DELETE CASCADE,
    actor_id integer REFERENCES actor(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (movie_id, actor_id)
);
CREATE TABLE IF NOT EXISTS movie_director(
    movie_id  integer REFERENCES movie(id) ON UPDATE CASCADE ON DELETE CASCADE,
    director_id integer REFERENCES director(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (movie_id, director_id)
);