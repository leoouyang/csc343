-- Committed

SET SEARCH_PATH TO parlgov;
drop table if exists q5 cascade;

-- You must not change this table definition.

CREATE TABLE q5(
        countryName VARCHAR(50),
        partyName VARCHAR(100),
        partyFamily VARCHAR(50),
        stateMarket REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)


-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS countryCabinet CASCADE;
create view countryCabinet
AS
select country_id, count(id) as cabinetNum
from cabinet
where extract(year from cabinet.start_date)>=1996 and extract(year from cabinet.start_date)<=2016
group by country_id;

DROP VIEW IF EXISTS partyCabinet CASCADE;
create view partyCabinet
AS
select party_id, country_id, count(cabinet_id) as cabinetNum
from cabinet_party left join cabinet on cabinet.id = cabinet_party.cabinet_id
where extract(year from cabinet.start_date)>=1996 and extract(year from cabinet.start_date)<=2016
group by party_id, country_id;

DROP VIEW IF EXISTS qualified CASCADE;
create view qualified
AS
select partyCabinet.party_id as partyID, partyCabinet.country_id as countryID
from partyCabinet left join countryCabinet on partyCabinet.country_id = countryCabinet.country_id
where partyCabinet.cabinetNum = countryCabinet.cabinetNum;


DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select country.name as countryName, party.name as partyName, family as partyFamily, state_market as stateMarket
from qualified
left join party on party.id = partyID
left join country on country.id = countryID
left join party_family on party_family.party_id = partyID
left join party_position on party_position.party_id = partyID;
-- the answer to the query 
insert into q5 select * from final_result;
