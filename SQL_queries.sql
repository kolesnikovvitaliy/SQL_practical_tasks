1.1.6
create table book (book_id int primary key auto_increment, title varchar(50), author varchar(30), price decimal(8,2), 
amount int);

1.1.7
insert into book (book_id, title, author, price, amount) values (1, "Мастер и Маргарита", "Булгаков М.А.",
                                                                670.99, 3)
                                                                
1.1.8
insert into book (book_id, title, author, price, amount) values (2, "Белая гвардия", "Булгаков М.А.",
                                                                540.50, 5);
insert into book (book_id, title, author, price, amount) values (3, "Идиот", "Достоевский Ф.М.",
                                                                460.00, 10);
insert into book (book_id, title, author, price, amount) values (4, "Братья Карамазовы", "Достоевский Ф.М.",
                                                                799.01, 2);
                                                                
1.2.2
select * from book

1.2.3
select author, title, price from book

1.2.4
select title as Название, author as Автор from book

1.2.5
select title, amount, 1.65*amount as pack from book

1.2.6
select title, author, amount, round(price*0.7, 2) as new_price from book

1.2.7
select 
  author, 
  title,
  round(if(author="Булгаков М.А.", price*1.1, if(author="Есенин С.А.", price*1.05, price)), 2) as new_price
from book

1.2.8
select author, title, price from book
where amount<10

1.2.9
select title, author, price, amount from book
where price < 500 and price*amount >= 5000 or price > 600 and price*amount >= 5000

1.2.10
select title, author from book
where  price between 540.50 and 800 and amount in (2,3,5,7)

1.2.11
select title, author from book where title like "_% _%" and author like "% С.%" 

1.2.12
select author, title from book
where amount between 2 and 14
order by author desc, title

1.2.13
select * from book where author like '%Дос%'

1.3.2
select distinct amount from book

1.3.3
select 
  author as Автор, 
  count(title) as "Различных_книг", 
  sum(amount) as "Количество_экземпляров"
from book
group by author

1.3.4
select author, min(price) as Минимальная_цена, max(price) as Максимальная_цена, avg(price) as Средняя_цена
from book
group by author

1.3.5
select 
  author, 
  sum(price*amount) as Стоимость, 
  round(sum(price*amount)*0.18/1.18, 2) as НДС, 
  round(sum(price*amount)/1.18, 2) as Стоимость_без_НДС
from book
group by author

1.3.6
select min(price) as Минимальная_цена, max(price) as Максимальная_цена, round(avg(price), 2) as Средняя_цена
from book

1.3.7
select round(avg(price), 2) as Средняя_цена, round(sum(amount*price), 2) as Стоимость
from book
where amount between 5 and 14

1.3.8
select author, sum(price*amount) as Стоимость
from book
where title not in ("Идиот", "Белая гвардия")
group by author
having sum(price*amount) > 5000
order by Стоимость desc

1.4.2
select author, title, price
from book
where price<=(select avg(price) from book)
order by price desc

1.4.3
select author, title, price
from book
where price - (select min(price) from book) <= 150
order by price asc

1.4.4
select author, title, amount
from book
where amount in (select amount from book group by amount having count(amount)=1)

1.4.5
select author, title, price 
from book
where price < ANY (
    select MIN(price)
    from book 
    group by author
)

1.4.6
select title, author, amount, (select max(amount) from book) - amount as Заказ
from book
having Заказ > 0

1.5.2
create table supply(supply_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(50), author VARCHAR(30), price DECIMAL(8, 2), amount INT)

1.5.3
insert into supply(supply_id, title, author, price, amount) values (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2);
insert into supply(supply_id, title, author, price, amount) values (2, 'Черный человек', 'Есенин С.А.', 570.20, 6);
insert into supply(supply_id, title, author, price, amount) values (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7);
insert into supply(supply_id, title, author, price, amount) values (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);

1.5.4
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not in ('Булгаков М.А.', 'Достоевский Ф.М.')

1.5.5
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not in (select distinct author from book)

1.5.6
update book set price = 0.9*price
where amount between 5 and 10

1.5.7
update book set buy = if(buy > amount, amount, buy),
                price = if(buy = 0, price * 0.9, price);

1.5.8
update book, supply set book.amount=supply.amount+book.amount, book.price=(book.price+supply.price)/2
where book.title=supply.title

1.5.9
delete from supply 
where author in (
  select author
  from book
  group by author
  having sum(amount) > 10
)

1.5.10
create table ordering as
select author, title, (select avg(amount) from book) as amount
from book
where amount<(select avg(amount) from book);

1.6.2
select name, city, per_diem, date_first, date_last
from trip
where name like '%а %.'
order by date_last desc

1.6.3
select distinct name from trip
where city='Москва'
order by name

1.6.4
select city, count(*) as Количество
from trip
group by city
order by city

1.6.5
select city, count(*) as Количество
from trip
group by city
order by Количество desc
limit 2

1.6.6
select name, city, datediff(date_last, date_first)+1 as Длительность
from trip
where city not in ('Москва', "Санкт-Петербург")
order by Длительность desc, city desc

1.6.7
select name, city, date_first, date_last
from trip
where DATEDIFF(date_last, date_first) = (
    select MIN(DATEDIFF(date_last, date_first))
    from trip
)

1.6.8
select name, city, date_first, date_last
from trip
where month(date_last)=month(date_first)
order by city, name

1.6.9
select MONTHNAME(date_first) as Месяц, count(*) as Количество
from trip
group by Месяц
order by Количество desc, Месяц

1.6.10
select name, city, date_first, per_diem*(datediff(date_last, date_first)+1) as Сумма
from trip
where month(date_first) in (2, 3)
order by name, Сумма desc

1.6.11
select name, sum((datediff(date_last, date_first)+1)*per_diem) as Сумма
from trip
group by name
having count(*) > 3
order by 2 desc

1.7.2
create table fine(fine_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(30), number_plate VARCHAR(6),
                 violation VARCHAR(50), sum_fine DECIMAL(8,2), date_violation DATE, date_payment DATE)
                 
1.7.3
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment) 
           values(6, "Баранов П.Е.", 'Р523ВТ', 'Превышение скорости(от 40 до 60)', Null, '2020-02-14', Null);
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment) 
           values(7, "Абрамова К.А.", 'О111АВ', 'Проезд на запрещающий сигнал', Null, '2020-02-23', Null);
insert into fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment) 
           values(8, "Яковлев Г.Р.", 'Т330ТТ', 'Проезд на запрещающий сигнал', Null, '2020-03-03', Null);

1.7.4
Update fine as f, traffic_violation as tv
set f.sum_fine=tv.sum_fine
where f.violation=tv.violation and f.sum_fine is null

1.7.5
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(*) > 1
order by name

1.7.6
update fine, (select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(*) > 1
order by name) as new_fine
set fine.sum_fine=fine.sum_fine*2
where date_payment is null and 
           new_fine.name=fine.name and 
           new_fine.number_plate=fine.number_plate and 
           new_fine.violation=fine.violation

1.7.7
update fine, payment
set fine.date_payment=payment.date_payment,
fine.sum_fine=if(datediff(payment.date_payment, fine.date_violation) <= 20, fine.sum_fine/2, fine.sum_fine)
where fine.name=payment.name and 
fine.number_plate=payment.number_plate and 
fine.violation=payment.violation and  
fine.date_payment is null

