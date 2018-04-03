-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS ViewAllInfo CASCADE;
create view ViewAllInfo 
AS
select party.id as party_id, country.id as countryID, party_position.left_right as position
from party
left join country on country.id = party.country_id
left join party_position on party_position.party_id = party.id;

DROP VIEW IF EXISTS pos0_2 CASCADE;
create view pos0_2
AS
select countryID, count(party_id) as num
from ViewAllInfo
where ViewAllInfo.position >= 0 and ViewAllInfo.position < 2
group by countryID;

DROP VIEW IF EXISTS pos2_4 CASCADE;
create view pos2_4
AS
select countryID, count(party_id) as num
from ViewAllInfo
where ViewAllInfo.position >= 2 and ViewAllInfo.position < 4
group by countryID;

DROP VIEW IF EXISTS pos4_6 CASCADE;
create view pos4_6
AS
select countryID, count(party_id) as num
from ViewAllInfo
where ViewAllInfo.position >= 4 and ViewAllInfo.position < 6
group by countryID;

DROP VIEW IF EXISTS pos6_8 CASCADE;
create view pos6_8
AS
select countryID, count(party_id) as num
from ViewAllInfo
where ViewAllInfo.position >= 6 and ViewAllInfo.position < 8
group by countryID;

DROP VIEW IF EXISTS pos8_10 CASCADE;
create view pos8_10
AS
select countryID, count(party_id) as num
from ViewAllInfo
where ViewAllInfo.position >= 8 and ViewAllInfo.position <= 10
group by countryID;

DROP VIEW IF EXISTS final_result CASCADE;
create view final_result
AS
select country.name as countryName, pos0_2.num as r0_2, pos2_4.num as r2_4, pos4_6.num as r4_6, pos6_8.num as r6_8, pos8_10.num as r8_10
from country
left join pos0_2 on pos0_2.countryID = country.id
left join pos2_4 on pos2_4.countryID = country.id
left join pos4_6 on pos4_6.countryID = country.id
left join pos6_8 on pos6_8.countryID = country.id
left join pos8_10 on pos8_10.countryID = country.id;


-- the answer to the query 
INSERT INTO q4 select * from final_result;

