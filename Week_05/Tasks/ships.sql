--Напишете заявка, която извежда броя на класовете бойни кораби.

SELECT COUNT(*) AS NO_classes
FROM CLASSES
WHERE TYPE='bb'

--Напишете заявка, която извежда средния брой оръдия за всеки клас боен кораб.

SELECT CLASS, AVG(NUMGUNS) AS avg_guns
FROM CLASSES
WHERE TYPE='bb'
GROUP BY CLASS

--Напишете заявка, която извежда средния брой оръдия за всички бойни кораби.

SELECT AVG(NUMGUNS) AS avg_guns
FROM CLASSES
WHERE TYPE='bb'
	
--Напишете заявка, която извежда за всеки клас първата и последната година, в
--която кораб от съответния клас е пуснат на вода.

SELECT CLASSES.CLASS, MIN(LAUNCHED) AS first_year, MAX(LAUNCHED) AS last_year
FROM CLASSES JOIN SHIPS
	ON CLASSES.CLASS = SHIPS.CLASS
GROUP BY CLASSES.CLASS

--Напишете заявка, която извежда броя на корабите, потънали в битка според класа.

SELECT CLASS, COUNT(*) AS sunk_ships
FROM OUTCOMES JOIN SHIPS
	ON OUTCOMES.SHIP = SHIPS.NAME
WHERE RESULT='sunk'
GROUP BY CLASS

--Напишете заявка, която извежда средния калибър на оръдията на корабите за
--всяка страна.

SELECT COUNTRY, CONVERT(DECIMAL(9,2),AVG(BORE)) AS avg_bore	
FROM CLASSES
GROUP BY COUNTRY