1.7.8
create table back_payment as (select name, number_plate, violation, sum_fine, date_violation from fine
where date_payment is null) 

1.7.9
delete from fine
where date_violation < '2020-02-01'

2.1.6
create table author (author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50))

2.1.7
insert into author(author_id, name_author)
values
(1, 'Булгаков М.А.'),
(2, 'Достоевский Ф.М.'),
(3, 'Есенин С.А.'),
(4, 'Пастернак Б.Л.')

2.1.8
CREATE TABLE book (
      book_id INT PRIMARY KEY AUTO_INCREMENT, 
      title VARCHAR(50), 
      author_id INT NOT NULL, 
      genre_id INT,
      price DECIMAL(8,2), 
      amount INT, 
      FOREIGN KEY (author_id)  REFERENCES author (author_id),
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
)

2.1.9
CREATE TABLE book (
      book_id INT PRIMARY KEY AUTO_INCREMENT, 
      title VARCHAR(50), 
      author_id INT, 
    genre_id INT,
      price DECIMAL(8,2), 
      amount INT, 
      FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
      FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE set null
)

2.1.11
insert into book (book_id, title, author_id, genre_id, price, amount)
values 
    (6, "Стихотворения и поэмы", 3, 2, 650.00, 15),
    (7, "Черный человек", 3, 2, 570.20, 6),
    (8, "Лирика", 4, 2, 518.99, 2)
    
2.2.2
select title, name_genre, price
from book
inner join genre
on genre.genre_id=book.genre_id
where amount > 8
order by price desc

2.2.3
select name_genre from genre
left join book
on book.genre_id=genre.genre_id
where amount is null

2.2.4
select name_city, name_author, date_add('2020-01-01', interval 'FLOOR(RAND()*365)' day) as Дата
from author
cross join city

2.2.5
select name_genre, title, name_author 
from book
inner join author
on book.author_id=author.author_id
inner join genre
on book.genre_id=genre.genre_id
where name_genre='Роман'
order by title

2.2.6
select name_author, sum(amount) as Количество
from author
left join book on author.author_id=book.author_id
group by name_author
having sum(amount) < 10 or Количество is null
order by Количество

2.2.7
select name_author from book
inner join author
on author.author_id=book.author_id
group by name_author
having count(distinct genre_id) = 1

2.2.8
select title, name_author, genre_name.name_genre, price, amount
from book
inner join author on author.author_id=book.author_id
inner join (select genre.genre_id, genre.name_genre from (SELECT genre_id, SUM(amount) AS sum_amount
FROM book
GROUP BY genre_id
HAVING sum_amount >= MAX(sum_amount)) as pop_genre
join genre on genre.genre_id=pop_genre.genre_id) as genre_name
on book.genre_id=genre_name.genre_id
order by title

2.2.9
select
    book.title as Название,
    author as Автор,
    book.amount + supply.amount as Количество
from
    book
    join supply on supply.title = book.title
    and supply.price = book.price

2.2.10
select * from book

2.3.2
update book 
inner join author on book.author_id=author.author_id
inner join supply on book.title=supply.title and supply.author = author.name_author
set book.price=if(book.price <> supply.price, (book.price * book.amount + supply.price * supply.amount)/(book.amount+supply.amount), book.price),
book.amount=book.amount+supply.amount,
supply.amount=0
where book.price <> supply.price;

2.3.3
insert into author(author_id, name_author)
select supply_id as author_id, author from supply
left join author
on supply.author=author.name_author
where author_id is null

