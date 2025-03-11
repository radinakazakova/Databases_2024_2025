--Напишете заявка, която извежда производител, модел и тип на продукт за
--тези производители, за които съответният продукт не се продава (няма го
--в таблиците PC, Laptop или Printer).

SELECT MAKER, PRODUCT.MODEL, TYPE
FROM PRODUCT LEFT JOIN PC
	ON PRODUCT.MODEL = PC.MODEL
WHERE TYPE = 'PC' AND CODE IS NULL

UNION

SELECT MAKER, PRODUCT.MODEL, TYPE
FROM PRODUCT LEFT JOIN LAPTOP
	ON PRODUCT.MODEL = LAPTOP.MODEL
WHERE TYPE = 'Laptop' AND CODE IS NULL

UNION

SELECT MAKER, PRODUCT.MODEL, PRODUCT.TYPE
FROM PRODUCT LEFT JOIN PRINTER
	ON PRODUCT.MODEL = PRINTER.MODEL
WHERE PRODUCT.TYPE = 'Printer' AND CODE IS NULL

--Намерете всички производители, които правят както лаптопи, така и
--принтери.

SELECT DISTINCT MAKER
FROM PRODUCT JOIN LAPTOP
	ON PRODUCT.MODEL = LAPTOP.MODEL

INTERSECT

SELECT DISTINCT MAKER
FROM PRODUCT JOIN PRINTER
	ON PRODUCT.MODEL = PRINTER.MODEL

--Намерете размерите на тези твърди дискове, които се появяват в два или
--повече модела лаптопи.

SELECT DISTINCT LAPTOP.HD
FROM LAPTOP JOIN LAPTOP AS L2
	ON LAPTOP.CODE != L2.CODE AND LAPTOP.HD = L2.HD

--Намерете всички модели персонални компютри, които нямат регистриран
--производител.

SELECT *
FROM PC LEFT JOIN PRODUCT
	ON PC.MODEL = PRODUCT.MODEL
WHERE TYPE = 'PC' AND MAKER IS NULL
