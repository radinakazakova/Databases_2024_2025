--Да се напише заявка, която извежда производителите както на принтери, 
--така и на лаптопи.

SELECT MAKER
FROM PRODUCT
WHERE MODEL IN (SELECT MODEL FROM PRINTER)

INTERSECT

SELECT MAKER
FROM PRODUCT
WHERE MODEL IN (SELECT MODEL FROM LAPTOP);


--Намалете с 5% цената на онези персонални компютри, които имат производители,
--такива че средната цена на продаваните от тях принтери е над 800.

UPDATE PC
SET PRICE = PRICE - 0.05 * PRICE
WHERE MODEL IN	(SELECT PC2.MODEL
				FROM PRODUCT P1 JOIN PC PC2
				ON P1.MODEL = PC2.MODEL
				WHERE P1.MAKER IN (SELECT P2.MAKER
								   FROM PRODUCT P2 JOIN PRINTER
								   ON P2.model = printer.model
								   GROUP BY P2.MAKER
								   HAVING AVG(PRINTER.price) > 800)
);

--Намерете за всеки размер на твърд диск на персонален компютър между 10 и 30 GB,
--най-ниската цена за съответния размер.

SELECT HD, MIN(PRICE) AS MIN_PRICE
FROM PC
WHERE HD IN (SELECT HD
			FROM PC
			WHERE HD >= 10 AND HD <= 30)
GROUP BY HD
