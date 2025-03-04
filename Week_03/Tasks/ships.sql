--Напишете заявка, която извежда страните, чиито кораби са с най-голям
--брой оръдия.

SELECT DISTINCT COUNTRY
FROM CLASSES
WHERE NUMGUNS >= ALL (SELECT NUMGUNS
					  FROM CLASSES)

--Напишете заявка, която извежда класовете, за които поне един от
--корабите е потънал в битка.

SELECT DISTINCT CLASSES.CLASS
FROM CLASSES JOIN SHIPS --свързваме всеки кораб с класът му
	ON CLASSES.CLASS = SHIPS.CLASS 
WHERE NAME IN (SELECT SHIP
				FROM OUTCOMES
				WHERE RESULT = 'sunk') --всички, които са потънали

--Напишете заявка, която извежда името и класа на корабите с 16 инчови оръдия.

SELECT NAME, CLASSES.CLASS
FROM CLASSES JOIN (SELECT CLASS, NAME
					FROM SHIPS) AS SHIP
	ON CLASSES.CLASS = SHIP.CLASS
WHERE BORE = 16

--Напишете заявка, която извежда имената на битките, в които са
--участвали кораби от клас ‘Kongo’.

SELECT BATTLE
FROM BATTLES JOIN ( SELECT SHIP, BATTLE, CLASS
					FROM OUTCOMES JOIN (SELECT CLASS, NAME
										FROM SHIPS) AS SHIP2
						ON SHIP2.NAME = OUTCOMES.SHIP) AS SHIP_IN_BATTLE
	 ON BATTLES.NAME = SHIP_IN_BATTLE.BATTLE
WHERE CLASS = 'Kongo'

--Напишете заявка, която извежда класа и името на корабите, чиито брой
--оръдия е по-голям или равен на този на корабите със същия калибър оръдия.

SELECT CLASS, NAME
FROM SHIPS
WHERE CLASS IN ( SELECT CLASS
				 FROM CLASSES AS CL
				 WHERE CL.NUMGUNS >= ALL(SELECT NUMGUNS
										 FROM CLASSES
										 WHERE CLASSES.BORE = CL.BORE)
				)
ORDER BY CLASS --само заради подредбата в отговора на задачата
