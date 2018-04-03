-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS InfoView CASCADE;
DROP VIEW IF EXISTS OneElection CASCADE;
DROP VIEW IF EXISTS NotAccending CASCADE;
DROP VIEW IF EXISTS Accending CASCADE;
DROP VIEW IF EXISTS final_result CASCADE;

create view InfoView as
	select country_id, country.name as countryName, extract(Year from e_date) as year, avg(cast(votes_cast as decimal)/electorate) as participationRatio
	from election left join country on election.country_id = country.id
	group by country_id, extract(Year from e_date), country.name
	having 2001 < extract(Year from e_date) and extract(Year from e_date) <= 2016;

create view OneElection as
	select distinct country_id
	from InfoView;

create view NotAccending as
	select i1.country_id
	from InfoView as i1
	join InfoView as i2 on i1.country_id = i2.country_id and i1.participationRatio < i2.participationRatio and i1.year > i2.year;
	
create view Accending as
	select * from OneElection 
	EXCEPT 
	select * from NotAccending;

create view final_result as
Select countryName, year, participationRatio
from Accending join InfoView on Accending.country_id = InfoView.country_id;
	
-- the answer to the query 
insert into q3 select * from final_result;