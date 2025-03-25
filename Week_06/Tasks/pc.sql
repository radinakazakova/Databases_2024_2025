--Напишете заявка, която извежда всички модели лаптопи, за които се
--предлагат както разновидности с 15" екран, така и с 11" екран.

SELECT MODEL, CODE, SCREEN
FROM LAPTOP
WHERE MODEL = (SELECT MODEL
				FROM LAPTOP
				WHERE SCREEN = '15'

				INTERSECT

				SELECT MODEL
				FROM LAPTOP
				WHERE SCREEN = '11')
	AND (SCREEN = '15' OR SCREEN = '11');

--Да се изведат различните модели компютри, чиято цена е по-ниска от найевтиния лаптоп, 
--произвеждан от същия производител.

SELECT DISTINCT PC1.MODEL
FROM PC PC1 JOIN PRODUCT P1
	ON PC1.MODEL = P1.MODEL AND P1.TYPE = 'PC'
WHERE PC1.PRICE < (SELECT MIN(L1.PRICE)
				   FROM LAPTOP L1 JOIN PRODUCT P2 
						ON L1.MODEL = P2.MODEL
				   WHERE P2.MAKER = P1.MAKER) --взима тези лаптопи които са на същия производител като кортежа на pc1 и ни дава най-евтиния от тях

--Един модел компютри може да се предлага в няколко разновидности с
--различна цена. Да се изведат тези модели компютри, чиято средна цена (на
--различните му разновидности) е по-ниска от най-евтиния лаптоп, произвеждан
--от същия производител.

SELECT PC1.MODEL, AVG(PRICE) AS AVG_PRICE
FROM PC PC1 JOIN PRODUCT P1
	ON PC1.MODEL = P1.MODEL AND P1.TYPE = 'PC'
GROUP BY PC1.MODEL, MAKER --добавяме и производителя, защото ни трябва за подзаявката и няма да промени нищо, тъй като един модел компщтър се произвежда от един и същи производител
HAVING AVG(PRICE) < (SELECT MIN(L1.PRICE)
					 FROM LAPTOP L1 JOIN PRODUCT P2 
						ON L1.MODEL = P2.MODEL
					 WHERE P2.MAKER = P1.MAKER)

--Напишете заявка, която извежда за всеки компютър код на продукта,
--производител и брой компютри, които имат цена, по-голяма или равна на
--неговата.

SELECT P1.CODE, P.MAKER, (SELECT COUNT(*)
						  FROM PC P2
						  WHERE P2.PRICE >= P1.PRICE) AS NUM_HIGHER_PRICE
FROM PC P1 JOIN PRODUCT P
	ON P1.MODEL = P.MODEL
WHERE P.TYPE = 'PC'
ORDER BY P1.CODE
