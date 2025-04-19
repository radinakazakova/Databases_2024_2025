--Задача 1
--а) Дефинирайте следните релации:
--Product (maker, model, type), където:
-- модел е низ от точно 4 символа,
-- производител е низ от точно 1 символ,
-- тип е низ до 7 символа;
-- Printer (code, model, price), където:
-- код е цяло число,
-- модел е низ от точно 4 символа,
-- цена с точност до два знака след десетичната запетая;

CREATE TABLE PRODUCT
( 
	MODEL CHAR(4),
	MAKER CHAR(1),
	TYPE VARCHAR(7)
);

CREATE TABLE PRINTER
(
	CODE INT,
	MODEL CHAR(4),
	PRICE DECIMAL(18,2)
);

--б) Добавете кортежи с примерни данни към новосъздадените релации.

INSERT INTO PRODUCT
VALUES ('1111', 'A', 'PC'),
		('1902', 'B', 'LAPTOP'),
		('2000', 'C', 'PRINTER');

INSERT INTO PRINTER
VALUES (1, '2000', 2010),
		(2, '3849', 3842),
		(3, '3244', 4382);

--в) Добавете към релацията Printer атрибути:
-- type - низ до 6 символа (забележка: type може да приема
-- стойност 'laser', 'matrix' или 'jet'),
-- color - низ от точно 1 символ, стойност по подразбиране 'n'
-- (забележка: color може да приема стойност 'y' или 'n').

ALTER TABLE PRINTER
ADD TYPE VARCHAR(6), 
	  COLOR CHAR(1) NOT NULL DEFAULT 'n';

ALTER TABLE PRINTER
DROP COLUMN PRICE;

DROP TABLE PRODUCT;

DROP TABLE PRINTER;
