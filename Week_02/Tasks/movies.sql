--Напишете заявка, която извежда имената на актьорите мъже, участвали във
--филма The Usual Suspects

SELECT NAME
FROM MOVIESTAR
WHERE GENDER='M'

INTERSECT

SELECT STARNAME
FROM STARSIN
WHERE MOVIETITLE='The Usual Suspects';

--Напишете заявка, която извежда имената на актьорите, участвали във филми от
--1995, продуцирани от студио MGM

SELECT STARNAME
FROM MOVIE JOIN STARSIN
	ON MOVIETITLE=TITLE
WHERE YEAR=1995 AND STUDIONAME='MGM'

--Напишете заявка, която извежда имената на продуцентите, които са
--продуцирали филми на студио MGM.

SELECT DISTINCT NAME
FROM MOVIE JOIN MOVIEEXEC
	ON PRODUCERC#=CERT#
WHERE STUDIONAME='MGM'

--Напишете заявка, която извежда имената на филми с дължина, по-голяма от
--дължината на филма Star Wars.

SELECT M1.TITLE
FROM MOVIE AS M1, MOVIE AS M2
WHERE M2.TITLE='Star Wars'AND M1.LENGTH>M2.LENGTH

--Напишете заявка, която извежда имената на продуцентите
--с нетни активи поголеми от тези на Stephen Spielberg.

SELECT ME1.NAME
FROM MOVIEEXEC AS ME1, MOVIEEXEC AS ME2
WHERE ME2.NAME ='Stephen Spielberg' AND ME1.NETWORTH>ME2.NETWORTH
