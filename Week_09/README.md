# Упражнение 9 - Ограничения на ниво таблица

Налагат правила върху данните в таблицата. Могат да се зададат при дефиниране на релационна схема или след това.

## Типове 

#### Първичен ключ / Primary key

- Гарантира уникалност (определя еднозначно всеки ред в таблицата)
- Идентификатор
- Не може да съдържа NULL стойности
- За 1 таблица - 1 първичен ключ
- Суругатен ключ - ако няма подходящ ключ, избираме такъв

#### Ограничение за уникалност / Unique ограничение

- Еднозначно определя ред
- Може да имаме повече от 1 unique key
- Могат да приемат NULL стойност

| a | b |
|---|---|
| 1 | null |
| null | 1 |
| null | null |
| null | null |

Нека `a` и `b` формират unique key. Тогава не се разрешават повторения - последния ред не бива да съществува

#### Външен ключ

- Атрибут от 1 таблица реферира атрибут от друга
- Реферираните атрибути трябва да са или unique, или primary key
- Използва се за стойности, които съществуват в друга таблица
- Може да се реферира атрибут от същата таблица
- Могат да приемат NULL стойност (ако няма NOT NULL ограничение)

## Деклариране

- Primary key

```sql
CREATE TABLE moviestar(
name CHAR(30) CONSTRAINT pk_moviestar PRIMARY KEY,
... );
```
Ако не зададем име с `CONSTRAINT pk_name`, ще получи генерирано име (EXEC sp_helpconstraints)

```sql
CREATE TABLE moviestar(
...
CONSTRAINT pk_moviestar PRIMARY KEY (name, ...)
);
```
Този начин използваме за няколко атрибута, сформиращи първичен ключ (може и един също).

- Unique key

```sql
CREATE TABLE movie(
...
CONSTRAINT uk_movie UNIQUE (title, year)
);
```

| title | year |
|-------|------|
| t1    | 1990 |
| t1    | 2000 |

Ако title и year са самостоятелно unique key - проблем във втория ред заради title

- Foreign key

Ако се състои от 1 атрибут след името и типа добавяме следното:

```sql
CONSTRAINT fk_table REFERENCES <parent_table> (<p_t_attribute>)
```
За повече атрибути:

```sql
CONSTRAINT fk_table FOREIGN KEY (<child_table_attributes>) REFERENCES <parent_table> (<p_t_attributes>)
```

## Добавяне на ограничение

```sql
ALTER TABLE table_name
ADD CONSTRAINT <constraint_name> <constraint_type>(<attribute>);
```
Името отново не е задължително и тук.

Специфично за foreign key:
```sql
ALTER TABLE table_name
ADD CONSTRAINT <constraint_name> FOREIGN KEY(<attribute>)
REFERENCES <parent_table>(<parent_attribute>);
```

## Политики при външен ключ

Определят поведението при `UPDATE` и `DELETE` на таблицата

### NO ACTION

- По подразбиране е NO ACTION

Дадени са ни таблиците:

| a |
|---|  
| 1 |  
| 2 | 
| 3 | 
| 4 |
| 5 |

| b |
|---|
| 1 |
| 2 |
| 3 |

Да кажем, че атрибут `b` е foreign key към атрибут `a` (който е primary key). Тогава ако променим `а = 1` да е `а = 7`, при `NO ACTION` не се позволява заради вече съществуващата 1-ца в `b` (Ако я нямаше, щеше да се изпълни успешно).

### Cascade

Имаме същите таблици. Искаме да променим `а = 1` да е `а = 7`. Тогава 1-цата при `b` ще се промени и ще стане 7-ца също.

### Set NULL

Имаме същите таблици. Ако изтрием 1 в `a` и `b` разрешава NULL, то в `b` ще стане NULL стойност при 1-цата.

### Set default

Имаме същите таблици. Ако премахнем 1-цата в `a`, то в `b` ще приеме default стойността си, ако тя съществува в parent таблицата (ако не съществува - неуспех).

#### Дефиниране на горните ограничения

```sql
REFERENCES <table_name>(<col_name>)
ON DELETE <policy>
ON UPDATE <policy>
```

```sql
ALTER TABLE <table_name>(<col_name>)
...
REFERENCES <table_name>(<col_name>)
ON DELETE <policy>
ON UPDATE <policy>;

```

Не е задължително да се укажат двете заедно. Колона може да има различно ограничение за DELETE и за UPDATE.

### Check ограничение

Проверява дали при вмъкване или променяне на стойности, те отговарят на някакви условия. Всяко условие, което може да се постави в WHERE клаузата е валидно check ограничение.

Може да се създаде на ниво таблица или на ниво атрибут.

- На ниво таблица

  ```sql
  CREATE TABLE my_table1 (
  col1 INT NOT NULL,
  col2 CHAR(2) NOT NULL,
  CHECK (col2 IN ('BG', 'FR'))
  );
  ```
Условието може да съдържа логически израз, включващ няколко колони от таблицата (специфично за на ниво таблица).
Например:

```sql
CHECK (col2 IN ('BG', 'FR') AND col1 > 1 AND col1 < 10)
```

- На ниво атрибут

  ```sql
  CREATE TABLE my_table1 (
  col1 INT NOT NULL,
  col2 CHAR(2) NOT NULL CHECK (col2 IN ('BG', 'FR'))
  ); 
  ```

#### Добавяне на CHECK ограничение, след като таблицата е създадена

```sql
ALTER TABLE my_table1
ADD CONSTRAINT ck1_mt1_col2
CHECK(col2 IN ('BG', 'FR'));

ALTER TABLE my_table1
ADD CONSTRAINT ck2_mt1_col2
CHECK(col2 IN ('GR', 'RU'));
```
За col2 сме добавили две ограничения. Те се свързват чрез логическо AND. Точно това в нашия случай ще предизвика проблем, тъй като резултата от логическата операция ще бъде празното множество.

## Изтриване на ограничение

```sql
ALTER TABLE <table_name>
DROP CONSTRAINT <constraint_name>; 
```