2.3.4
insert into book(title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM author INNER JOIN supply
     ON author.name_author = supply.author
WHERE amount <> 0

2.3.5
UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Поэзия')
WHERE genre_id is null and book_id=10;

UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Приключения')
WHERE genre_id is null and book_id=11;

2.3.6
delete from author
where author_id in (select author_id from book
                    group by author_id
                    having sum(amount) < 20)
                    
2.3.7
delete from genre
where genre_id in (select genre_id from book
                    group by genre_id
                   having count(genre_id)<3)
                   
2.4.5
select buy.buy_id, book.title, book.price, buy_book.amount from client
inner join buy on client.client_id=buy.client_id
inner join buy_book on buy.buy_id=buy_book.buy_id
inner join book on book.book_id=buy_book.book_id
where client.client_id=1

2.4.6
select name_author, title, count(buy_book.book_id) as Количество
from author
    left join book
    on book.author_id=author.author_id
    left join buy_book
    on buy_book.book_id=book.book_id
group by name_author, title
order by name_author, title

2.4.7
select name_city, count(*) as Количество from buy
inner join client
on client.client_id=buy.client_id
inner join city
on city.city_id=client.city_id
group by name_city

2.4.8
select buy_id, date_step_end from buy_step
where step_id=1 and date_step_end is not null

2.4.9
select buy.buy_id, name_client, sum(buy_book.amount*book.price) as Стоимость from buy
join client on buy.client_id=client.client_id
join buy_book on buy_book.buy_id=buy.buy_id
join book on book.book_id=buy_book.book_id
group by buy.buy_id
order by buy.buy_id

2.4.10
select buy.buy_id, step.name_step from buy
join buy_step on buy_step.buy_id=buy.buy_id
join step on step.step_id=buy_step.step_id
where date_step_beg is not null and date_step_end is null

2.4.11
select buy.buy_id, 
  datediff(buy_step.date_step_end, buy_step.date_step_beg) as Количество_дней, 
  if(city.days_delivery-datediff(buy_step.date_step_end, buy_step.date_step_beg)>=0, 0, datediff(buy_step.date_step_end, buy_step.date_step_beg) - city.days_delivery) as Опоздание  
from city
join client on client.city_id=city.city_id
join buy on buy.client_id=client.client_id
join buy_step on buy_step.buy_id=buy.buy_id
where buy_step.step_id=3 and buy_step.date_step_end is not null
order by buy.buy_id

2.4.12
select name_client from client
join buy on buy.client_id=client.client_id
join buy_book on buy.buy_id=buy_book.buy_id
join book on book.book_id=buy_book.book_id
where book.author_id=2
order by name_client

2.4.13
select name_genre, sum(buy_book.amount) as Количество from buy_book
join book on book.book_id=buy_book.book_id
join genre on genre.genre_id=book.genre_id
group by genre.genre_id, name_genre
limit 1

2.5.2
insert into client(client_id, name_client, city_id, email)
values (5, 'Попов Илья', 1, 'popov@test')

2.5.3
insert into buy(buy_id, buy_description, client_id)
values(5, 'Связаться со мной по вопросу доставки', 5)

2.5.4
insert into buy_book(buy_id, book_id, amount)
values (5, 8, 2);
insert into buy_book(buy_id, book_id, amount)
values (5, 2, 1);

2.5.5
UPDATE book 
     INNER JOIN buy_book
     on book.book_id = buy_book.book_id
           SET book.amount = book.amount-buy_book.amount   
WHERE buy_book.buy_id = 5 ;

2.5.6
create table buy_pay(title varchar(50), name_author varchar(30), price decimal(8,2), amount int, Стоимость decimal(8,2)); 

insert into buy_pay (title, name_author, price, amount, Стоимость) 
select book.title, author.name_author, book.price, buy_book.amount, book.price*buy_book.amount from author 
inner join book on author.author_id = book.author_id 
inner join buy_book on book.book_id = buy_book.book_id 
where buy_book.buy_id = 5 
order by title; 

select title, name_author, price, amount, Стоимость from buy_pay;

2.5.7
create table buy_pay
select buy_id, sum(buy_book.amount) as Количество, sum(price*buy_book.amount) as Итого from buy_book
inner join book on book.book_id=buy_book.book_id
where buy_id=5
group by buy_id

2.5.8
insert into buy_step(buy_id, step_id)
select buy_id, step_id from buy
cross join step
where buy_id=5

2.5.9
update buy_step
set date_step_beg='2020-04-12'
where buy_id=5 and step_id=1

2.5.10
update buy_step
set date_step_end='2020-04-13'
where buy_id=5 and step_id=1;

update buy_step
set date_step_beg='2020-04-13'
where buy_id=5 and step_id=2;

3.1.2
select name_student, date_attempt, result from student
join attempt on attempt.student_id=student.student_id
join subject on subject.subject_id=attempt.subject_id
where name_subject='Основы баз данных'
order by result desc

3.1.3
select name_subject, count(result) as Количество, round(avg(result), 2) as Среднее from subject
left join attempt on subject.subject_id=attempt.subject_id
group by name_subject

3.1.4
select name_student, result from attempt
join student on student.student_id=attempt.student_id
where result=(select max(result) from attempt)

3.1.5
select name_student, name_subject, datediff(max(date_attempt), min(date_attempt)) as Интервал from attempt
join student on student.student_id=attempt.student_id
join subject on subject.subject_id=attempt.subject_id
group by name_student, name_subject
having count(*)>1
order by Интервал

3.1.6
select name_subject, count(distinct attempt.student_id) as Количество from subject
left join attempt on attempt.subject_id=subject.subject_id
group by subject.subject_id
order by name_subject, Количество desc

3.1.7
select question_id, name_question from question
join subject on subject.subject_id=question.subject_id
where subject.name_subject='Основы баз данных'
order by rand()
limit 3

3.1.8
select name_question, name_answer, if(is_correct, 'Верно', 'Неверно') as Результат from question
join testing on question.question_id=testing.question_id
join answer on answer.answer_id=testing.answer_id
where testing.attempt_id=7

3.1.9
select name_student, name_subject, date_attempt, round(sum(is_correct)/3*100, 2) as Результат from answer
join testing on testing.answer_id=answer.answer_id
join attempt on attempt.attempt_id=testing.attempt_id
join subject on subject.subject_id=attempt.subject_id
join student on student.student_id=attempt.student_id
group by name_student, name_subject, date_attempt
order by name_student, Результат desc

3.1.10
select 
name_subject, 
concat(left(name_question, 30), '...') as Вопрос, 
count(*) as Всего_ответов,
round(sum(is_correct)/count(*)*100, 2) as Успешность 
from subject
join question on question.subject_id=subject.subject_id
join testing on question.question_id=testing.question_id
join answer on answer.answer_id=testing.answer_id
group by question.question_id
order by name_subject, Успешность desc, Вопрос

3.2.2
insert into attempt(student_id, subject_id, date_attempt, result)
values (1, 2, now(), null)

3.2.3
insert into testing(attempt_id, question_id)
select attempt_id, question.question_id from question
join subject on subject.subject_id=question.subject_id
join attempt on attempt.subject_id=question.subject_id
where subject.subject_id=2 and attempt_id=(select max(attempt_id) from attempt)
order by rand()
limit 3

3.2.4
update attempt,
(
    select student.student_id, subject.subject_id, date_attempt, round(sum(is_correct)/3*100) as result from answer
    join testing on testing.answer_id=answer.answer_id
    join attempt on attempt.attempt_id=testing.attempt_id
    join subject on subject.subject_id=attempt.subject_id
    join student on student.student_id=attempt.student_id
    where attempt.attempt_id=8
    group by student.student_id, subject.subject_id, date_attempt
) as tmp
set attempt.result=tmp.result
where attempt_id=8;

3.2.5
delete from attempt
where date_attempt < '2020-05-01'

3.3.2
select name_enrollee from enrollee
join program_enrollee on program_enrollee.enrollee_id=enrollee.enrollee_id
join program on program_enrollee.program_id=program.program_id
where program.name_program="Мехатроника и робототехника"
order by name_enrollee 

3.3.3
select name_program from program
join program_subject on program_subject.program_id=program.program_id
join subject on subject.subject_id=program_subject.subject_id
where name_subject='Информатика'

3.3.4
select 
  name_subject, 
  count(*) as Количество, 
  max(result) as Максимум, 
  min(result) as Минимум, 
  round(avg(result), 1) as Среднее 
from subject
join enrollee_subject on enrollee_subject.subject_id=subject.subject_id
group by name_subject
order by name_subject

3.3.5
select distinct name_program from program
join program_subject on program_subject.program_id=program.program_id
group by name_program
having min(min_ball) >= 40
order by name_program

3.3.6
select name_program, plan from program
where plan=(select max(plan) from program)

3.3.7
select name_enrollee, ifnull(sum(a.add_ball), 0) as Бонус from enrollee e
left join enrollee_achievement ev on e.enrollee_id=ev.enrollee_id
left join achievement a on a.achievement_id=ev.achievement_id
group by name_enrollee

3.3.8
select 
  name_department, 
  p.name_program, plan, 
  count(*) as Количество, round(count(*)/plan, 2) as Конкурс 
from program_enrollee pe
join program p on pe.program_id=p.program_id
join department d on d.department_id=p.department_id
group by name_department, p.name_program, plan
order by plan, name_program desc

3.3.9
select p.name_program from subject s
join program_subject ps on s.subject_id=ps.subject_id
join program p on p.program_id=ps.program_id
where name_subject in ('Математика', 'Информатика')
group by name_program
having count(*)=2

3.3.10
SELECT p.name_program, e.name_enrollee, SUM(es.result) AS itog
FROM program_subject ps
    INNER JOIN program p USING(program_id)
    INNER JOIN program_enrollee pe USING(program_id)
    INNER JOIN enrollee e USING(enrollee_id)
    INNER JOIN enrollee_subject es ON es.subject_id = ps.subject_id AND
                                  es.enrollee_id = pe.enrollee_id
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

3.3.11
SELECT name_program, name_enrollee
FROM enrollee
     JOIN program_enrollee USING(enrollee_id)
     JOIN program USING(program_id)
     JOIN program_subject USING(program_id)
     JOIN subject USING(subject_id)
     JOIN enrollee_subject USING(subject_id)
WHERE enrollee_subject.enrollee_id = enrollee.enrollee_id and result < min_result
ORDER BY 1, 2

3.4.1
CREATE TABLE applicant
SELECT program_id, enrollee.enrollee_id, SUM(result) AS itog
FROM enrollee
     JOIN program_enrollee USING(enrollee_id)
     JOIN program USING(program_id)
     JOIN program_subject USING(program_id)
     JOIN subject USING(subject_id)
     JOIN enrollee_subject USING(subject_id)
WHERE enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY program_id, enrollee_id
ORDER BY program_id, itog DESC;

3.4.2
DELETE FROM applicant
USING
  applicant
  JOIN (
    SELECT program_enrollee.program_id, program_enrollee.enrollee_id 
    FROM program
    JOIN program_subject  USING(program_id)
    JOIN program_enrollee USING(program_id)
    JOIN enrollee_subject ON 
    enrollee_subject.enrollee_id = program_enrollee.enrollee_id AND
    enrollee_subject.subject_id = program_subject.subject_id
    WHERE result < min_result
 ) AS t
 ON applicant.program_id = t.program_id AND
    applicant.enrollee_id = t.enrollee_id

3.4.3
UPDATE applicant JOIN (
    SELECT enrollee_id, IFNULL(SUM(bonus), 0) AS Бонус FROM enrollee_achievement
    LEFT JOIN achievement USING(achievement_id)
    GROUP BY enrollee_id 
    ) AS t USING(enrollee_id)
SET itog = itog + Бонус;

3.4.4
CREATE TABLE applicant_order
SELECT * FROM applicant
ORDER BY 1, 3 DESC;
DROP TABLE applicant

3.4.5
ALTER TABLE applicant_order ADD
str_id int FIRST

3.4.6
SET @row_num := 1;
SET @num_pr := 0;
UPDATE applicant_order
    SET str_id = IF(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 AND @num_pr := @num_pr + 1);

3.4.7
CREATE TABLE student
SELECT name_program, name_enrollee, itog FROM enrollee
	JOIN applicant_order USING (enrollee_id)
	JOIN program USING (program_id)
WHERE str_id<=plan
ORDER BY name_program, itog DESC;

3.5.1
SELECT CONCAT(LEFT(CONCAT(module_id, ' ', module_name), 16), '...') Модуль,
       CONCAT(LEFT(CONCAT(module_id, '.', lesson_position, ' ', lesson_name), 16), '...') Урок,
       CONCAT(module_id, '.', lesson_position, '.', step_position, ' ', step_name) Шаг
  FROM module
       INNER JOIN lesson USING(module_id)
       INNER JOIN step   USING(lesson_id)
 WHERE step_name LIKE '%ложенн% запрос%'
 ORDER BY module_id, lesson_id, step_id;

3.5.2
INSERT INTO step_keyword
SELECT step.step_id, keyword.keyword_id 
FROM 
    keyword
    CROSS JOIN step
WHERE step.step_name REGEXP CONCAT(' ', CONCAT(keyword.keyword_name, '\\b'))
GROUP BY step.step_id, keyword.keyword_id
ORDER BY keyword.keyword_id;

3.5.3
SELECT 
    concat(module_id,'.',lesson_position,
           IF(step_position < 10, ".0","."),
           step_position," ",step_name) AS Шаг
FROM
   step
   JOIN lesson USING(lesson_id)
   JOIN module USING(module_id)
   JOIN step_keyword USING (step_id)
   JOIN keyword USING(keyword_id)
WHERE keyword_name = 'MAX' OR keyword_name ='AVG'
GROUP BY ШАГ
HAVING COUNT(*) = 2
ORDER BY 1;

3.5.4
SELECT
    rate_group Группа, 
    CASE rate_group
        WHEN 'I'   THEN 'от 0 до 10'
        WHEN 'II'  THEN 'от 11 до 15'
        WHEN 'III' THEN 'от 16 до 27'
        ELSE 'больше 27'
    END Интервал,
    COUNT(*) Количество
FROM
(
    SELECT 
        CASE
            WHEN COUNT(DISTINCT step_id) <= 10 THEN 'I'
            WHEN COUNT(DISTINCT step_id) <= 15 THEN 'II'
            WHEN COUNT(DISTINCT step_id) <= 27 THEN 'III'
            ELSE 'IV'
        END rate_group
    FROM step_student
    WHERE result = 'correct'
    GROUP BY student_id
) query_in
GROUP BY rate_group
ORDER BY 1;

3.5.5
WITH table1 (step_name, correct, count) AS (   
SELECT 
  step_name, 
  SUM( IF (result = 'correct' , 1 , 0)) AS s, 
  COUNT(result) AS c
  FROM step 
  JOIN step_student USING (step_id)
  GROUP BY step_name
    )

SELECT  step_name AS Шаг, ROUND((correct/count)*100) AS Успешность
FROM table1
ORDER BY 2, 1

3.5.6
WITH get_passed (student_name, pssd)
    AS
        (
           SELECT student_name, COUNT(DISTINCT step_id) AS passed
           FROM student JOIN step_student USING(student_id)
           WHERE result = "correct"
           GROUP BY student_id
           ORDER BY passed
         )
SELECT student_name AS Студент, ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) AS Прогресс,
    CASE
        WHEN ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) =  100 THEN "Сертификат с отличием"
        WHEN ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) >= 80 THEN "Сертификат"
        ELSE ""
    END AS Результат
