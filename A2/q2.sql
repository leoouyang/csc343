-- Winners

SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS WinnerAllInfo CASCADE;
create view WinnerAllInfo 
AS
select election_id, party_id, party.country_id as country_id, e_date
from election_result as e1
left join party on e1.party_id = party.id
left join election on e1.election_id = election.id
where votes = (
	select max(votes)
	from election_result as e2
	group by election_id
	having e2.election_id = e1.election_id
);

DROP VIEW IF EXISTS WinCounts CASCADE;
create view WinCounts 
AS
select party_id, count(election_id) as wonElections, country_id
from WinnerAllInfo
group by party_id, country_id;

DROP VIEW IF EXISTS QualifiedParties CASCADE;
create view QualifiedParties
AS
select party_id, wonElections
from WinCounts as w1
where w1.wonElections >= 3 * (
	select cast(sum(w2.wonElections) as decimal)
	from WinCounts as w2
	group by w2.country_id
	having w2.country_id = w1.country_id
)/(
	select count(*)
	from party
	group by party.country_id
	having party.country_id = w1.country_id
);

DROP VIEW IF EXISTS LatestElectionWon CASCADE;
create view LatestElectionWon
AS
select w1.party_id as party_id, w1.election_id as mostRecentlyWonElectionId, extract(year from w1.e_date) as mostRecentlyWonElectionYear
from WinnerAllInfo w1
where w1.e_date=(
	select max(e_date)
	from WinnerAllInfo w2
	group by w2.party_id
	having w1.party_id = w2.party_id
);

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select country.name as countryName, party.name as partyName, party_family.family as partyFamily, wonElections, mostRecentlyWonElectionId, mostRecentlyWonElectionYear
from QualifiedParties 
left join party on QualifiedParties.party_id = party.id
left join country on country.id = party.country_id
left join party_family on party_family.party_id = QualifiedParties.party_id
left join LatestElectionWon on LatestElectionWon.party_id = QualifiedParties.party_id;
-- the answer to the query

insert into q2 select * from final_result;
