--Съставете изгледи, съдържащи имената на битките, които са по-мащабни от битката при
--Guadalcanal. Под по-мащабна битка се разбира:
--a) битка с повече участващи кораби;
--b) битка с повече участващи страни.
--Като използвате изгледите, напишете заявки, които извеждат съответните битки.

CREATE VIEW more_ships_than_guadalcanal(battle)
AS
SELECT B.NAME
FROM BATTLES B JOIN OUTCOMES O
ON B.NAME = O.BATTLE
GROUP BY B.NAME
HAVING COUNT(DISTINCT SHIP) > (SELECT COUNT(DISTINCT O2.SHIP)
					  FROM BATTLES B2 JOIN OUTCOMES O2
					  ON B2.NAME = O2.BATTLE
					  WHERE B2.NAME = 'Guadalcanal'
					  GROUP BY B2.NAME);

CREATE VIEW more_countries_than_guadalcanal(battle)
AS
SELECT B.NAME
FROM BATTLES B
JOIN OUTCOMES O ON B.NAME = O.BATTLE
JOIN SHIPS S ON O.SHIP = S.NAME
JOIN CLASSES C ON S.CLASS = C.CLASS
GROUP BY B.NAME
HAVING COUNT(DISTINCT C.COUNTRY) > (
    SELECT COUNT(DISTINCT C2.COUNTRY)
    FROM BATTLES B2
    JOIN OUTCOMES O2 ON B2.NAME = O2.BATTLE
    JOIN SHIPS S2 ON O2.SHIP = S2.NAME
    JOIN CLASSES C2 ON S2.CLASS = C2.CLASS
    WHERE B2.NAME = 'Guadalcanal'
	GROUP BY B2.NAME
);


--Изтрийте от таблицата Outcomes всички битки, 
--в които е участвал един единствен кораб.


DELETE FROM OUTCOMES
WHERE BATTLE IN (SELECT DISTINCT BATTLE
				FROM OUTCOMES JOIN SHIPS
				ON OUTCOMES.SHIP = SHIPS.NAME
				GROUP BY BATTLE
				HAVING COUNT(DISTINCT SHIP) = 1)

--Изтрийте от таблицата Outcomes всички записи, в които участва кораб, потапян поне два
--пъти и резултатът от съответната битка е 'sunk'.
--Забележка: Преди това може да вмъкнете следните кортежи, за да проверите по-лесно как работи
--написаната заявка.

INSERT INTO outcomes VALUES ('Missouri','Surigao Strait', 'sunk'),
('Missouri','North Cape', 'sunk'),
('Missouri','North Atlantic', 'ok');

DELETE FROM OUTCOMES
WHERE SHIP IN ( SELECT SHIP
				FROM OUTCOMES
				WHERE RESULT = 'sunk'
				GROUP BY SHIP
				HAVING COUNT(*) >= 2)
AND RESULT = 'sunk';

--Изведете всички битки, в които са участвали същите страни, като страните в битката при
--Guadalcanal.
--Възможен вариант за решаване: Създайте изглед, съдържащ всички битки и участващите в тях
--страни. След това напишете заявка, като използвате и изгледа.

CREATE VIEW battle_countries(battle, country)
AS
SELECT BATTLE, COUNTRY
FROM CLASSES C JOIN SHIPS S
ON C.CLASS = S.CLASS
JOIN OUTCOMES O
ON O.SHIP = S.NAME

SELECT battle
FROM battle_countries
GROUP BY battle
HAVING COUNT(DISTINCT country) = (
        SELECT COUNT(DISTINCT country)
        FROM battle_countries
        WHERE battle = 'Guadalcanal'
    )
    AND
    MIN(country) IN (
        SELECT country
        FROM battle_countries
        WHERE battle = 'Guadalcanal'
    )
    AND
    MAX(country) IN (
        SELECT country
        FROM battle_countries
        WHERE battle = 'Guadalcanal') 
		
	AND battle != 'Guadalcanal';


--Намерете всяка страна в колко битки е участвала.
--Забележка: Ако страната не е участвала в нито една битка (защото (а) няма кораби или (б) има
--кораби, но те не са участвали в битка), то трябва да се покаже в резултата с брой кораби 0.

SELECT COUNTRY, COUNT(BATTLE) AS num_battles
FROM CLASSES C LEFT JOIN SHIPS S
ON C.CLASS = S.CLASS
LEFT JOIN OUTCOMES O
ON S.NAME = O.SHIP
GROUP BY COUNTRY
