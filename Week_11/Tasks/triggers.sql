----Добавете нова колона num_pass към таблицата Flights, която ще съдържа броя на
----пътниците, потвърдили резервация за съответния полет.

ALTER TABLE FLIGHTS
ADD num_pass INT NOT NULL DEFAULT 0;

----Добавете нова колона num_book към таблицата Agencies, която ще съдържа броя на
----резервациите към съответната агенция

ALTER TABLE AGENCIES
ADD num_book INT NOT NULL DEFAULT 0;

----. Създайте тригер за таблицата Bookings, който да се задейства при вмъкване на
----резервация в таблицата и да увеличава с единица броя на пътниците, потвърдили
----резервация за таблицата Flights, както и броя на резервациите към съответната агенция.


CREATE TRIGGER confirmation_update
ON BOOKINGS
AFTER INSERT
AS
BEGIN
    UPDATE F
    SET F.num_pass = F.num_pass + I.cnt
    FROM FLIGHTS F
    JOIN (
        SELECT FLIGHT_NUMBER, COUNT(*) AS cnt
        FROM INSERTED
        GROUP BY FLIGHT_NUMBER
    ) I ON F.FNUMBER = I.FLIGHT_NUMBER;

	UPDATE A
	SET A.num_book = A.num_book + I.cnt
	FROM AGENCIES A
	JOIN (SELECT AGENCY, COUNT(*) AS cnt
		  FROM INSERTED
		  GROUP BY AGENCY) I ON A.NAME = I.AGENCY
END;

----Създайте тригер за таблицата Bookings, който да се задейства при изтриване на
----резервация в таблицата и да намалява с единица броя на пътниците, потвърдили
----резервация за таблицата Flights, както и броя на резервациите към съответната агенция.

CREATE TRIGGER pass_update
ON BOOKINGS
AFTER DELETE
AS
BEGIN
	UPDATE F
	SET F.num_pass = F.num_pass - I.removed
	FROM FLIGHTS F
	JOIN (SELECT FLIGHT_NUMBER, COUNT(*) AS removed
		  FROM DELETED
		  GROUP BY FLIGHT_NUMBER) I ON F.FNUMBER = I.FLIGHT_NUMBER

	UPDATE A
	SET A.num_book = A.num_book - D.removed
	FROM AGENCIES A
	JOIN (SELECT AGENCY, COUNT(*) AS removed
		  FROM DELETED
		  GROUP BY AGENCY) D ON A.NAME = D.AGENCY
END;

----Създайте тригер за таблицата Bookings, който да се задейства при обновяване на
----резервация в таблицата и да увеличава или намалява с единица броя на пътниците,
----потвърдили резервация за таблицата Flights при промяна на статуса на резервацията

CREATE TRIGGER status_update
ON BOOKINGS
AFTER UPDATE
AS 
BEGIN
	UPDATE F
	SET F.num_pass = F.num_pass + INCREASED.cnt
	FROM FLIGHTS F JOIN
	(SELECT I.FLIGHT_NUMBER, count(*) as cnt
	FROM INSERTED I JOIN DELETED D
	ON D.CODE = I.CODE
	WHERE I.STATUS = 1 AND D.STATUS = 0
	GROUP BY I.FLIGHT_NUMBER) INCREASED
	ON F.FNUMBER = INCREASED.FLIGHT_NUMBER

	UPDATE F
	SET F.num_pass = F.num_pass - DELETED.cnt
	FROM FLIGHTS F JOIN (
			SELECT D.FLIGHT_NUMBER, COUNT(*) AS cnt
			FROM INSERTED I
			JOIN DELETED D 
			ON I.CODE = D.CODE
			WHERE D.STATUS = 1 AND I.STATUS = 0
			GROUP BY D.FLIGHT_NUMBER
		) DELETED ON F.FNUMBER = DELETED.FLIGHT_NUMBER;

END;
