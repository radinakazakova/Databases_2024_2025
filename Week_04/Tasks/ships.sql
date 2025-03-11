--Напишете заявка, която извежда цялата налична информация за всеки
--кораб, включително и данните за неговия клас. В резултата не трябва да
--се включват тези класове, които нямат кораби.

SELECT *
FROM SHIPS JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS

--Повторете горната заявка, като този път включите в резултата и класовете,
--които нямат кораби, но съществуват кораби със същото име като тяхното.

SELECT *
FROM SHIPS RIGHT JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS
ORDER BY SHIPS.NAME

--За всяка страна изведете имената на корабите, които никога не са
--участвали в битка.

SELECT COUNTRY, SHIPS.NAME
FROM SHIPS LEFT JOIN OUTCOMES
	ON SHIPS.NAME = OUTCOMES.SHIP
	JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS
WHERE BATTLE IS NULL
ORDER BY COUNTRY

--Намерете имената на всички кораби с поне 7 оръдия, пуснати на вода през
--1916, но наречете резултатната колона Ship Name.

SELECT SHIPS.NAME AS SHIP_NAME
FROM SHIPS JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS
WHERE LAUNCHED = '1916' AND NUMGUNS >= 7

--Изведете имената на всички потънали в битка кораби, името и дата на
--провеждане на битките, в които те са потънали. Подредете резултата по
--име на битката.

SELECT SHIPS.NAME, BATTLE, DATE
FROM SHIPS JOIN OUTCOMES
	ON SHIPS.NAME = OUTCOMES.SHIP
	JOIN BATTLES
	ON BATTLES.NAME = OUTCOMES.BATTLE
WHERE RESULT = 'sunk'

--Намерете името, водоизместимостта и годината на пускане на вода на
--всички кораби, които имат същото име като техния клас.

SELECT SHIPS.NAME, DISPLACEMENT, LAUNCHED
FROM SHIPS JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS
WHERE SHIPS.NAME = CLASSES.CLASS

--Намерете всички класове кораби, от които няма пуснат на вода нито един
--кораб.

SELECT CLASSES.CLASS, TYPE, COUNTRY, NUMGUNS, BORE, DISPLACEMENT
FROM CLASSES LEFT JOIN SHIPS
	ON CLASSES.CLASS = SHIPS.CLASS
WHERE LAUNCHED IS NULL

--Изведете името, водоизместимостта и броя оръдия на корабите,
--участвали в битката ‘North Atlantic’, а също и резултата от битката.

SELECT SHIPS.NAME, DISPLACEMENT, NUMGUNS, RESULT
FROM SHIPS JOIN OUTCOMES
	ON SHIPS.NAME = OUTCOMES.SHIP
	JOIN BATTLES
	ON BATTLES.NAME = OUTCOMES.BATTLE
	JOIN CLASSES
	ON SHIPS.CLASS = CLASSES.CLASS
WHERE BATTLE = 'North Atlantic'
