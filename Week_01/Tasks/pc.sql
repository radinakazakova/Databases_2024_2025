-- Напишете заявка, която извежда модел, честота и размер на диска за
-- всички персонални компютри с цена под 1200 долара. Задайте
-- псевдоними за атрибутите честота и размер на диска, съответно MHz и GB

SELECT model, speed AS MHz, hd AS GB
FROM pc
WHERE price < 1200

-- Напишете заявка, която извежда производителите на принтери без повторения
SELECT DISTINCT MAKER
FROM product
WHERE TYPE LIKE 'Printer'

-- Напишете заявка, която извежда модел, размер на паметта, размер на
-- екран за лаптопите, чиято цена е над 1000 долара
SELECT model, ram, screen
FROM laptop
WHERE price > 1000

-- Напишете заявка, която извежда всички цветни принтери
SELECT *
FROM printer
WHERE color LIKE 'y'

-- Напишете заявка, която извежда модел, честота и размер на диска за
-- тези персонални компютри със CD 12x или 16x и цена под 2000 долара.
SELECT model, speed, hd
FROM pc
WHERE cd LIKE '12x' OR cd LIKE '16x' AND price < 2000
