# Прошел курсы повышения квалификации
## В Дальневостоочном федераальном университеете:
* #### по специальности  "Специалист-SQL" 
* #### в репозитории "education_certificates" расположенно свидетельство о повышении квалификации
#
### Пример нескольких запросов выполненных на курсе Stepik Расширенный тренажер SQL от ДВФУ


  * включение нового клиента в базу данных;
```sql
INSERT INTO client(name_client, email, city_id)
VALUES ('Попов Илья', 'popov@test', 1);
SELECT * 
FROM client;
```

* формирование нового заказа некоторым пользователем;
```sql
INSERT INTO buy 
SET buy_description = 'Связаться со мной по вопросу доставки', client_id = (SELECT client_id FROM client
WHERE name_client = 'Попов Илья') ;
SELECT * FROM buy;
```
*включение в заказ одной или нескольких книг с указанием их количества;
```sql
(INSERT INTO buy_book(buy_id, book_id, amount)
VALUES(5, 8, 2);
INSERT INTO buy_book(buy_id, book_id, amount)
VALUES(5, 2, 1);
Select * from buy_book;)

#INSERT INTO buy_book (buy_id, book_id, amount)
#SELECT 5, book_id, 2 FROM book, author
#WHERE name_author LIKE 'Пастернак%' AND title='Лирика';

#insert into buy_book(buy_id,book_id,amount)
#select 5,book_id,if(title = 'Лирика',2,1) from book where title = 'Лирика' or title = 'Белая гвардия'
#order by 2 desc

#INSERT INTO buy_book (buy_id, book_id, amount)
#SELECT 5, book_id, 1 FROM book, author
#WHERE name_author LIKE 'Булгаков%' AND title='Белая гвардия';
```
* уменьшение количества книг на складе;
```sql
UPDATE book, buy_book 
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5 AND book.book_id = buy_book.book_id; 
SELECT * FROM book;
```
* создание счета на оплату (полный счет, итоговый счет);
```sql
CREATE TABLE buy_pay AS
SELECT title, name_author, price, buy_book.amount, book.price*buy_book.amount AS Стоимость
FROM buy_book
JOIN book ON book.book_id=buy_book.book_id
JOIN author ON author.author_id=book.author_id
WHERE buy_book.buy_id=5
ORDER BY book.title;
SELECT * FROM buy_pay;
```
* Оющий сет на оплату
```sql
CREATE TABLE buy_pay
SELECT buy_book.buy_id, SUM(buy_book.amount) as Количество,SUM(book.price*buy_book.amount)  as Итого
FROM buy_book
JOIN book USING(book_id)
WHERE buy_id=5
GROUP BY 1;
SELECT*FROM buy_pay;
```
* добавление этапов продвижения заказа;
```sql
insert into buy_step(step_id, buy_id)
select step_id, buy_id
from step cross join (select 5 as buy_id) as c;
select * from buy_step;
```
* фиксация дат прохождения каждого этапа заказа (начало этапа, завершение этапа).
```sql
UPDATE buy_step, step 
SET date_step_beg = '2020.04.12'
WHERE buy_id = 5 AND buy_step.step_id = (SELECT step_id FROM step WHERE name_step = "Оплата");

SELECT *
FROM buy_step
WHERE buy_id = 5;
```
* Добавление Времени в заказ
```sql
UPDATE buy_step, step 
SET date_step_beg = '2020.04.12'
WHERE buy_id = 5 AND buy_step.step_id = (SELECT step_id FROM step WHERE name_step = "Оплата");

SELECT *
FROM buy_step
WHERE buy_id = 5;

```
* Добавление времени покупки в заказ
```sql
UPDATE buy_step
    JOIN step USING(step_id)
SET date_step_end = '2020-04-13'
WHERE buy_id = 5 AND name_step = 'Оплата';

UPDATE buy_step
    JOIN step USING(step_id)
SET date_step_beg = (SELECT date_step_end FROM (SELECT * FROM buy_step) AS buy_step_clone JOIN step USING(step_id) 
                     WHERE buy_id = 5 AND name_step = 'Оплата')
WHERE buy_id = 5 AND name_step = 'Упаковка';

SELECT * FROM buy_step
WHERE buy_id = 5
```
* Сообщение покупателю
```sql
SELECT CONCAT(name_client, '! Извините, ', LCASE(name_step), ' вашего заказа задерживается :(') apologies
  FROM step
       JOIN buy_step USING(step_id)
       JOIN buy USING(buy_id)
       JOIN client USING(client_id)
 WHERE step_id > 1
   AND DATEDIFF(NOW(), date_step_beg) > 14
   AND date_step_end IS NULL;

```
* 
```sql
SET @avg_time := (SELECT CEIL(AVG(submission_time - attempt_time))
FROM step_student INNER JOIN student USING(student_id)
WHERE student_name = "student_59" AND (submission_time - attempt_time) < 3600);
WITH get_stat
AS
(
SELECT student_name, CONCAT(module_id, ".", lesson_position, ".", step_position) AS less, step_id, RANK() OVER (PARTITION BY CONCAT(module_id, ".", lesson_position, ".", step_position) ORDER BY submission_time) AS rang, result, 
CASE
    WHEN (submission_time - attempt_time) > 3600 THEN @avg_time
    ELSE (submission_time - attempt_time)
END AS qr
FROM student 
    INNER JOIN step_student USING(student_id)
    INNER JOIN step USING(step_id)
    INNER JOIN lesson USING(lesson_id)
WHERE student_name = "student_59"
)
SELECT student_name AS Студент, less AS Шаг, rang AS Номер_попытки, result AS Результат, SEC_TO_TIME(CEIL(qr)) AS Время_попытки, ROUND((qr / (SUM(qr) OVER (PARTITION BY less ORDER BY less)) * 100), 2) AS Относительное_время
FROM get_stat
ORDER BY step_id, 3;
```
* Отменить или перенести заказ в соответсвии с датой изменения условий выполнеия услуг
```sql
WITH
get_first_date(service_booking_id, first_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 1 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)-1) DAY)
END as first_date
FROM service_booking
),
get_second_date(service_booking_id, second_date)
AS(
SELECT service_booking_id, (date_add(first_date, interval 7 DAY)) as second_date
FROM service_booking
JOIN get_first_date USING(service_booking_id)
),
get_end_date(service_booking_id, new_date)
AS(
       SELECT service_booking_id,
CASE 
    WHEN (first_date between check_in_date and check_out_date) and (second_date between check_in_date and check_out_date) 
        THEN IF(DATEDIFF(service_start_date,first_date) < DATEDIFF(second_date,service_start_date),first_date,second_date) 
    WHEN second_date between check_in_date and check_out_date
        THEN second_date
    WHEN first_date between check_in_date and check_out_date
        THEN first_date
    ELSE "-"
END as new_date
from service_booking
JOIN get_first_date USING (service_booking_id)
JOIN get_second_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
)
SELECT room_name as Номер, guest_name as Гость, service_start_date as Старая_дата, new_date as Новая_дата,
CASE 
    WHEN service_start_date != new_date THEN "Перенести"
    WHEN new_date = "-" THEN "Отменить"
    ELSE service_start_date
END as Действие
from room_booking
JOIN service_booking USING(room_booking_id)
JOIN get_end_date USING(service_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
WHERE service_id = 5 AND status_id = 1

ORDER BY 5 DESC, 4, 1
LIMIT 10
```
* Итоговый счет клиенту при веселении из гостинници, с учетом всех услуг и расходов
```sql
WITH get_result_concat_1(room_booking_id, result_room, result_room_price)
AS(
   SELECT room_booking_id, CONCAT(type_room_name, " ", room_name, " " ,check_in_date, "/", check_out_date) as result_room,
((DATEDIFF(check_out_date, check_in_date)+1)*price) as result_price
from room_booking
JOIN room USING (room_id)
JOIN type_room USING(type_room_id)
WHERE guest_id = 10 and  check_in_date = '2020-11-04'
),
get_result_concat_2(result_service, result_service_price)
AS(
   SELECT CONCAT(service_name, " ", GROUP_CONCAT(service_start_date ORDER BY 1 separator ',' )) as result_service ,  sum(price) as result_service_price
FROM service_booking
JOIN service USING(service_id)
WHERE room_booking_id = (select room_booking_id from get_result_concat_1)
GROUP BY service_name
),
concat_all(result_all, result_all_price)
AS(
    SELECT result_room, result_room_price
FROM get_result_concat_1
UNION
SELECT result_service, result_service_price
FROM get_result_concat_2
)
SELECT result_all as Вид_платежа, result_all_price as Сумма
FROM concat_all 
UNION
SELECT "Итого", sum(result_all_price)
FROM concat_all

```
* Коофециент продаж книг разного жанра
```sql
WITH get_amount(book_id, available_numbers)
AS(
    SELECT book_id, sum(available_numbers)
    FROM book
    group by book_id
    UNION ALL
    SELECT book_id, count(available_numbers)
    FROM book_reader
    INNER JOIN book USING (book_id)
    WHERE return_date is NULL
    GROUP BY book_id
    
),
get_sum_book(book_id, available_numbers_2)
AS(
   SELECT book_id, sum(available_numbers)  
   FROM get_amount
   group by book_id
),
get_book_count(book_id, book_count)
AS(
    SELECT book_id, count(book_id)
    FROM book_reader
    group by book_id 
    
),
get_book(book_id, ss)
AS(
    SELECT book_id,(available_numbers_2/book_count) as ss
    from book
    JOIN get_sum_book USING (book_id)
    JOIN get_book_count USING (book_id)
    WHERE available_numbers_2/book_count > 3
    
),
get_nul_book(book_id, ss)
AS(
SELECT book_id, 20.00
    FROM book
    WHERE book_id not in (SELECT book_id FROM book_reader)
),
get_result(book_id, ss)
AS(
    SELECT book_id,ss FROM get_book
    union
    SELECT book_id,ss FROM get_nul_book
)
SELECT title, genre_name, ss as Коэффициент
FROM get_result
JOIN book USING(book_id)
JOIN genre USING(genre_id)
ORDER BY 3 DESC,  1
```
* Выбратть книги всех авторов с минимальным количеством на складе и максимальной ценой
```sql
CREATE TABLE store
WITH get_book(tit, auth)
AS(
    select title, author
    FROM supply
),
get_min_amount(min_amount)
AS(
    SELECT ROUND(avg(amount)) FROM book  ORDER BY amount
), 
get_list(title, author, price, amount)
AS(
SELECT title, author, price, amount
FROM book
WHERE (title, author)  in(SELECT tit, auth FROM get_book)    
UNION 
SELECT title, author, price, amount
FROM supply 
WHERE (title, author)  in(SELECT tit, auth FROM get_book)
)
SELECT title as Книга, author as Автор, max(price) as Цена, sum(amount) as Количество
from get_list
WHERE (title, author)  in(SELECT title, author FROM book)
group by title, author
HAVING sum(amount) >= (select min_amount from get_min_amount)
order by Автор, Цена DESC;
SELECT * FROM store;
```
* Добавление новой книги автору
```sql
INSERT INTO book(title, author,  price, amount)
WITH get_author(author)
AS(
    select author
    FROM supply
    WHERE (title not IN (
          select  title
          FROM book)) and (author IN (
          select  author
          FROM book))
),
get_new_book(title, author,  price, amount)
AS(
    select title, author, price, amount
    FROM supply
    WHERE author = (select author from get_author)
)

SELECT title, author, price, amount
FROM get_new_book;
```
*  Создать таблицу и чек с депозитом, внесенным клиентом на счет гостиници и  результатом "Доплатить" или "Вернуть " при выселении.
```sql
CREATE TABLE bill AS
WITH get_id (_id)
AS(
    SELECT room_booking_id 
FROM room_booking
JOIN guest USING (guest_id)
JOIN room USING (room_id)
WHERE guest_name = 'Астахов И.И.' and room_name = 'С-0206' and check_in_date = '2021-01-13'
),
get_service_id (s_id, price)
AS(
    SELECT CONCAT(service_name, ' ', GROUP_CONCAT(service_start_date ORDER BY service_start_date)),
    sum(price)
    FROM service_booking
    JOIN service USING (service_id)
     WHERE room_booking_id=(select _id from get_id)
    GROUP BY service_id
    ORDER BY 1
)
SELECT 
   GROUP_CONCAT(guest_name,' ',room_name,' ',check_in_date,'/', check_out_date) AS Вид_платежа,
   15000.00 AS Сумма
FROM room_booking
JOIN guest USING (guest_id)
JOIN room USING (room_id)
WHERE room_booking_id=(select _id from get_id)
UNION
SELECT *
FROM get_service_id
UNION
SELECT 
   CASE 
   WHEN sum(price) > 15000.00 THEN 'Доплатить'
   WHEN sum(price) < 15000.00 THEN 'Вернуть'
   ELSE 'Итого'
   END,sum(price)-15000.00
   FROM get_service_id
```
* Распределение цены книг
```sql
SELECT 
    author as Автор, 
    ROW_NUMBER() OVER win as Nпп,
    if(CHAR_LENGTH(title)>15,CONCAT(LEFT(title,12),'...'),title) as Книга,
    amount as "Кол-во",
    RANK() OVER win AS Ранг,
    ROUND(CUME_DIST() OVER win,2) AS Распределение,
    ROUND((PERCENT_RANK() OVER win) * 100, 2) AS "Ранг,%"
FROM book
WHERE author in ('Булгаков М.А.', 'Пушкин А.С.', 'Лермонтов М.Ю.')
WINDOW win
AS(
    PARTITION BY author
    ORDER BY amount
)
```
* Сколько дней книги пребывали у читателей 
```sql
WITH get_reader(book_id,count_book, count_day)
AS(
SELECT
    book_id,
    count(borrow_date) OVER win_book_reader, 
    DATEDIFF(borrow_date, lag(borrow_date) OVER win_book_reader)
FROM book_reader
WINDOW win_book_reader 
AS(
    PARTITION BY book_id
    ORDER BY borrow_date
   )
)
SELECT 
    title as Название,
    MAX(count_book) as Количество,
    MIN(count_day) as Минимальный_период
FROM get_reader
JOIN book USING(book_id)
WHERE count_book > 1
GROUP BY book_id
ORDER BY 3, 1 
```
* 
```sql
SELECT author as Автор,
IFNULL(
CONCAT(title,'. ',LEAD(title) OVER win_book),
CONCAT(title,'. ',FIRST_VALUE(title) OVER win_book))as Книги,
IFNULL(
ROUND((price + LEAD(price) OVER win_book)*0.75,2),
ROUND((price + FIRST_VALUE(price) OVER win_book)*0.75,2)
)as Цена      
FROM book
WINDOW win_book
AS( 
    PARTITION BY author
    ORDER BY price DESC
)
```
### И много других различных запросов