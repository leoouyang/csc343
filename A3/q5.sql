--the total number of students in grade 8 class in room 120 with Mr Higgins
DROP VIEW IF EXISTS higginsStudentNum CASCADE;
create view higginsStudentNum
AS
select count(student.id) as studentNum
from student
left join enrol on enrol.sID = student.id
left join course on enrol.cID = course.id
left join room on course.roomID = room.id
where room.roomName = 'room 120' and course.grade = 8;

--The answers for all the questions casted to varchar
DROP VIEW IF EXISTS QuestionAnswers CASCADE;
create view QuestionAnswers
AS
select multiAnswer.qID as questionID, multiOptions.choice as answer
from multiAnswer 
join multiOptions on multiAnswer.answer = multiOptions.id
UNION
select qID as questionID, CAST (answer as varchar(20)) as answer
from numAnswer
UNION
select qID as questionID, answer
from tfAnswer;

--each question for quiz 'Pr1-220310' with a correct answer count and a wrong answer count
DROP VIEW IF EXISTS correctWrong CASCADE;
create view correctWrong
AS
select quizQuestion.questionID as questionID, sum(case when response=answer then 1 else 0 end) as correct, sum(case when response is not NULL and response!=answer then 1 else 0 end) wrong
from quizQuestion
left join response on response.quizQuestion = quizQuestion.id
left join QuestionAnswers on quizQuestion.questionID = QuestionAnswers.questionID
where quizID='Pr1-220310'
group by quizQuestion.questionID;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select questionID, correct, wrong, studentNum-correct-wrong as notAnswered
from correctWrong
cross join higginsStudentNum;

select * from final_result order by questionID;