FROM get_passed
ORDER BY Прогресс DESC, Студент

3.5.7
SELECT student_name AS Студент, 
    CONCAT(LEFT(step_name, 20), '...') AS Шаг, 
    result AS Результат, 
    FROM_UNIXTIME(submission_time) AS Дата_отправки,
    SEC_TO_TIME(submission_time - LAG(submission_time, 1, submission_time) OVER (ORDER BY submission_time)) AS Разница
FROM student
    INNER JOIN step_student USING(student_id)
    INNER JOIN step USING(step_id)
WHERE student_name = 'student_61'
ORDER BY Дата_отправки;

3.5.8
SELECT ROW_NUMBER() OVER (ORDER BY Среднее_время) AS Номер,
    Урок, Среднее_время
FROM(
    SELECT 
        Урок, ROUND(AVG(difference), 2) AS Среднее_время
FROM
     (SELECT student_id,
             CONCAT(module_id, '.', lesson_position, ' ', lesson_name) AS Урок,
             SUM((submission_time - attempt_time) / 3600) AS difference
      FROM module INNER JOIN lesson USING (module_id)
                  INNER JOIN step USING (lesson_id)
                  INNER JOIN step_student USING (step_id)
      WHERE submission_time - attempt_time <= 4 * 3600
      GROUP BY 1, 2) AS query_1
GROUP BY 1) AS TA
order by 3;

3.5.9
SELECT  module_id AS Модуль, student_name AS Студент, COUNT(DISTINCT step_id) AS Пройдено_шагов ,
	ROUND(COUNT(DISTINCT step_id) / 
      MAX(COUNT(DISTINCT step_id)) OVER(PARTITION BY module_id) *100, 1) AS Относительный_рейтинг
FROM lesson 
	JOIN step USING (lesson_id)
	JOIN step_student USING (step_id)
	JOIN student USING (student_id)
WHERE result = 'correct'
GROUP BY module_id, student_name
ORDER BY 1, 4 DESC, 2

3.5.10
WITH get_time_lesson(student_name,  lesson, max_submission_time)
AS(
    SELECT student_name,  CONCAT(module_id, '.', lesson_position), MAX(submission_time)
    FROM step_student INNER JOIN step USING (step_id)
                          INNER JOIN lesson USING (lesson_id)
                          INNER JOIN student USING(student_id)
    WHERE  result = 'correct'  
    GROUP BY 1,2
    ORDER BY 1),
