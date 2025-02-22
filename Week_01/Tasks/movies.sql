---Напишете заявка, която извежда адреса на студио ‘Disney’
SELECT ADDRESS
FROM STUDIO
WHERE NAME = 'Disney'

---Напишете заявка, която извежда рождената дата на актьора Jack Nicholson
SELECT BIRTHDATE
FROM MOVIESTAR
WHERE NAME = 'Jack Nicholson'

---Напишете заявка, която извежда имената на актьорите, които са
---участвали във филм от 1980 или във филм, в чието заглавие има думата ‘Knight’
SELECT STARNAME
FROM STARSIN
WHERE MOVIEYEAR=1980 OR MOVIETITLE LIKE '%Knight%'

---Напишете заявка, която извежда имената на продуцентите с нетни
---активи над 10 000 000 долара
SELECT NAME
FROM MOVIEEXEC
WHERE NETWORTH > 10000000

---Напишете заявка, която извежда имената на актьорите, които са мъже
---или живеят на Prefect Rd.
SELECT NAME
FROM MOVIESTAR
WHERE GENDER LIKE 'M' OR ADDRESS LIKE 'Prefect Rd.'
