-- Напишете заявка, която извежда производителите на персонални
--компютри с честота над 500.

SELECT DISTINCT MAKER
FROM PRODUCT
WHERE MODEL IN (SELECT MODEL
		FROM PC
		WHERE SPEED > 500);

--Напишете заявка, която извежда код, модел и цена на принтерите с най-висока цена.

SELECT CODE, MODEL, PRICE
FROM PRINTER
WHERE PRICE >= ALL (SELECT PRICE
		    FROM PRINTER);

--Напишете заявка, която извежда лаптопите, чиято честота е по-ниска от
--честотата на всички персонални компютри.

SELECT *
FROM LAPTOP
WHERE SPEED < ALL (SELECT SPEED
		   FROM PC);

--Напишете заявка, която извежда модела и цената на продукта (PC,
--лаптоп или принтер) с най-висока цена.

SELECT TOP 1 MODEL, PRICE
FROM ( (SELECT MODEL, PRICE
	FROM PC)
	UNION
	(SELECT MODEL, PRICE
	FROM LAPTOP)
	UNION 
	(SELECT MODEL, PRICE
	FROM PRINTER) ) AS PRODUCTS
ORDER BY PRICE DESC;

--Напишете заявка, която извежда производителя на цветния принтер с
--най-ниска цена.

SELECT TOP 1 MAKER
FROM PRODUCT JOIN PRINTER
	ON PRODUCT.MODEL = PRINTER.MODEL
WHERE COLOR = 'y'
ORDER BY PRICE ASC;

SELECT MAKER
FROM PRODUCT
WHERE PRODUCT.MODEL = (SELECT TOP 1 MODEL
		       FROM PRINTER
		       WHERE COLOR = 'y'
		       ORDER BY PRICE ASC)

--Напишете заявка, която извежда производителите на тези персонални
--компютри с най-малко RAM памет, които имат най-бързи процесори

SELECT MAKER
FROM PRODUCT
WHERE PRODUCT.MODEL IN (SELECT MODEL
			FROM PC AS P
			WHERE P.SPEED IN (SELECT TOP 1 SPEED
					  FROM PC
					  WHERE RAM IN (SELECT TOP 1 RAM --взимам колко е най-малкия ram
							FROM PC
							ORDER BY RAM ASC)
						AND P.CODE = PC.CODE --външна зависимост текущото pc, "вземи speed само за текущото рс, ако то има най-малкия рам"
					  ORDER BY SPEED DESC
					 )
		       )
