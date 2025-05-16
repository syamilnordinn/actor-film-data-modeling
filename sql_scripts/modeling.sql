SELECT *
FROM portfolioproject.dbo.actorfilms

--Count Number fo Rows of the dataset
SELECT COUNT(*)
FROM portfolioproject.dbo.actorfilms

--Count UNIQUE actor_id for creating dimension table
SELECT COUNT(DISTINCT(actorid))
FROM portfolioproject.dbo.actorfilms


--Create table for the first dimension table (actors)
CREATE TABLE actors
(ACTOR VARCHAR(30),
ActorId VARCHAR(20));

--Insert values into the actor table
INSERT INTO actors(ACTOR, ActorId)
SELECT DISTINCT Actor, ActorID
FROM portfolioproject.dbo.actorfilms

--Rename column
EXEC sp_rename 'actors.Actor', 'Name', 'COLUMN';

--Check the data actors table
SELECT *
FROM actors

--Count rows on actors table for validation
SELECT COUNT(*)
FROM actors

--Add UNIQUE constraint on actorid
ALTER TABLE actors
ADD CONSTRAINT unique_actorId UNIQUE (actorId);

--Set actorid to NOT NULL
ALTER TABLE actors
ALTER COLUMN actorId VARCHAR(20) NOT NULL;

--Create second dimension table (Films)
CREATE TABLE Films
(FILM VARCHAR(50),
Year INT,
Votes INT,
Rating INT,
FilmID VARCHAR(20))

--Rename column 'FILM' to 'Name'
EXEC sp_rename 'Films.FILM', 'Name', 'COLUMN';

--Alter type of column 'Name' to fit all transferred in characters from actorfilms table
ALTER TABLE Films
ALTER COLUMN Name VARCHAR(200);

--Insert Values into Films Table
INSERT INTO Films(Name, Year, Votes, Rating,FilmID)
SELECT DISTINCT Film, Year, Votes, Rating, FilmId
FROM portfolioproject.dbo.actorfilms

--Set filmID to NOT NULL
ALTER TABLE films
ALTER COLUMN filmID VARCHAR(20) NOT NULL;

--Set filmID to be PRIMARY KEY
ALTER TABLE Films
ADD CONSTRAINT fil_key PRIMARY KEY (filmID)

--Rename 'Name' to 'Title'
EXEC sp_rename 'Films.Name', 'Title', 'COLUMN';

--Drop Unecessary Columns from actorfilms table
ALTER TABLE portfolioproject.dbo.actorfilms
DROP COLUMN Actor

ALTER TABLE portfolioproject.dbo.actorfilms
DROP COLUMN Film

ALTER TABLE portfolioproject.dbo.actorfilms
DROP COLUMN Year

ALTER TABLE portfolioproject.dbo.actorfilms
DROP COLUMN Rating

ALTER TABLE portfolioproject.dbo.actorfilms
DROP COLUMN Votes

--Create new fact table
Create a new fact table
CREATE TABLE actor_film_facts (
    ActorID VARCHAR(20) NOT NULL,
    FilmID VARCHAR(20) NOT NULL,
    PRIMARY KEY (ActorID, FilmID)
);

--Insert/Transfer Values from actorfilms table to actor_film_facts 
INSERT INTO actor_film_facts (ActorID, FilmID)
SELECT ActorID, FilmID
FROM portfolioproject.dbo.actorfilms;

--Define FOREIGN KEYS
ALTER TABLE actor_film_facts
ADD CONSTRAINT act_key FOREIGN KEY (ActorID) REFERENCES actors(ActorId)

ALTER TABLE actor_film_facts
ADD CONSTRAINT film_key FOREIGN KEY (FilmId) REFERENCES films(FilmID)


SELECT *
FROM actor_film_facts

SELECT *
FROM actors

SELECT *
FROM films

--Joined all table and count rows to make sure it matches 'actorfilms' table (191873)
SELECT COUNT(*)
FROM actors as a
JOIN  actor_film_facts as af
ON a.ActorId = af.actorId
JOIN Films as f
ON af.filmid = f.filmid
