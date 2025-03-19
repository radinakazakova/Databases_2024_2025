--Напишете заявка, която извежда средната честота на персоналните компютри
--CONVERT(DECIMAL(PRECISION, SCALE) (18,0) ПО DEFAULT (SCALE СИМВОЛИ СЛЕД ДЕСЕТИЧНАТА ЗАПЕТАЯ, А ПЪРВОТО Е ЗА ОБЩО СИМВОЛИ)
SELECT CONVERT(DECIMAL(9,2), AVG(SPEED)) AS AvgSpeed
FROM PC

--Напишете заявка, която извежда средния размер на екраните на лаптопите за
--всеки производител.

SELECT MAKER, AVG(SCREEN) AS avg_screen_size
FROM LAPTOP JOIN PRODUCT
	ON LAPTOP.MODEL = PRODUCT.MODEL
GROUP BY MAKER

--Напишете заявка, която извежда средната честота на лаптопите с цена над 1000.

SELECT CONVERT(DECIMAL(9,2), AVG(SPEED)) AS avg_speed
FROM LAPTOP
WHERE PRICE > 1000

--Напишете заявка, която извежда средната цена на персоналните компютри,
--произведени от производител ‘A’

SELECT MAKER, CONVERT(DECIMAL(9,2),AVG(PRICE)) AS avg_price
FROM PC JOIN PRODUCT
	ON PC.MODEL = PRODUCT.MODEL
WHERE PRODUCT.MAKER = 'A'
GROUP BY MAKER --МОЖЕ И БЕЗ ГРУПИРАНЕ МИСЛЯ

--Напишете заявка, която извежда средната цена на персоналните компютри и
--лаптопите за производител ‘B’.

SELECT T1.MAKER, CONVERT(DECIMAL(9,1), AVG(T1.PRICE)) AS avg_price
FROM (

SELECT MAKER, PRICE
FROM PRODUCT JOIN LAPTOP
	ON PRODUCT.MODEL = LAPTOP.MODEL
WHERE MAKER = 'B'

UNION

SELECT MAKER, PRICE
FROM PRODUCT JOIN PC
	ON PRODUCT.MODEL = PC.MODEL
WHERE MAKER = 'B' ) AS T1

GROUP BY T1.MAKER

--Напишете заявка, която извежда средната цена на персоналните компютри
--според различните им честоти.

SELECT SPEED, CONVERT(DECIMAL(9,1),AVG(PRICE)) AS avg_price
FROM PC
GROUP BY SPEED

--Напишете заявка, която извежда производителите, които са произвели поне 3
--различни персонални компютъра (с различен код).

SELECT MAKER, COUNT(*) AS number_of_pc
FROM PRODUCT JOIN PC
	ON PRODUCT.MODEL = PC.MODEL
GROUP BY MAKER
HAVING COUNT(*) >= 3

--Напишете заявка, която извежда производителите с най-висока цена на персонален компютър.

SELECT MAKER, PRICE
FROM PRODUCT JOIN PC
	ON PRODUCT.MODEL = PC.MODEL
WHERE PRICE >= ALL (SELECT PRICE
					FROM PC)

--Напишете заявка, която извежда средната цена на персоналните компютри за
--всяка честота по-голяма от 800.

SELECT SPEED, AVG(PRICE) AS avg_price
FROM PC
WHERE SPEED > 800
GROUP BY SPEED

--Напишете заявка, която извежда средния размер на диска на тези персонални
--компютри, произведени от производители, които произвеждат и принтери.
--Резултатът да се изведе за всеки отделен производител.

SELECT MAKER, CONVERT(DECIMAL(9,2),AVG(HD)) AS avg_hdd
FROM PRODUCT JOIN PC
	ON PRODUCT.MODEL = PC.MODEL
WHERE MAKER IN (SELECT MAKER
				FROM PRODUCT JOIN PRINTER
					ON PRODUCT.MODEL = PRINTER.MODEL)
GROUP BY MAKER


