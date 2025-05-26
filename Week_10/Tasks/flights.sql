--Върху базата данни FLIGHTS

--Създайте изглед, който извежда име на авиокомпания оператор на полета, номер на полет
--и брой пътници, потвърдили резервация за този полет. Тествайте изгледa.

CREATE VIEW flight_info 
as
SELECT AIRLINE_OPERATOR, FNUMBER, COUNT(BOOKINGS.CUSTOMER_ID) AS PASSENGER_CNT
FROM FLIGHTS LEFT JOIN BOOKINGS
ON FLIGHTS.FNUMBER = BOOKINGS.FLIGHT_NUMBER
GROUP BY AIRLINE_OPERATOR, FNUMBER

--Създайте изглед, който за всяка агенция извежда името на клиента с най-много
--резервации. Тествайте изгледa

CREATE VIEW freq_customer
AS
SELECT CUSTOMERS.FNAME, CUSTOMERS.LNAME
FROM CUSTOMERS
WHERE ID IN (SELECT CUSTOMER_ID
				FROM BOOKINGS AS B
				GROUP BY AGENCY, CUSTOMER_ID
				HAVING COUNT(CUSTOMER_ID) >= (SELECT TOP 1 COUNT(CUSTOMER_ID)
											  FROM BOOKINGS
											  WHERE AGENCY = B.AGENCY) )

CREATE VIEW freq_customer2 
AS
SELECT CUSTOMERS.FNAME, CUSTOMERS.LNAME, ID
FROM CUSTOMERS
WHERE ID IN (SELECT CUSTOMER_ID 
	     FROM BOOKINGS as B
	     GROUP BY AGENCY, CUSTOMER_ID
	     HAVING COUNT(CUSTOMER_ID) >= (SELECT TOP 1 COUNT(CUSTOMER_ID) 
					   FROM BOOKINGS 
					   WHERE BOOKINGS.AGENCY=B.AGENCY
					   GROUP BY AGENCY, CUSTOMER_ID
					   ORDER BY COUNT(CUSTOMER_ID) DESC))
		
--Създайте изглед за таблицата Agencies, който извежда всички данни за агенциите от град
--София. Дефинирайте изгледa с CHECK OPTION. Тествайте изгледa.

CREATE VIEW sofia_agencies
AS
SELECT *
FROM AGENCIES
WHERE CITY = 'Sofia'
WITH CHECK OPTION

--Създайте изглед за таблицата Agencies, който извежда всички данни за агенциите, такива
--че телефонните номера на тези агенции да имат стойност NULL. Дефинирайте изгледa с
--CHECK OPTION. Тествайте изгледa.

CREATE VIEW no_phone_agencies
AS
SELECT *
FROM AGENCIES
WHERE PHONE IS NULL
WITH CHECK OPTION

INSERT INTO sofia_agencies
VALUES('T1 Tour', 'Bulgaria', 'Sofia','+359');
INSERT INTO no_phone_agencies
VALUES('T2 Tour', 'Bulgaria', 'Sofia',null);

INSERT INTO sofia_agencies
VALUES('T3 Tour', 'Bulgaria', 'Varna','+359'); --ne e sofia

INSERT INTO no_phone_agencies
VALUES('T4 Tour', 'Bulgaria', 'Varna',null);

INSERT INTO no_phone_agencies
VALUES('T4 Tour', 'Bulgaria', 'Sofia','+359'); --phone ne e null

--Кои от горните изгледи са updateable (т.е. върху тях могат да се изпълняват DML
--оператори)? -Последните 2 (само върху 1 таблица са)

DROP VIEW flight_info
DROP VIEW freq_customer
DROP VIEW sofia_agencies
DROP VIEW no_phone_agencies
