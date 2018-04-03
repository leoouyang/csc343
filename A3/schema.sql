--We can't enforce that there are at least two options for an multiple choice question
--I choose to not enforce only a student in the class that was assigned a quiz can answer questions on that quiz because I would have to store redundency in order to achieve that. Also, this can be easily done in the client side with, for example, a log in validation before letting anyone answering the questions.
drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

CREATE TABLE student(
  id char(10) primary key,
  firstName VARCHAR(20) NOT NULL,
  lastName VARCHAR(20) NOT NULL
);

--Each of the classrooms and the teacher that using this classroom
CREATE TABLE room(
  id serial primary key,
  roomName VARCHAR(20) NOT NULL unique,
  teacher VARCHAR(50) NOT NULL
);

--the class that is taught in a specific class room and a grade. There can't be two course with same grade using same classroom
CREATE TABLE course(
  id serial primary key,
  roomID int references room(id),
  grade int not null,
  unique(roomID, grade)
);

--stores which student is enrolled in which classes
CREATE TABLE enrol(
  sID char(10) references student(id),
  cID int references course(id),
  primary key(sID, cID)
);

CREATE TYPE question_type AS ENUM(
	'True-False', 'Multiple-choice', 'Numeric');
	
CREATE TABLE question(
  id serial primary key,
  content VARCHAR(250) NOT NULL,
  qType question_type NOT NULL
);

--the options for multiple choices
CREATE TABLE multiOptions(
  id serial primary key,
  qID int references question(id),
  choice VARCHAR(250) NOT NULL
);

CREATE TABLE multiAnswer(
  id serial primary key,
  qID int references question(id) unique,
  answer INT references multiOptions(id)
);

--the answer is stored as 'True' or 'False'
CREATE TABLE tfAnswer(
  id serial primary key,
  qID int references question(id) unique,
  answer varchar(5) CHECK (answer IN ('True', 'False'))
);

CREATE TABLE numAnswer(
  id serial primary key,
  qID int references question(id) unique,
  answer INT NOT NULL
);

--the hints for multiple choices options
CREATE TABLE multiHint(
  id serial primary key,
  oID INT references multiOptions(id),
  hint VARCHAR(250) NOT NULL
);

--the hints for numeric questions
CREATE TABLE numHint(
  id serial primary key,
  qID INT references question(id),
  lowerbound INT not null,
  upperbound INT not null,
  hint VARCHAR(250) NOT NULL
);

--each quiz can only be assigned to a single class. Another course can have same quiz but they need to use a different id for the quiz
CREATE TABLE quiz(
  id varchar(20) primary key,
  title VARCHAR(250) not NULL,
  due TIMESTAMP not NULL,
  course int references course(id),
  hintFlag BOOLEAN NOT NULL
);

--the relation store a question and its associated quiz and its weight 
CREATE TABLE quizQuestion(
  id serial primary key,
  quizID varchar(20) references quiz(id),
  questionID INT references question(id),
  weight int NOT NULL,
  unique(quizID, questionID)
);

--student response for the questions. Expect True-False question answers to be either "True" or "False"
CREATE TABLE response(
  id serial primary key,
  sID char(10) references student(id),
  quizQuestion INT references quizQuestion(id),
  response VARCHAR(250) NOT NULL
);
