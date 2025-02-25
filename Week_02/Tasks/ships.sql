--Напишете заявка, която извежда името на корабите с водоизместимост над
--50000.

SELECT NAME
FROM CLASSES JOIN SHIPS
	ON CLASSES.CLASS = SHIPS.CLASS
WHERE DISPLACEMENT > 50000

--Напишете заявка, която извежда имената, водоизместимостта и броя оръдия на
--всички кораби, участвали в битката при Guadalcanal.

SELECT NAME, DISPLACEMENT, NUMGUNS
FROM CLASSES JOIN SHIPS
	ON CLASSES.CLASS = SHIPS.CLASS
JOIN OUTCOMES
	ON OUTCOMES.SHIP = SHIPS.NAME
WHERE OUTCOMES.BATTLE = 'Guadalcanal'

--Напишете заявка, която извежда имената на тези държави, които имат както
--бойни кораби, така и бойни крайцери.

SELECT DISTINCT C1.COUNTRY
FROM CLASSES AS C1 JOIN CLASSES AS C2
	ON C1.COUNTRY = C2.COUNTRY AND C1.CLASS != C2.CLASS
WHERE C1.TYPE != C2.TYPE

--Напишете заявка, която извежда имената на тези кораби, които са били
--повредени в една битка, но по-късно са участвали в друга битка.

SELECT S1.NAME
FROM SHIPS AS S1 JOIN OUTCOMES AS O1
	ON S1.NAME = O1.SHIP AND O1.RESULT='damaged'
JOIN BATTLES AS B1
	ON O1.BATTLE = B1.NAME
JOIN OUTCOMES AS O2
	ON O2.SHIP = S1.NAME AND O2.BATTLE != O1.BATTLE
JOIN BATTLES AS B2
	ON O2.BATTLE = B2.NAME AND B2.DATE > B1.DATE
