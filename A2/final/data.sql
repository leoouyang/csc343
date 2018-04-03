INSERT INTO student(id, firstName, lastName)
VALUES
('0998801234', 'Lena', 'Headey'),
('0010784522', 'Peter', 'Dinklage'),
('0997733991', 'Emilia', 'Clarke'),
('5555555555', 'Kit', 'Harrington'),
('1111111111', 'Sophie', 'Turner'),
('2222222222', 'Maisie', 'Williams');

INSERT INTO room(id, roomName, teacher)
VALUES
(1, 'room 120', 'Mr Higgins'),
(2, 'room 366', 'Miss Nyers');

INSERT INTO course(id, roomID, grade)
VALUES
(1, 1, 8),
(2, 2, 5);

INSERT INTO enrol(sID, cID)
VALUES
('0998801234', 1),
('0010784522', 1),
('0997733991', 1),
('5555555555', 1),
('1111111111', 1),
('2222222222', 2);

INSERT INTO question(id, content, qType)
VALUES
(782, 'What do you promise when you take the oath of citizenship?', 'Multiple-choice'),
(566, 'The Prime Minister, Justin Trudeau, is Canada''s Head of State.', 'True-False'),
(601, 'During the "Quiet Revolution," Quebec experienced rapid change. In what decade did this occur? (Enter the year that began the decade, e.g., 1840.)', 'Numeric'),
(625, 'What is the Underground Railroad?', 'Multiple-choice'),
(790, 'During the War of 1812 the Americans burned down the Parliament Buildings in York (now Toronto). What did the British and Canadians do in return?', 'Multiple-choice');

INSERT INTO multiOptions(id, qID, choice)
VALUES
(1, 782, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II'),
(2, 782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian'),
(3, 782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian'),
(4, 782, 'To pledge your loyalty to Canada from sea to sea'),
(5, 625, 'The first railway to cross Canada'),
(6, 625, 'The CPR''s secret railway line'),
(7, 625, 'The TTC subway system'),
(8, 625, 'A network used by slaves who escaped the United States into Canada'),
(9, 790, 'They attacked American merchant ships'),
(10, 790, 'They expanded their defence system, including Fort York'),
(11, 790, 'They burned down the White House in Washington D.C.'),
(12, 790, 'They captured Niagara Falls');

INSERT INTO multiAnswer(qID, answer)
VALUES
(782, 1),
(625, 8),
(790, 11);

INSERT INTO tfAnswer(qID, answer)
VALUES
(566, 'False');

INSERT INTO numAnswer(qID, answer)
VALUES
(601, 1960);

INSERT INTO multiHint(oID, hint)
VALUES
(3, 'Think regally.'),
(5, 'The Underground Railroad was generally south to north, not east-west.'),
(6, 'The Underground Railroad was secret, but it had nothing to do with trains.'),
(7, 'The TTC is relatively recent; the Underground Railroad was in operation over 100 years ago.');

INSERT INTO numHint(qID, lowerbound, upperbound, hint)
VALUES
(601, 1800, 1900, 'The Quiet Revolution happened during the 20th Century.'),
(601, 2000, 2010, 'The Quiet Revolution happened some time ago.'),
(601, 2020, 3000, 'The Quiet Revolution has already happened!');


INSERT INTO quiz(id, title, due, course, hintFlag)
VALUES
('Pr1-220310', 'Citizenship Test Practise Questions', '2017-10-01 13:30:00', 1, TRUE);

INSERT INTO quizQuestion(id, quizID, questionID, weight)
VALUES
(1, 'Pr1-220310', 601, 2),
(2, 'Pr1-220310', 566, 1),
(3, 'Pr1-220310', 790, 3),
(4, 'Pr1-220310', 625, 2);

INSERT INTO response(sID, quizQuestion, response)
VALUES
('0998801234', 1, '1950'),
('0998801234', 2, 'False'),
('0998801234', 3, 'They expanded their defence system, including Fort York'),
('0998801234', 4, 'A network used by slaves who escaped the United States into Canada'),
('0010784522', 1, '1960'),
('0010784522', 2, 'False'),
('0010784522', 3, 'They burned down the White House in Washington D.C.'),
('0010784522', 4, 'A network used by slaves who escaped the United States into Canada'),
('0997733991', 1, '1960'),
('0997733991', 2, 'True'),
('0997733991', 3, 'They burned down the White House in Washington D.C.'),
('0997733991', 4, 'The CPR''s secret railway line'),
('5555555555', 2, 'False'),
('5555555555', 3, 'They captured Niagara Falls');