get_students(student_name)
AS(
    SELECT student_name 
    FROM get_time_lesson
    GROUP BY student_name
    HAVING COUNT(lesson) = 3)
SELECT student_name as Студент,  
       lesson as Урок, 
       FROM_UNIXTIME(max_submission_time) as Макс_время_отправки, 
       IFNULL(CEIL((max_submission_time - LAG(max_submission_time) OVER (PARTITION BY student_name ORDER BY max_submission_time )) / 86400),'-') as Интервал 
FROM get_time_lesson
WHERE student_name in (SELECT * FROM get_students)
ORDER BY 1,3;

3.5.11
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

4.1.1
SELECT beg_range, end_range,
     ROUND(AVG(price), 2) AS Средняя_цена,
     SUM(price * amount) AS Стоимость,
     COUNT(amount) AS Количество
FROM(
    SELECT beg_range, end_range, price, amount
    FROM stat 
    JOIN book ON beg_range<price AND end_range>price
    ) table1    
GROUP BY beg_range, end_range
ORDER BY 1

4.1.2
SELECT *
FROM book
ORDER BY LENGTH(title)

4.1.3
DELETE book, supply 
FROM book, supply
WHERE book.price LIKE '%.99' 
    AND supply.price LIKE '%.99';

4.1.4
SELECT author, title, price, amount,
    IF(price > 600, ROUND(price * 0.2, 2), '-') AS sale_20, 
    IF(price > 600, ROUND(price * 0.8, 2),  '-') AS price_sale
FROM book
ORDER BY author, title

4.1.5
SET @avg_price := (SELECT AVG(price) FROM book);
SELECT author,  
    SUM(price * amount) AS Стоимость 
FROM book
WHERE author in (SELECT author FROM book WHERE price > @avg_price)
GROUP BY author
ORDER BY 2 DESC;

4.1.6
SELECT author AS "Автор", title AS "Название_книги", amount AS "Количество", price AS "Розничная_цена",
    IF (amount >= 10, 15, 0) AS "Скидка",
    round (IF (amount >= 10, price * 0.85, price), 2) AS "Оптовая_цена"    
FROM book
ORDER BY author, title;

4.1.7
SELECT author, 
    COUNT(author) AS Количество_произведений, 
    MIN(price) AS Минимальная_цена, 
    SUM(amount) AS Число_книг 
FROM book
WHERE amount > 1
GROUP BY author
HAVING COUNT(author) > 1
ORDER BY author;
#################################################
#################################################


regexp '-09|-10'
REGEXP '.-09..|.-10..'
SUBSTRING(room_name, 3, 2) IN(9, 10)
regexp '.-(09|10)..'
left(right(room_name,4),2) in (09, 10)
DATEDIFF(LAST_DAY(check_in_date), check_in_date) + 1



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

SELECT 
    author as Автор, title as Книга, price*amount as Стоимость,
    SUM(price*amount) OVER win_book  AS Стоимость_с_накоплением
FROM book
WINDOW win_book
AS(
    PARTITION BY author
    ORDER BY price*amount
    ROWS UNBOUNDED PRECEDING
)
ORDER BY author DESC, Стоимость

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








WITH get_sum_amount(author, sum_amount)
AS(
    SELECT  author, sum(amount)
    FROM book
    GROUP BY 1
)
SELECT author as Автор, sum_amount as Количество,
IFNULL(
        CONCAT('меньше, чем у ',LAG(author) OVER win_get, ' на ' ,LAG(sum_amount) OVER win_get-sum_amount),
        "-") AS Разница
FROM get_sum_amount
WINDOW win_get
AS(
    ORDER BY sum_amount DESC 
);



SELECT 
    ROW_NUMBER() OVER win as Nпп,
    author as Автор, 
    if(CHAR_LENGTH(title)>15,CONCAT(LEFT(title,12),'...'),title) as Книга,
    amount as "Кол-во",
    RANK() OVER win AS Ранг,
    ROUND(CUME_DIST() OVER win,2) AS Распределение,
    ROUND((PERCENT_RANK() OVER win) * 100, 2) AS "Ранг,%"
FROM book
WINDOW win
AS(
    ORDER BY amount
)
ORDER BY amount,title;

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



DELETE FROM book_reader 
USING book_reader
join book using(book_id)
join reader using(reader_id)
join publisher using(publisher_id)
WHERE title = 'Пуаро ведет следствие' and reader_name = 'Туполев И.Д.' 
	and return_date is NULL and year_publication = 2008 and publisher_name = 'ДРОФА'


##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
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







##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
WITH
get_first_date(service_booking_id, first_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 1 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as first_date
FROM service_booking
),
get_second_date(service_booking_id, second_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 1 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as second_date
FROM service_booking
),
get_end_date(service_booking_id, new_date)
AS(
       SELECT service_booking_id,
CASE 
    WHEN ((second_date between check_in_date and check_out_date) and (first_date between check_in_date and check_out_date)) 
    THEN IF((DATEDIFF(service_start_date,second_date) < DATEDIFF(first_date,service_start_date)), second_date,first_date) 
    WHEN (second_date between check_in_date and check_out_date)
    THEN second_date
    WHEN (first_date between check_in_date and check_out_date)
    THEN first_date
    WHEN ((first_date not between check_in_date and check_out_date) and (second_date not between check_in_date and check_out_date))
        THEN "-"
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
from service_booking
JOIN get_end_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
WHERE service_id = 5

ORDER BY 5 DESC, 4, 1
LIMIT 10









##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
WITH
get_first_date(service_booking_id, first_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 1 THEN service_start_date
    WHEN WEEKDAY(service_start_date) < 1 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 1 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as first_date
FROM service_booking
),
get_second_date(service_booking_id, second_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 1 THEN service_start_date
    WHEN WEEKDAY(service_start_date) < 1 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 1 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as second_date
FROM service_booking
),
get_end_date(service_booking_id,new_date)
AS(
       SELECT service_booking_id,
CASE
    WHEN first_date >= check_in_date and first_date <= check_out_date  THEN first_date
    WHEN second_date >= check_in_date and second_date <= check_out_date  THEN second_date
    WHEN (second_date >= check_in_date and second_date <= check_out_date) and (first_date >= check_in_date and first_date <= check_out_date) THEN "sdfaaf"
    ELSE "-"
END as new_date
from service_booking
JOIN get_first_date USING (service_booking_id)
JOIN get_second_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
)
SELECT room_name as Номер, guest_name as Гость, service_start_date as Старая_дата, new_date as Новая_дата,
CASE 
    WHEN service_start_date <> new_date THEN "Перенести"
    WHEN new_date = "-" THEN "Отменить"
    ELSE service_start_date
END as Действие
from service_booking
JOIN get_end_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
WHERE service_id = 5
ORDER BY 5 DESC, 4, 1 













##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
WITH
get_first_date(service_booking_id, first_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as first_date
FROM service_booking
),
get_second_date(service_booking_id, second_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as second_date
FROM service_booking
),
get_end_date(service_booking_id,new_date)
AS(
       SELECT service_booking_id,
CASE
    WHEN first_date >= check_in_date and first_date <= check_out_date  THEN first_date
    WHEN second_date >= check_in_date and second_date <= check_out_date  THEN second_date
    WHEN (second_date >= check_in_date and second_date <= check_out_date) and (first_date >= check_in_date and first_date <= check_out_date) THEN "sdfaaf"
    ELSE "-"
END as new_date
from service_booking
JOIN get_first_date USING (service_booking_id)
JOIN get_second_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
)
SELECT room_name as Номер, guest_name as Гость, service_start_date as Старая_дата, new_date as Новая_дата,
CASE 
    WHEN service_start_date <> new_date THEN "Перенести"
    WHEN new_date = "-" THEN "Отменить"
    ELSE service_start_date
END as Действие
from service_booking
JOIN get_end_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
WHERE service_id = 5
ORDER BY 5 DESC, 4, 1 



##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
WITH
get_first_date(service_booking_id, first_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as first_date
FROM service_booking
),
get_second_date(service_booking_id, second_date)
AS(
SELECT service_booking_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as second_date
FROM service_booking
/*JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)*/
),
get_end_date(service_booking_id,new_date)
AS(
       SELECT service_booking_id,
CASE
    WHEN first_date >= check_in_date and first_date <= check_out_date  THEN first_date
    WHEN second_date >= check_in_date and second_date <= check_out_date  THEN second_date
    WHEN (second_date >= check_in_date and second_date <= check_out_date) and (first_date >= check_in_date and first_date <= check_out_date) THEN "sdfaaf"
    ELSE "-"
END as new_date
from service_booking
JOIN get_first_date USING (service_booking_id)
JOIN get_second_date USING(service_booking_id)
JOIN room_booking USING (room_booking_id)
)
SELECT * from get_end_date


##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
WITH
get_first_date(service_booking_id, room_id, guest_id, first_date)
AS(
SELECT service_booking_id, room_id, guest_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as first_date
FROM service_booking
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
),
get_second_date(service_booking_id, room_id, guest_id, second_date)
AS(
SELECT service_booking_id, room_id, guest_id,
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) = 0 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date)+1) DAY)
    WHEN WEEKDAY(service_start_date) > 0 THEN date_add(service_start_date, interval (WEEKDAY(service_start_date) - 1) DAY)
