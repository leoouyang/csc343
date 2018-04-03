-- VoteRange

SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
year INT,
countryName VARCHAR(50),
voteRange VARCHAR(20),
partyName VARCHAR(100)
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS TableAllInfo CASCADE;
create view TableAllInfo 
AS
select extract(YEAR from e_date) as year, country.name as countryName, party.name_short as partyName, votes_valid, election_result.votes as votes
from election_result
left join election on election_result.election_id = election.id
left join party on election_result.party_id = party.id
left join country on party.country_id = country.id
where votes_valid is not null and election_result.votes is not null;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result 
AS
select year, countryName, 
case
	when cast(sum(votes) as decimal)/sum(votes_valid)>0 and cast(sum(votes) as decimal)/sum(votes_valid)<=0.05 then '(0-5]'
	when cast(sum(votes) as decimal)/sum(votes_valid)>0.05 and cast(sum(votes) as decimal)/sum(votes_valid)<=0.1 then '(5-10]'
	when cast(sum(votes) as decimal)/sum(votes_valid)>0.1 and cast(sum(votes) as decimal)/sum(votes_valid)<=0.2 then '(10-20]'
	when cast(sum(votes) as decimal)/sum(votes_valid)>0.2 and cast(sum(votes) as decimal)/sum(votes_valid)<=0.3 then '(20-30]'
	when cast(sum(votes) as decimal)/sum(votes_valid)>0.3 and cast(sum(votes) as decimal)/sum(votes_valid)<=0.4 then '(30-40]'
	when cast(sum(votes) as decimal)/sum(votes_valid)>0.4 and cast(sum(votes) as decimal)/sum(votes_valid)<=1 then '(40-100]'
end as voteRange,partyName
from TableAllInfo
group by year, countryName, partyName;



-- the answer to the query 
insert into q1 select * from final_result;

