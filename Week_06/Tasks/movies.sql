--Напишете заявка, която извежда заглавие и година на всички филми, които са
--по-дълги от 120 минути и са снимани преди 2000 г. Ако дължината на филма е
--неизвестна, заглавието и годината на този филм също да се изведат.

SELECT TITLE, YEAR, LENGTH
FROM MOVIE 
WHERE LENGTH > 120 AND YEAR < 2000 OR LENGTH IS NULL

--Напишете заявка, която извежда име и пол на всички актьори (мъже и жени),
--чието име започва с 'J' и са родени след 1948 година. Резултатът да бъде
--подреден по име в намаляващ ред.

SELECT NAME, GENDER
FROM MOVIESTAR
WHERE NAME LIKE 'J%' AND BIRTHDATE > 1948
ORDER BY NAME DESC;

--Напишете заявка, която извежда име на студио и брой на актьорите,
--участвали във филми, които са създадени от това студио.

SELECT STUDIONAME, COUNT(DISTINCT STARNAME) AS ACTORS_COUNT
FROM MOVIE JOIN STARSIN
	ON TITLE = MOVIETITLE
GROUP BY STUDIONAME

--Напишете заявка, която за всеки актьор извежда име на актьора и броя на
--филмите, в които актьорът е участвал.
	
SELECT NAME, COUNT(MOVIETITLE) AS STAR_IN
FROM STARSIN RIGHT JOIN MOVIESTAR --за да изведем и актьори, които не са участвали в нито един филм
	ON NAME = STARNAME
GROUP BY NAME

--Напишете заявка, която за всяко студио извежда име на студиото и заглавие
--на филма, излязъл последно на екран за това студио.

SELECT STUDIONAME, TITLE, YEAR
FROM MOVIE AS T1
WHERE YEAR >= ALL (SELECT YEAR
		   FROM MOVIE
	           WHERE STUDIONAME = T1.STUDIONAME)

-- Напишете заявка, която извежда името на най-младия актьор (мъж).

SELECT NAME
FROM MOVIESTAR
WHERE GENDER = 'M' AND BIRTHDATE >= ALL (SELECT BIRTHDATE
					 FROM MOVIESTAR
					 WHERE GENDER = 'M') --тук също специфицираме пол, защото може да има жена по-голяма от мъж във външната заявка

--Напишете заявка, която извежда име на актьор и име на студио за тези
--актьори, участвали в най-много филми на това студио.


SELECT STUDIONAME, STARNAME, COUNT(TITLE) AS NUM_MOVIES
FROM MOVIE JOIN STARSIN
	ON TITLE = MOVIETITLE
GROUP BY STUDIONAME, STARNAME
HAVING COUNT(TITLE) = ( SELECT MAX(NUM_MOVIES)
			FROM (SELECT STUDIONAME, STARNAME, COUNT(TITLE) AS NUM_MOVIES
			      FROM MOVIE JOIN STARSIN
				  ON TITLE = MOVIETITLE
			      GROUP BY STUDIONAME, STARNAME) AS T1
			WHERE T1.STUDIONAME = MOVIE.STUDIONAME --нужно, за да специфицираме макса на всяко студио по отделно
			);

--Напишете заявка, която извежда заглавие и година на филма, и брой на
--актьорите, участвали в този филм за тези филми с повече от двама актьори.

SELECT MOVIETITLE, MOVIEYEAR, COUNT(STARNAME) AS STARS_COUNT
FROM STARSIN
GROUP BY MOVIETITLE, MOVIEYEAR
HAVING COUNT(STARNAME) = (SELECT STARS_COUNT --извеждаме колко актьора има във филм от външната заявка, като взимаме тези по-големи от 2
			  FROM (SELECT MOVIETITLE, MOVIEYEAR, COUNT(STARNAME) AS STARS_COUNT
				FROM STARSIN
				GROUP BY MOVIETITLE, MOVIEYEAR) AS T1
			  WHERE T1.MOVIETITLE = STARSIN.MOVIETITLE AND STARS_COUNT > 2)
--ако групата (филма) има брой актьори равен на тези от подзавката (тоест намереният брой по-големи от 2 като знаем, че става въпрос за един и същи филм)
--извеждаме резултат