END as second_date
FROM service_booking
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)
)
SELECT service_booking_id, first_date, second_date
from get_second_date
JOIN get_first_date USING (service_booking_id)

##/*THEN (service_start_date + (1-WEEKDAY(service_start_date)+floor((WEEKDAY(service_start_date)-1)/4)*7))*/##
SELECT room_id, guest_name, service_start_date, 
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) < 4 THEN date_add(service_start_date, interval (4 - WEEKDAY(service_start_date)) DAY)
    WHEN WEEKDAY(service_start_date) > 4 THEN date_sub(service_start_date, interval (WEEKDAY(service_start_date) - 4) DAY)
END as aaa
FROM service_booking
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)



SELECT room_name, guest_name, service_start_date, 
CASE
    WHEN WEEKDAY(service_start_date) = 4 THEN service_start_date
    WHEN WEEKDAY(service_start_date) > 4 THEN service_start_date + DATEDIFF(service_start_date,4)
    WHEN WEEKDAY(service_start_date) < 4 THEN ADDDATE(service_start_date, INTERVAL - DATEDIFF(service_start_date,4), DAY)
END as aaa
FROM service_booking
JOIN room_booking USING (room_booking_id)
JOIN room USING (room_id)
JOIN guest USING (guest_id)
JOIN service USING (service_id)





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
    
)


SELECT title, genre_name, book_count
from book

JOIN get_sum_book USING (book_id)
JOIN genre USING (genre_id)
JOIN get_book_count USING (book_id)
#WHERE available_numbers_2/book_count > 3 
GROUP BY book.book_id 
ORDER BY 3, 2

/*SELECT book_id, if(book_reader.book_id is NULL,20, 1) as ss
    FROM book
   LEFT join book_reader USING (book_id)*/

SELECT room_name as Номер, CONCAT("Тип: ", type_room_name, "\nцена: ", price, " руб.", "\nэтаж: ", SUBSTRING(room_name, 3, 2), "\nвид: ", IF ( SUBSTRING(room_name, 4, 5) % 2 != 0, "на горы", "на море")) AS Описание
FROM room
INNER JOIN type_room USING (type_room_id)
ORDER BY 1

WITH get_amount(title, book_id, available_numbers)
AS(
    SELECT title, book_id, sum(available_numbers)
    FROM book
    group by book_id
    UNION ALL
    SELECT title, book_id, count(available_numbers)
    FROM book_reader
    INNER JOIN book USING (book_id)
    WHERE return_date is NULL
    GROUP BY book_id
    
),
get_sum_book(title_2, book_id, available_numbers_2)
AS(
   SELECT title, book_id, sum(available_numbers)  
   FROM get_amount
   group by title, book_id
)

SELECT title_2 as Книга, GROUP_CONCAT(author_name ORDER BY 1) as Авторы, genre_name as Жанр, publisher_name as Издательство, available_numbers_2 as Количество
from get_sum_book
INNER JOIN book_author USING (book_id)
INNER JOIN author USING (author_id)
INNER JOIN book USING (book_id)
INNER JOIN genre USING (genre_id)
INNER JOIN publisher USING (publisher_id)
GROUP BY title_2, genre_name, publisher_name, available_numbers_2
ORDER BY 1, 2





SELECT guest_name as Гость, GROUP_CONCAT(DISTINCT(service_name) ORDER BY 1 SEPARATOR '\n') as Услуги, sum(price) as Сумма
FROM service_booking
INNER JOIN room_booking USING (room_booking_id)
INNER JOIN service USING (service_id)
INNER JOIN guest USING (guest_id)
WHERE  service_start_date between '2020.12.01' and '2021.01.31'
GROUP BY guest_name
ORDER BY 1



SELECT type_room_name as Тип_номера, year(check_in_date) as Год, QUARTER(check_in_date) as Квартал,sum(status_id) as Количество
FROM room_booking
INNER JOIN room USING (room_id)
INNER JOIN type_room USING (type_room_id)
WHERE status_id = 1
GROUP BY type_room_name, year(check_in_date), QUARTER(check_in_date)
ORDER BY 1, 2, 3

SELECT guest_name as Гость, room_name as Номер, MONTHNAME(check_in_date) as Месяц_заселения, (DATEDIFF(check_out_date, check_in_date) + 1)-DAY(check_out_date) as Сутки_1, MONTHNAME(check_out_date) as Месяц_выселения, DAY(check_out_date) as Сутки_2
FROM room_booking 
INNER JOIN guest USING (guest_id)
INNER JOIN room USING (room_id) LEFT JOIN type_room USING (type_room_id)
WHERE MONTHNAME(check_in_date) != MONTHNAME(check_out_date) and status_id = 1
ORDER BY 1, 2, 3 DESC


SELECT room_name, check_in_date, (DATEDIFF(check_out_date, check_in_date) + 1) as Количество_дней
FROM room_booking 
INNER JOIN room USING (room_id) LEFT JOIN type_room USING (type_room_id)
WHERE status_id = 2 and type_room_name NOT LIKE '%люкс%'
ORDER BY 1, 2

