--Напишете заявка, която извежда производителя и честотата на лаптопите с
--размер на диска поне 9 GB

SELECT MAKER, SPEED
FROM LAPTOP JOIN PRODUCT
	ON LAPTOP.MODEL=PRODUCT.MODEL
WHERE HD>=9

--Напишете заявка, която извежда модел и цена на продуктите, произведени от
--производител с име B.

SELECT PRODUCT.MODEL, PRICE
FROM PRODUCT JOIN LAPTOP
	ON PRODUCT.MODEL=LAPTOP.MODEL
WHERE MAKER='B'

UNION

SELECT PRODUCT.MODEL, PRICE
FROM PRODUCT JOIN PC
	ON PRODUCT.MODEL=PC.MODEL
WHERE MAKER='B'

UNION

SELECT PRODUCT.MODEL, PRICE
FROM PRODUCT JOIN PRINTER
	ON PRODUCT.MODEL=PRINTER.MODEL
WHERE MAKER='B';

--Напишете заявка, която извежда производителите, които произвеждат лаптопи,
--но не произвеждат персонални компютри.

SELECT DISTINCT MAKER
FROM PRODUCT
WHERE TYPE='Laptop'

EXCEPT

SELECT DISTINCT MAKER
FROM PRODUCT
WHERE TYPE='PC'

--Напишете заявка, която извежда размерите на тези дискове, които се предлагат
--в поне два различни персонални компютъра (два компютъра с различен код).

SELECT DISTINCT PC1.HD
FROM PC AS PC1 JOIN PC AS PC2
	ON PC1.CODE != PC2.CODE
WHERE PC1.HD=PC2.HD

--Напишете заявка, която извежда двойките модели на персонални компютри,
--които имат еднаква честота и памет. Двойките трябва да се показват само по
--веднъж, например само (i, j), но не и (j, i).

SELECT PC1.MODEL, PC2.MODEL
FROM PC AS PC1 JOIN PC AS PC2
	ON PC1.MODEL != PC2.MODEL
WHERE PC1.SPEED = PC2.SPEED AND PC1.RAM = PC2.RAM AND PC1.CODE < PC2.CODE

--Напишете заявка, която извежда производителите на поне два различни
--персонални компютъра с честота поне 400.

SELECT DISTINCT P1.MAKER
FROM PRODUCT P1 
JOIN PC AS PC1
	ON P1.MODEL = PC1.MODEL
JOIN PRODUCT P2 
	ON P1.MAKER = P2.MAKER
JOIN PC PC2
	ON P2.MODEL = PC2.MODEL AND PC2.CODE != PC1.CODE
WHERE PC1.SPEED >= 400 AND PC2.SPEED >= 400

