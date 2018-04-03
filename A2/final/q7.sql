-- Alliances

SET SEARCH_PATH TO parlgov;
drop table if exists q7 cascade;

-- You must not change this table definition.

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7(
        countryId INT, 
        alliedPartyId1 INT, 
        alliedPartyId2 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS memberHead CASCADE;
create view memberHead
AS
select e1.election_id as electionID, e1.party_id as memberID,
case
	when e1.alliance_id is null then e1.party_id
	when e1.alliance_id is not null then e2.party_id
END as headID
from election_result as e1 left join election_result as e2 on e1.alliance_id = e2.id;

DROP VIEW IF EXISTS allies CASCADE;
create view allies
AS
select m1.memberID as alliedPartyId1, m2.memberID as alliedPartyId2, m1.electionID as electionID
from memberHead as m1 join memberHead as m2 on m1.electionID = m2.electionID 
where m1.headID = m2.headID and m1.memberID < m2.memberID;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select e1.country_id as countryId, alliedPartyId1, alliedPartyId2
from allies left join election as e1 on allies.electionID = e1.id
group by alliedPartyId1, alliedPartyId2, country_id
having count(electionID) > 0.3 * (
	select count(e2.id)
	from election as e2
	group by country_id
	having e1.country_id = e2.country_id
);


-- the answer to the query 
insert into q7 select * from final_result;
