--Напишете заявка, която извежда името на продуцента и имената на
--филмите, продуцирани от продуцента на филма ‘Star Wars’.

SELECT TITLE, NAME
FROM MOVIE JOIN MOVIEEXEC
	ON PRODUCERC# = CERT#
WHERE PRODUCERC# = (SELECT PRODUCERC#
					FROM MOVIE
					WHERE TITLE = 'Star Wars')

--Напишете заявка, която извежда имената на продуцентите на филмите, в
--които е участвал ‘Harrison Ford’

SELECT DISTINCT NAME
FROM MOVIE JOIN MOVIEEXEC
	ON PRODUCERC# = CERT# 
	JOIN STARSIN 
	ON TITLE = MOVIETITLE
WHERE STARNAME = 'Harrison Ford'

--Напишете заявка, която извежда името на студиото и имената на
--актьорите, участвали във филми, произведени от това студио, подредени
--по име на студио.

SELECT DISTINCT STUDIONAME, STARNAME
FROM STARSIN JOIN MOVIE
	ON MOVIETITLE = TITLE
ORDER BY STUDIONAME

--Напишете заявка, която извежда имената на актьорите, участвали във
--филми на продуценти с най-големи нетни активи.

SELECT STARNAME, TITLE
FROM STARSIN JOIN MOVIE
	ON MOVIETITLE = TITLE
WHERE PRODUCERC# IN (SELECT PRODUCERC#
					 FROM MOVIEEXEC JOIN MOVIE 
						ON CERT# = PRODUCERC#
					 WHERE NETWORTH >= ALL (SELECT NETWORTH
										    FROM MOVIEEXEC))
--в примерното решение са дадени тези колони
SELECT STARNAME, (SELECT NETWORTH
				  FROM MOVIEEXEC
				  WHERE NETWORTH >= ALL(SELECT NETWORTH
										FROM MOVIEEXEC)) AS NET, TITLE
FROM STARSIN JOIN MOVIE
	ON MOVIETITLE = TITLE
WHERE PRODUCERC# IN (SELECT PRODUCERC#
					 FROM MOVIEEXEC JOIN MOVIE
						ON CERT# = PRODUCERC#
					WHERE NETWORTH >= ALL (SELECT NETWORTH
										   FROM MOVIEEXEC))
--друг вариант?


--Напишете заявка, която извежда имената на актьорите, които не са
--участвали в нито един филм.

SELECT NAME, MOVIETITLE
FROM MOVIESTAR LEFT JOIN STARSIN
	ON STARNAME = NAME
WHERE MOVIETITLE IS NULL

