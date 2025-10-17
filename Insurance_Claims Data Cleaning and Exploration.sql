select * from insurance_claims

--Data Cleaning

select policy_number, count(policy_number)
from insurance_claims
group by policy_number
having count(policy_number) > 1

select policy_number, ROW_NUMBER() over
(partition by policy_number order by policy_number)
from insurance_claims

select policy_bind_date, convert(date, policy_bind_date)
from insurance_claims

update insurance_claims
set policy_bind_date = convert(date, policy_bind_date)

select policy_bind_date
from insurance_claims

Alter Table insurance_claims
Add PolicyBindDate date

update insurance_claims
set PolicyBindDate = convert(date, policy_bind_date) 

Select PolicyBindDate from insurance_claims

Alter Table insurance_claims
Add IncidentDate date

update insurance_claims
set IncidentDate = convert(date, incident_date) 

select IncidentDate from insurance_claims

select DATEDIFF(month, PolicyBindDate, IncidentDate)
from insurance_claims

Alter Table insurance_claims
Add Policy_age_timeOfIncident INT

Update insurance_claims
set Policy_age_timeOfIncident = DATEDIFF(month, PolicyBindDate, IncidentDate)

select Policy_age_timeOfIncident
from insurance_claims

select police_report_available, count(police_report_available)
from insurance_claims
group by police_report_available

select collision_type,
case when collision_type = '?' then 'Unknown'
     else collision_type
	 end
from insurance_claims

Update insurance_claims
set collision_type =
case when collision_type = '?' then 'Unknown'
     else collision_type
	 end

	 select property_damage,
case when property_damage = '?' then 'Unknown'
     else property_damage
	 end
from insurance_claims

Update insurance_claims
set property_damage =
case when property_damage = '?' then 'Unknown'
     else property_damage
	 end

Update insurance_claims
set police_report_available =
case when police_report_available = '?' then 'Unknown'
     else police_report_available
	 end

select policy_number, incident_date, ROW_NUMBER() over
(partition by policy_number, incident_date order by policy_number)
from insurance_claims

select * from insurance_claims

select injury_claim/cast(total_claim_amount as float) as Ratio_Of_InjuryClaim_To_TotalClaim
from insurance_claims 

Alter Table insurance_claims
add Ratio_Of_InjuryClaim_To_TotalClaim Float

update insurance_claims
set Ratio_Of_InjuryClaim_To_TotalClaim = injury_claim/cast(total_claim_amount as float)

Alter Table insurance_claims
add Ratio_Of_PropertyClaim_To_TotalClaim Float

update insurance_claims
set Ratio_Of_PropertyClaim_To_TotalClaim = property_claim/cast(total_claim_amount as float)

Alter Table insurance_claims
add Ratio_Of_VehicleClaim_To_TotalClaim Float

update insurance_claims
set Ratio_Of_VehicleClaim_To_TotalClaim  = vehicle_claim/cast(total_claim_amount as float)

update insurance_claims
set Ratio_Of_InjuryClaim_To_TotalClaim = cast(Ratio_Of_InjuryClaim_To_TotalClaim as decimal (4,2))

update insurance_claims
set Ratio_Of_PropertyClaim_To_TotalClaim = cast(Ratio_Of_PropertyClaim_To_TotalClaim as decimal (4,2))

update insurance_claims
set Ratio_Of_VehicleClaim_To_TotalClaim  = cast(Ratio_Of_VehicleClaim_To_TotalClaim as decimal (4,2))





--Data Exploration

select months_as_customer
from insurance_claims
where fraud_reported = 'Y'

-- Fraud Rate by State

select incident_state, count(*) as Total_Claims,
sum(case when fraud_reported = 'Y' then 1 else 0 end) as Fraud_Cases,
round(100.0 * sum(case when fraud_reported = 'Y' then 1 else 0 end)/count(*), 2) as Fraud_Rate
from insurance_claims
group by incident_state
order by Fraud_Rate desc


--Average Claim by Incident Type

select incident_type, round(avg(total_claim_amount), 2) as Avg_ClaimAmount
from insurance_claims
group by incident_type
order by Avg_ClaimAmount desc

--Suspicious Patterns (Hgh Claim + No Police Report)

select policy_number, incident_type, total_claim_amount, police_report_available 
from insurance_claims
where police_report_available = 'N'
and total_claim_amount > 20000

--Top 10 Occupations with Highest Fraud Rate

select top 10 insured_occupation, count(*) as Total_Claims,
round(100.0* sum(case when fraud_reported = 'Y' then 1 else 0 end)/count(*),2) as fraud_rate
from insurance_claims
group by insured_occupation
having count(*) > 50
order by fraud_rate desc