SELECT room_name, check_in_date, check_out_date, (DATEDIFF(check_out_date, check_in_date) + 1) as Дни,
price*(DATEDIFF(check_out_date, check_in_date) + 1) as Счет
FROM room_booking 
INNER JOIN room USING (room_id) LEFT JOIN type_room USING (type_room_id)
WHERE status_id = 1 and type_room_id = 3
ORDER BY 1, 5 DESC, 2 DESC


SELECT room_name, type_room_name, price
FROM type_room 
INNER JOIN room USING (type_room_id)
WHERE room.room_id not in (select room_id from room_booking)
ORDER BY 3, 1

#############    UNION    #############
SELECT 
   "Количество гостей" AS Характеристика,
   round(count(DISTINCT(guest_id))) AS Результат
FROM room_booking
UNION
SELECT 
   "Количество номеров",
   ROUND(COUNT(room_id))
FROM room
UNION
SELECT 
   "Сумма за проживание",
   round(sum(price*(DATEDIFF(check_out_date, check_in_date)+1)))
FROM room_booking
INNER JOIN room USING (room_id)
INNER JOIN type_room USING (type_room_id)
WHERE status_id = 1
UNION
SELECT 
   "Количество услуг",
   round(count(service_id))
FROM service
UNION
SELECT 
   "Сумма за услуги",
   round(sum(price))
FROM service_booking;






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

SELECT * FROM book;















WITH get_sum_amount(auth,sum_amount)
AS(
    select author, sum(amount)
    FROM book
    GROUP BY author
),
get_min_amount(auth, min_amount)
AS(
    select auth, sum_amount
    from get_sum_amount
    WHERE sum_amount = (select min(sum_amount) from get_sum_amount)
),
get_max_amount(auth, max_amount)
AS(
    select auth, sum_amount
    from get_sum_amount
    WHERE sum_amount = (select max(sum_amount) from get_sum_amount)
)
UPDATE book
set price = 
    CASE 
       WHEN author IN (SELECT auth FROM  get_max_amount) THEN 0.85 * price
       WHEN author IN (SELECT auth FROM  get_min_amount) THEN price + price * 0.1
       ELSE price
    END;
SELECT * FROM book;


WITH get_sum_amount(auth,sum_amount)
AS(
    select author, sum(amount)
    FROM book
    GROUP BY author
),

get_min_amount(auth, min_amount)
AS(
    select auth, sum_amount 
    from get_sum_amount
    
),

get_max_amount(auth, max_amount)
AS(
    select auth, max(sum_amount) 
    from get_sum_amount
    group by auth
)
select auth, min_amount
from get_min_amount
WHERE min_amount = min(sum_amount)


















select sum(amount) FROM book GROUP BY author;



/*WITH get_author_min(auth_min, min_price)
AS(
    select author, min(count(amount))
    FROM book
    GROUP BY author
),
get_author_max(auth_max, max_price)
AS( 
    select author, max(count(amount))
    from book
    group by author
)

SELECT author, price
FROM book
WHERE price != (select max_price from get_author_max)
group by
/*
UPDATE book
set price = 
    CASE 
       WHEN author IN (SELECT auth FROM  get_author_avg) THEN 0.9 * price
       ELSE price
    END;

SELECT * FROM book;
*/
*/











WITH get_year(applicant, year_1)
AS(SELECT applicant, MAKEDATE('2021',DAYOFYEAR(DATE_ADD('2021-10-01', INTERVAL DAY(date_birth)-1 DAY))) as year_1 from resume WHERE specialisation = 'IT')
SELECT 
      CASE 
          WHEN DAYOFWEEK(year_1) = 1 THEN MAKEDATE('2021',DAYOFYEAR(DATE_ADD(year_1, INTERVAL 1 DAY)))
          WHEN DAYOFWEEK(year_1) = 7 THEN MAKEDATE('2021',DAYOFYEAR(DATE_SUB(year_1, INTERVAL 1 DAY)))
          WHEN DAYOFWEEK(year_1) != 7 and DAYOFWEEK(year_1) != 1 THEN year_1
      END as Дата, GROUP_CONCAT(applicant order by 1) as Соискатели 
FROM get_year
GROUP BY Дата
#####
WITH tab (applicant, day_b, day_i, day_w)
AS
(SELECT
    applicant,
    DATE_FORMAT(date_birth, '%d'),
    CONCAT('2021-10-', DATE_FORMAT(date_birth, '%d')),
    DAYOFWEEK(CONCAT('2021-10-', DATE_FORMAT(date_birth, '%d')))
FROM resume
WHERE specialisation = 'IT'),
tab2 (applicant, day_d) 
AS
(SELECT 
     applicant,
     CASE
         WHEN day_w = 7 THEN DATE_SUB(day_i, INTERVAL 1 DAY)
         WHEN day_w = 1 THEN DATE_ADD(day_i, INTERVAL 1 DAY)
     ELSE day_i
     END
FROM tab
)
SELECT 
   day_d AS Дата,
   GROUP_CONCAT(applicant ORDER BY applicant) AS Соискатели
FROM tab2
GROUP BY 1
ORDER BY 1
WHERE SUBSTRING(room_name, 3, 2) IN (10, 09)
regexp '.-(09|10)..'    ,  regexp '-09|-10'


SELECT reader_name as Читатель, title as Название, borrow_date as Дата_выдачи, return_date as Дата_возврата, ((DATEDIFF(return_date, borrow_date) + 1) - 14) * 2 as Пеня
FROM book_reader
INNER JOIN book USING (book_id)
INNER JOIN reader USING (reader_id)
WHERE return_date is not NULL and (DATEDIFF(return_date, borrow_date) + 1) > 14
ORDER BY 1, 5 DESC, 2










WITH get_year(year_1)
AS(SELECT TIMESTAMPDIFF(YEAR, date_birth, '2021-08-7') as year_1 from resume)
#applicant      | specialisation | position             | Возраст
SELECT applicant, specialisation, position, (SELECT min(year_1) FROM  get_year) as Возраст
from resume
#WHERE (SELECT min(year_)
 #           FROM  get_year)



#SELECT count(applicant), specialisation as spec from resume  group by specialisation
#SELECT count(applicant) from resume
SELECT (select specialisation from resume  group by specialisation) AS specialisation
   
FROM resume










WITH get_year(year_)
AS(SELECT TIMESTAMPDIFF(YEAR, date_birth, '2021-08-7') as year_1 from resume)
SELECT 
   "моложе 21 года" AS Возрастная_группа,
   (SELECT count(year_)
    FROM  get_year
   where year_ <= 21) as Количество
FROM resume
UNION
SELECT 
   "от 21 до 30 лет",
   (SELECT count(year_)
    FROM  get_year
   where year_ >= 21 and year_ <= 30)
FROM resume
UNION
SELECT 
   "от 31 до 40 лет",
   (SELECT count(year_)
    FROM  get_year
   where year_ >= 31 and year_ <= 40)
FROM resume
UNION
SELECT 
   "старше 40 лет",
   (SELECT count(year_)
    FROM  get_year
   where year_ > 40)
FROM resume










WITH get_year(year_1)
AS(
   SELECT applicant, TIMESTAMPDIFF(YEAR, date_birth, '2021-08-7') as year_1
FROM resume ) 
 
 
 
SELECT 
   "моложе 21 года" AS Возрастная_группа,
   sum(SELECT applicant
                  FROM resume, get_year 
                  WHERE year_1 = 22)
