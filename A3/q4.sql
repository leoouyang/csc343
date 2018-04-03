--Students in the grade 8 class in room 120 with Mr Higgins
DROP VIEW IF EXISTS higginsStudent CASCADE;
create view higginsStudent
AS
select student.id as studentNumber
from student
left join enrol on enrol.sID = student.id
left join course on enrol.cID = course.id
left join room on course.roomID = room.id
where room.roomName = 'room 120' and course.grade = 8;

--All the questions for quiz with id 'Pr1-220310'
DROP VIEW IF EXISTS thisQuizQuestion CASCADE;
create view thisQuizQuestion
AS
select questionID
from quizQuestion
where quizID = 'Pr1-220310';

--set that represents the situation if every student in the class answered every question
DROP VIEW IF EXISTS shouldAnswer CASCADE;
create view shouldAnswer
AS
select studentNumber, questionID
from thisQuizQuestion cross join higginsStudent;

--set that represent who actually answered which question
DROP VIEW IF EXISTS answered CASCADE;
create view answered
AS
select sID as studentNumber, questionID
from response 
join quizQuestion on response.quizQuestion = quizQuestion.id
where quizID = 'Pr1-220310';

--Students and the question they did not answer
DROP VIEW IF EXISTS notAnswered CASCADE;
create view notAnswered
AS
select * from shouldAnswer 
except 
select * from answered;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select studentNumber, questionID, content as questionText
from notAnswered
left join question on questionID = question.id;

select * from final_result order by studentNumber;