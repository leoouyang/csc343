--Students in the grade 8 class in room 120 with Mr Higgins
DROP VIEW IF EXISTS higginsStudent CASCADE;
create view higginsStudent
AS
select student.id as studentNumber, lastName 
from student
left join enrol on enrol.sID = student.id
left join course on enrol.cID = course.id
left join room on course.roomID = room.id
where room.roomName = 'room 120' and course.grade = 8;

--Responses for the quiz with id 'Pr1-220310'
DROP VIEW IF EXISTS ReleventResponse CASCADE;
create view ReleventResponse
AS
select response.sID as studentNumber, response, question.id as questionID, weight
from response 
join quizQuestion on response.quizQuestion = quizQuestion.id
join quiz on quiz.id = quizQuestion.quizID
join question on question.id = quizQuestion.questionID
where quiz.id='Pr1-220310';

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

--The responses that is correct from the ReleventResponse
DROP VIEW IF EXISTS correctResponse CASCADE;
create view correctResponse
AS
select ReleventResponse.studentNumber as studentNumber, weight
from ReleventResponse
left join QuestionAnswers on ReleventResponse.questionID = QuestionAnswers.questionID
where ReleventResponse.response = QuestionAnswers.answer;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select higginsStudent.studentNumber as studentNumber, lastName, sum(COALESCE(weight,0)) as score
from higginsStudent 
left join correctResponse on higginsStudent.studentNumber = correctResponse.studentNumber
group by higginsStudent.studentNumber, lastName;


select * from final_result;