FROM resume
/*UNION
SELECT 
   "от 21 до 30 лет",
   COUNT(*)
FROM resume
UNION
SELECT 
   "от 31 до 40 лет",
   ROUND(AVG(experience))
FROM resume
UNION
SELECT 
   "старше 40 лет",
   ROUND(AVG(min_salary))
FROM resume;*/
/*WITH get_year(year_)
AS(
   SELECT 
   FROM resume 
)
SELECT applicant, TIMESTAMPDIFF(YEAR, date_birth, '2021-08-7') as year_
FROM resume */
/*GROUP BY applicant*/
/*HAVING author IN (SELECT author
                  FROM book, get_avg_price 
                  WHERE price > avg_price
                 )
ORDER BY Стоимость DESC;*/

















<ANY означает меньше, чем максимум.
>ANY означает больше, чем минимум.
=ANY эквивалентно IN
>ALL означает больше, чем максимум
<ALL означает меньше, чем минимум


SELECT author, title, price, amount, ROUND(((price*amount)/(select sum(amount*price) from book))*100,2)as income_percent
FROM book
ORDER BY income_percent DESC;












SELECT title as Книга, author as Автор, price as Цена
FROM book
WHERE price > ANY(
                # минимальное среднее количество книг*/
                SELECT avg(avg_price)
                FROM (
                      # среднее количество книг каждого автора
                      SELECT author, min(price) AS avg_price
                      FROM book 
                      GROUP BY author
                      
                     ) query_in
                )
#ORDER BY title, price DESC;





/*SELECT author, title, price
FROM book
WHERE price < (
                # минимальное среднее количество книг
                *//*SELECT MIN(avg_price)
                FROM (
                      # среднее количество книг каждого автора*/
                      SELECT author, sum(price) AS avg_price
                      FROM book 
                      GROUP BY author
                     /*) query_in
                /*);*/











SELECT specialisation, position,
SUBSTRING_INDEX(GROUP_CONCAT(applicant ORDER BY experience DESC  SEPARATOR ";"), ";", 1) as Кандидат
FROM resume
GROUP BY position, specialisation
ORDER BY specialisation, position;



SELECT author as Автор, count(title) as Различных_книг,/* min(price) as Минимальная_цена, sum(amount) as Количество, count(amount) as ad*/
FROM book
GROUP BY author 
/*HAVING count(author) > 2*/





15

/*WITH for_first AS(
SELECT student_name AS Студент,
    step_id,result, submission_time,
    LEAD(result) OVER(PARTITION BY student_id, step_id ORDER BY submission_time) AS next_result
FROM student JOIN step_student USING(student_id)
),
for_two AS(
SELECT student_name  AS Студент, step_id
FROM student JOIN step_student USING(student_id)
WHERE result='correct'
GROUP BY student_name, step_id
HAVING COUNT(result)>1
),
for_three AS(
SELECT student_name AS Студент, step_id
FROM student JOIN step_student USING(student_id)
GROUP BY student_id, step_id
HAVING SUM( IF(result='correct', 1, 0) ) = 0
)


SELECT 'I' AS Группа , Студент, COUNT(DISTINCT step_id) AS Количество_шагов
FROM for_first
WHERE result='correct' AND next_result='wrong'
GROUP BY Студент

UNION ALL
SELECT  'II' AS Группа, Студент, COUNT(DISTINCT step_id) AS Количество_шагов
FROM for_two
GROUP BY Студент

UNION ALL
SELECT  'III' AS Группа, Студент, COUNT(DISTINCT step_id) AS Количество_шагов
FROM for_three
GROUP BY Студент

ORDER BY Группа, Количество_шагов DESC, Студент*/






/*SELECT title, SUM(query_in.Количество1) AS "Количество",  SUM(query_in.Сумма1) AS "Сумма"
FROM
(SELECT title, (buy_book.amount) AS "Количество1", (book.price*buy_book.amount) AS "Сумма1"
FROM book
INNER JOIN buy_book USING(book_id)
INNER JOIN buy USING(buy_id)
INNER JOIN buy_step USING(buy_id)
WHERE buy_step.date_step_end IS NOT NULL AND step_id=1
GROUP BY 1,2,3
UNION ALL
SELECT book.title, SUM(buy_archive.amount) AS "Количество1", (buy_archive.price*buy_archive.amount) AS "Сумма1"
FROM buy_archive
INNER JOIN book USING(book_id)
GROUP BY 1,3) AS query_in
GROUP BY query_in.title
ORDER BY 3 DESC*/


* включение нового клиента в базу данных;

INSERT INTO client(name_client, email, city_id)
VALUES ('Попов Илья', 'popov@test', 1);
SELECT * 
FROM client;

* формирование нового заказа некоторым пользователем;

INSERT INTO buy 
SET buy_description = 'Связаться со мной по вопросу доставки', client_id = (SELECT client_id FROM client
WHERE name_client = 'Попов Илья') ;
SELECT * FROM buy;

*включение в заказ одной или нескольких книг с указанием их количества;

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

* уменьшение количества книг на складе;

UPDATE book, buy_book 
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5 AND book.book_id = buy_book.book_id; 
SELECT * FROM book;

* создание счета на оплату (полный счет, итоговый счет);

CREATE TABLE buy_pay AS
SELECT title, name_author, price, buy_book.amount, book.price*buy_book.amount AS Стоимость
FROM buy_book
JOIN book ON book.book_id=buy_book.book_id
JOIN author ON author.author_id=book.author_id
WHERE buy_book.buy_id=5
ORDER BY book.title;
SELECT * FROM buy_pay;

* Оющий сет на оплату

CREATE TABLE buy_pay
SELECT buy_book.buy_id, SUM(buy_book.amount) as Количество,SUM(book.price*buy_book.amount)  as Итого
FROM buy_book
JOIN book USING(book_id)
WHERE buy_id=5
GROUP BY 1;
SELECT*FROM buy_pay;

* добавление этапов продвижения заказа;

insert into buy_step(step_id, buy_id)
select step_id, buy_id
from step cross join (select 5 as buy_id) as c;
select * from buy_step;

* фиксация дат прохождения каждого этапа заказа (начало этапа, завершение этапа).

UPDATE buy_step, step 
SET date_step_beg = '2020.04.12'
WHERE buy_id = 5 AND buy_step.step_id = (SELECT step_id FROM step WHERE name_step = "Оплата");

SELECT *
FROM buy_step
WHERE buy_id = 5;

* Добавление Времени в заказ

UPDATE buy_step, step 
SET date_step_beg = '2020.04.12'
WHERE buy_id = 5 AND buy_step.step_id = (SELECT step_id FROM step WHERE name_step = "Оплата");

SELECT *
FROM buy_step
WHERE buy_id = 5;


* Добавление времени покупки в заказ

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

* Сообщение покупателю

SELECT CONCAT(name_client, '! Извините, ', LCASE(name_step), ' вашего заказа задерживается :(') apologies
  FROM step
       JOIN buy_step USING(step_id)
       JOIN buy USING(buy_id)
       JOIN client USING(client_id)
 WHERE step_id > 1
   AND DATEDIFF(NOW(), date_step_beg) > 14
   AND date_step_end IS NULL;


* 
