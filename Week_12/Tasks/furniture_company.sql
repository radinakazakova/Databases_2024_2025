--За базата от данни FurnitureCompany
--В базата от данни FurnitureCompany се съхранява информация за компания, която произвежда мебели,
--вкл. за произвеждани продукти (таблица Product), клиенти на компанията (таблица Customer),
--направени от тях поръчки и отделни позиции по тях (таблици Order_t и Order_line).
--Задача 1. Като използвате диаграмата по-долу, създайте базата от данни FurnitureCompany и
--дефинирайте схемата на всяка релация. Добавете подходящи ограничения (PK, FK и др.).
--Забележки:
--- Customer_ID от таблицата Customer се въвежда автоматично.
--- Product_Finish от таблицата Product може да приема стойности: череша, естествен ясен, бял ясен,
--червен дъб, естествен дъб, орех.

USE master
GO
CREATE DATABASE FurnitureCompany
GO
USE FurnitureCompany
GO

CREATE TABLE PRODUCT(
	PRODUCT_ID INT NOT NULL CONSTRAINT pk_product PRIMARY KEY,
	PRODUCT_DESCRIPTION VARCHAR(256),
	PRODUCT_FINISH VARCHAR(32) CHECK(PRODUCT_FINISH = 'череша' OR PRODUCT_FINISH ='естествен ясен' OR PRODUCT_FINISH ='бял ясен' OR PRODUCT_FINISH ='червен дъб' OR PRODUCT_FINISH ='естествен дъб' OR PRODUCT_FINISH ='орех'),
	STANDART_PRICE INT,
	PRODUCT_LINE_ID INT NOT NULL
);

CREATE TABLE CUSTOMER(
	CUSTOMER_ID INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_customer PRIMARY KEY,
	CUSTOMER_NAME VARCHAR(64),
	CUSTOMER_ADDRESS VARCHAR(128),
	CUSTOMER_CITY VARCHAR(64),
	CITY_CODE CHAR(4)
);

CREATE TABLE ORDER_T(
	ORDER_ID INT NOT NULL CONSTRAINT pk_order PRIMARY KEY,
	ORDER_DATE DATE NOT NULL DEFAULT GETDATE(),
	CUSTOMER_ID INT NOT NULL REFERENCES CUSTOMER(CUSTOMER_ID)
);

CREATE TABLE ORDER_LINE(
	ORDER_ID INT NOT NULL REFERENCES ORDER_T(ORDER_ID),
	PRODUCT_ID INT NOT NULL REFERENCES PRODUCT(PRODUCT_ID),
	ORDERED_QUANTITY INT NOT NULL DEFAULT 1,
	CONSTRAINT pk_line PRIMARY KEY (ORDER_ID, PRODUCT_ID)
);

insert into CUSTOMER values
('Иван Петров', 'ул. Лавеле 8', 'София', '1000'),
('Камелия Янева', 'ул. Иван Шишман 3', 'Бургас', '8000'),
('Васил Димитров', 'ул. Абаджийска 87', 'Пловдив', '4000'),
('Ани Милева', 'бул. Владислав Варненчик 56', 'Варна','9000');

insert into PRODUCT values
(1000, 'офис бюро', 'череша', 195, 10),
(1001, 'директорско бюро', 'червен дъб', 250, 10),
(2000, 'офис стол', 'череша', 75, 20),
(2001, 'директорски стол', 'естествен дъб', 129, 20),
(3000, 'етажерка за книги', 'естествен ясен', 85, 30),
(4000, 'настолна лампа', 'естествен ясен', 35, 40);


insert into ORDER_T values
(100, '2013-01-05', 1),
(101, '2013-12-07', 2),
(102, '2014-10-03', 3),
(103, '2014-10-08', 2),
(104, '2015-10-05', 1),
(105, '2015-10-05', 4),
(106, '2015-10-06', 2),
(107, '2016-01-06', 1);

insert into ORDER_LINE values
(100, 4000, 1),
(101, 1000, 2),
(101, 2000, 2),
(102, 3000, 1),
(102, 2000, 1),
(106, 4000, 1),
(103, 4000, 1),
(104, 4000, 1),
(105, 4000, 1),
(107, 4000, 1);

--Задача 2. Напишете заявка, която извежда id и описание на продукт, както и колко пъти е бил поръчан,
--само за тези продукти, които са били поръчвани.

SELECT P.PRODUCT_ID, P.PRODUCT_DESCRIPTION, SUM(ORDERED_QUANTITY) AS TIMES_ORDERED
FROM PRODUCT P JOIN ORDER_LINE O
ON P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY P.PRODUCT_ID, P.PRODUCT_DESCRIPTION

--Напишете заявка, която извежда id и описание на продукт, както и поръчано количество, за
--всички продукти

SELECT P.PRODUCT_ID, P.PRODUCT_DESCRIPTION,  ISNULL(SUM(ORDERED_QUANTITY), 0) AS TOTAL_TIMES_ORDERED
FROM PRODUCT P LEFT JOIN ORDER_LINE O
ON P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY P.PRODUCT_ID, P.PRODUCT_DESCRIPTION

--Напишете заявка, която извежда име на клиента и обща стойност на направените от него
--поръчки, само за клиентите с поръчки.


SELECT CUSTOMER_NAME, CONVERT(DECIMAL(8,2), SUM(OL.ORDERED_QUANTITY * P.STANDART_PRICE)) AS ORDER_AMOUNT
FROM CUSTOMER C JOIN ORDER_T O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN ORDER_LINE OL
ON OL.ORDER_ID = O.ORDER_ID
JOIN PRODUCT P
ON P.PRODUCT_ID = OL.PRODUCT_ID

GROUP BY C.CUSTOMER_ID, CUSTOMER_NAME
