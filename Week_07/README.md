

# Упражнение 7 - Модификации на данните

## Добавяне на кортежи

```sql
INSERT (INTO) <table name>
(column1 name, column2 name, ...)
VALUES (<value1, value2, ...>);
```

Ключовата дума INTO не е задължителна. Може да се използват резултатите от други заявки като VALUES. Тоест:

```sql
INSERT INTO (column1, column2, ...) <subquery>;
```

Ако не посочим даден атрибут, наличен в таблицата (и съответно стойност за него), неговата стойност ще бъде NULL.

#### *Примери*

В starsin да добавим информация за Anne Hathaway

```sql
INSERT INTO STARSIN
(STARNAME, MOVIETITLE, MOVIEYEAR)
VALUES ('Anne Hathaway', 'Interstellar', 2014);
```

Ако наредбата на атрибутите в таблицата е: movietitle, movieyear, starname, то заявката ще даде грешка, тъй като очаква за втори атрибут число, а не стринг

Нека имаме релацията MyProduct(maker, model, type)

```sql
INSERT INTO MyProduct (MAKER, MODEL)
VALUES ('HP', 'HP Omnistudio'),
        ('HP', 'HP Omnistudio', DEFAULT);
```
(Това е синтаксисът за добавяне на няколко кортежа)

По подразбиране model e pc, тогава ако добавяме персонален компютър можем да пропуснем column model или можем да окажем да е default.
Ако няма задаена default стойност, тогава ще приеме null. Ако не можеше да приема null, няма default стойност и не му зададем стойност - ще излезе грешка.

```sql
INSERT INTO MyProduct
DEFAULT VALUES;
```

Ако се намираме в същата ситуация като по-горе, ще се добави кортежа: null, null, 'pc'

#### Добавяне чрез подзаявка

Имаме релацията MyProduct(MODEL, MAKER, TYPE)

```sql
INSERT INTO MyProduct
SELECT MODEL, MAKER, TYPE
FROM PRODUCT
WHERE TYPE='pc';
```
Ако в подзаявката изпуснем type, в таблицата ще приеме default стойност

## Промяна на стойностите

```sql
UPDATE <table name>
SET <column name>=<expression>, ...
WHERE <condition>
```
Ако заявката има where клауза (не е задължителна), то се проверява първо дали кортежа отговаря на условието, после модифицира. Expression може да приема и стойности null или default.

#### *Примери*

Да се намали с 10% цената на лаптопите с размер на диска под 200

```sql
UPDATE LAPTOP
SET PRICE=PRICE * 0.9
WHERE HD < 200;
```

```sql
UPDATE LAPTOP
SET SPEED=(SELECT TOP 1 SPEED FROM LAPTOP ORDER BY SPEED DESC),
    HD=ROM/2,
    PRICE=DEFAULT;
```

Грешно е да се повтаря атрибут повече от веднъж при set.

## Изтриване на кортежи

```sql
DELETE (FROM) <table name>
WHERE <condition>
```

Ако няма where клауза, ще изтрие всички кортежи в дадената таблица.
