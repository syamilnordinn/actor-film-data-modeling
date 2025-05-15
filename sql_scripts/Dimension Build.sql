SELECT *
FROM portfolioproject.dbo.actorfilms


SELECT COUNT(*)
FROM portfolioproject.dbo.actorfilms

SELECT COUNT(DISTINCT(actorid))
FROM portfolioproject.dbo.actorfilms

CREATE TABLE actors
(ACTOR VARCHAR(30),
ActorId VARCHAR(20));

INSERT INTO actors(ACTOR, ActorId)
SELECT DISTINCT Actor, ActorID
FROM portfolioproject.dbo.actorfilms

EXEC sp_rename 'actors.Actor', 'Name', 'COLUMN';

SELECT *
FROM actors

ALTER TABLE actors
ADD CONSTRAINT unique_actorId UNIQUE (actorId);


ALTER TABLE actors
ALTER COLUMN actorId VARCHAR(20) NOT NULL;

CREATE TABLE Films
(FILM VARCHAR(50),
Year INT,
Votes INT,
Rating INT,
FilmID VARCHAR(20))

ALTER TABLE Films
ALTER COLUMN Name VARCHAR(200);


EXEC sp_rename 'Films.FILM', 'Name', 'COLUMN';

INSERT INTO Films(Name, Year, Votes, Rating,FilmID)
SELECT DISTINCT Film, Year, Votes, Rating, FilmId
FROM portfolioproject.dbo.actorfilms

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

SELECT COUNT(*)
FROM actors as a
JOIN PortfolioProject.dbo.actorfilms as af
ON a.ActorId = af.actorId
JOIN Films as f
ON af.filmid = f.filmid











