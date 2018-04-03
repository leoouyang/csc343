-- Sequences

SET SEARCH_PATH TO parlgov;
drop table if exists q6 cascade;

-- You must not change this table definition.

CREATE TABLE q6(
        countryName VARCHAR(50),
        cabinetId INT, 
        startDate DATE,
        endDate DATE,
        pmParty VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS WithEndDate CASCADE;
create view WithEndDate
AS
select main.country_id as countryId, main.id as cabinetId, main.start_date as startDate, later.start_date as endDate
from cabinet as main left join cabinet as later on later.previous_cabinet_id = main.id;

DROP VIEW IF EXISTS AddpmParty CASCADE;
create view AddpmParty
AS
select countryId, cabinetId, startDate, endDate, cabinet_party.party_id as pmPartyID
from WithEndDate 
left join cabinet_party on cabinetId = cabinet_party.cabinet_id and cabinet_party.pm = True;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select country.name as countryName, cabinetId, startDate, endDate, party.name as pmParty
from AddpmParty
left join country on country.id = countryId
left join party on party.id = pmPartyID;

-- the answer to the query 
insert into q6 select * from final_result;
