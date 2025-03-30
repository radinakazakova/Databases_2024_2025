### Description of the databases [here](<../Week_01/movie_pc_ships.pdf/>)

### Scripts of the databases [here](<../Week_01/Scripts/>)

# Упражениние 3 - Подзаявки

#### Типове
- Проста - независима от главната (външната) заявка, изпълнява се веднъж
- Корелативна - зависимост от главната заявка
- inline изгледи - зависи от клаузата from (таблици създадени във from, съществуват само по време на изпълнение на заявката)

*Пример за употреба на подзаявка:*
```sql
SELECT NAME
FROM MOVIE JOIN MOVIEEXEC
  ON PRODCERT = CERT
WHERE TITLE = 'Star Wars'
```

Можем да го пренапишем чрез подзаявка от ON клаузата

```sql
SELECT NAME
FROM MOVIEEXEC
WHERE CERT = ( SELECT PRODCERT
                FROM MOVIE
                WHERE TITLE = 'Star Wars' )
```

`=` очаква 1 ред като резултат

##### За множество от кортежи като резултат от подзаявка използваме:
- оператор **IN** - връща булева стойност
- BETWEEN
- LIKE - сравнение на символни низове

Нека s e скалар, нека R е унарна релация

- (NOT) `EXIST R` - ако в R има кортежи връща `true`
- (NOT) `s > ALL R` - aкo s е по-голямо от всички кортежи на R, връща `true`
- (NOT) `s > ANY R` - ако s е по-голямо от поне една стойност в R
- `s <> ALL R` или `s NOT IN R` - s различно от всички стойности в R 
- `s = ANY R` или `s IN R` - s е в R (един вид взимат се тези кортежи, за които s съвпада)
- 

*Пример, при който търсим най-висока дадена стойност от множеството дадени стойности в таблицата:*
```sql
SELECT NAME, NETWORTH
FROM MOVIEEXEC
WHERE NETWORTH >= ALL ( SELECT NETWORTH
                        FROM MOVIEEXEC );
```

Използваме >= ALL, за да изкараме всички срещания на най-високата стойност в случая networth

Друг вариант е да използваме TOP1 с ORDER BY
```sql
SELECT TOP 1 NAME, NETWORTH
FROM MOVIEEXEC
ORDER BY NETWORTH DESC;
```
Проблем при `ТОР 1` със сортиране при равни стойности - ще получим само една от най-високите стойности, а не всички

#### Пример за корелативна подзаявка
```sql
SELECT *
FROM STARSIN
WHERE EXIST ( SELECT NAME
              FROM MOVIESTAR
              WHERE BIRTHDATE LIKE '%1960%'
                    AND NAME = STARNAME);
```
**Таблицата, направена във FROM, трябва да и се зададе име**

Използваме EXIST, защото е достатъчно да съвпада 1 име и ще върне `true`

Подзаявката се изпълнява толкова пъти, колкото приема име от `starsin`

#### Пример за inline 

```sql
SELECT NAME
FROM MOVIEEXEC JOIN ( SELECT PRODCERT#
                      FROM MOVIE JOIN STARSIN
                          ON TITLE = MOVIETITLE
                          AND YEAR = MOVIEYEAR
                      WHERE STARNAME = 'Harrison Ford') --проста подзаявка
                      AS PROD
    ON MOVIEEXEC.CERT = PROD.PRODCERT;
```
Забелязваме, че няма главна заявка

#### Подзаявка в SELECT

```sql
SELECT TITLE, LENGTH, (SELECT TOP 1 LENGTH
                        FROM MOVIE
                        ORDER BY LENGTH DESC) - LENGTH AS DIFFLL --дължината на всеки филм сравняваме с дължината на най-дългия филм
FROM MOVIE;
```
