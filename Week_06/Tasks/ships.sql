--Напишете заявка, която извежда имената на всички кораби без повторения,
--които са участвали в поне една битка и чиито имена започват с C или K.

SELECT DISTINCT NAME
FROM SHIPS JOIN OUTCOMES
	ON NAME = SHIP
WHERE NAME LIKE 'C%'  OR NAME LIKE 'K%'

--Напишете заявка, която извежда име и държава на всички кораби, които
--никога не са потъвали в битка (може и да не са участвали).

SELECT DISTINCT NAME, COUNTRY
FROM (SELECT SHIPS.NAME, COUNTRY
	  FROM CLASSES RIGHT JOIN SHIPS 
			ON CLASSES.CLASS = SHIPS.CLASS) AS T1 
	  LEFT JOIN OUTCOMES
		ON NAME = OUTCOMES.SHIP 
WHERE RESULT IS NULL OR RESULT != 'sunk'

--Напишете заявка, която извежда държавата и броя на потъналите кораби за
--тази държава. Държави, които нямат кораби или имат кораб, но той не е
--участвал в битка, също да бъдат изведени

SELECT COUNTRY, COUNT(DISTINCT SHIP) AS SUNK_SHIPS
FROM CLASSES
LEFT JOIN SHIPS 
	ON CLASSES.CLASS = SHIPS.CLASS
LEFT JOIN OUTCOMES
	ON NAME = SHIP
WHERE RESULT IS NULL OR RESULT = 'sunk'
GROUP BY COUNTRY

--Напишете заявка, която извежда име на битките, които са по-мащабни (с
--повече участващи кораби) от битката при Guadalcanal.

SELECT NAME
FROM BATTLES JOIN OUTCOMES
	ON NAME = BATTLE
GROUP BY NAME
HAVING COUNT(SHIP) > (SELECT COUNT(SHIP) AS SHIPS_COUNT
					  FROM BATTLES JOIN OUTCOMES
						ON NAME = BATTLE
					  WHERE NAME = 'Guadalcanal'
					  GROUP BY NAME)

--Напишете заявка, която извежда име на битките, които са по-мащабни (с
--повече участващи страни) от битката при Surigao Strait.



--Напишете заявка, която извежда имената на най-леките кораби с най-много оръдия

SELECT NAME, DISPLACEMENT, NUMGUNS
FROM CLASSES JOIN SHIPS
	ON CLASSES.CLASS = SHIPS.CLASS 
WHERE DISPLACEMENT <= ALL (SELECT DISPLACEMENT --важно е тук да имаме същото условие за най-леки кораби, защото може да има по-тежки с повече оръдия и няма да можем да определим кои са с най-много от леките
						   FROM CLASSES) 
	 AND NUMGUNS >= ALL (SELECT NUMGUNS
						 FROM CLASSES JOIN SHIPS
							ON CLASSES.CLASS = SHIPS.CLASS
						 WHERE DISPLACEMENT <= ALL (SELECT DISPLACEMENT
													FROM CLASSES))

--Изведете броя на корабите, които са били увредени в битка, но са били
--поправени и по-късно са победили в друга битка.

SELECT COUNT(SHIP) AS NUM_SHIPS
FROM BATTLES JOIN OUTCOMES AS T1
	ON NAME = BATTLE
WHERE DATE > (SELECT DATE
			  FROM BATTLES JOIN OUTCOMES
				ON NAME = BATTLE
			  WHERE OUTCOMES.SHIP = T1.SHIP AND  RESULT = 'damaged')
	 AND RESULT = 'ok'
GROUP BY SHIP

--Изведете име на корабите, които са били увредени в битка, но са били
--поправени и по-късно са победили в по-мащабна битка (с повече кораби).

SELECT DISTINCT O1.SHIP
FROM OUTCOMES AS O1
JOIN OUTCOMES AS O2
	ON O1.SHIP = O2.SHIP
JOIN (SELECT BATTLE, COUNT(SHIP) AS SHIP_COUNT --броим колко кораба има всяка битка, като свързваме с втората битка (тоест броя кораби във втората битка все едно)
	  FROM OUTCOMES
	  GROUP BY BATTLE
	  ) AS BATTLE_SIZE
	ON O2.BATTLE = BATTLE_SIZE.BATTLE
WHERE O1.RESULT = 'damaged' AND O2.RESULT = 'ok' AND BATTLE_SIZE.SHIP_COUNT > (SELECT COUNT(SHIP)
																				FROM OUTCOMES
																				WHERE BATTLE = O1.BATTLE) --броим колко кораба има в първата битка, за да изберем втората да е с повече
