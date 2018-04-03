DROP VIEW IF EXISTS QuestionHint CASCADE;

--The view containes ID and number of hints for all question with at least one hint
create view QuestionWithHint 
AS
select qID, count(multiHint.id) as hintNum
from multiHint left join multiOptions on multiHint.oID = multiOptions.id
group by qID
UNION
select qID, count(numHint.id) as hintNum
from numHint
group by qID;


DROP VIEW IF EXISTS finalResult CASCADE;
create view finalResult
AS
select question.id as ID, question.content as text,
CASE
	when qType = 'True-False' then NULL
	when qType != 'True-False' and QuestionWithHint.hintNum is NULL then 0
	ELSE QuestionWithHint.hintNum
END as hintNum
from question left join QuestionWithHint on question.id = QuestionWithHint.qID;



select * from finalResult;