create database project_chicago_crime_analyser;

use project_chicago_crime_analyser;

select count(*) from processed_crime_data;

drop table processed_crime_data;


-- Insight 1 --> Analyze the monthly distribution of crimes for the year. 
select Crime_occured_year as year, Crime_occured_month as month, count(*) as Total_Crimes
from processed_crime_data
group by Crime_occured_year,Crime_occured_month
order by Crime_occured_year,Crime_occured_month;  -- file saved as 'monthly_distribution_crime'


-- Insight 2 --> Most common crime types in the year.
select Crime_occured_year as year, Primary_Type as Crime_Type, count(*) as Crime_Count
from processed_crime_data
group by Crime_occured_year, Primary_Type
order by Crime_occured_year, Crime_Count desc;  -- file saved as 'common_crime_year'


-- Insight 3 --> Percentage of crimes resulting in arrests for each crime type in a year
select Crime_occured_year as Year, Primary_Type as Crime_Type, count(case when Arrest = True then 1 end) as Arrest_Count, count(*) as Total_Crimes, round((count(case when Arrest = True then 1 end) * 100.0) / count(*), 2) as Arrest_Percentage
from processed_crime_data
group by Crime_occured_year, Primary_Type
order by Crime_occured_year, Arrest_Percentage desc;  -- file saved as 'arrest_percentage_by_year'


-- Insight 4 --> Compare crime frequencies across seasons in a year
select Season, Crime_occured_year as year, count(*) AS Crime_Count
from processed_crime_data
group by Season, Crime_occured_year
order by Season, Crime_occured_year;   -- file saved as 'season_crime_all_year'


-- Insight 5 --> Wards with the highest number of reported crimes ( top 10 )
with RankedCrimes as (
    select Crime_occured_year as year, Ward, count(*) as Crime_Count, rank() over (partition by Crime_occured_year order by count(*) desc) as Crime_Rank
    from processed_crime_data
    where Ward != -1
    group by Crime_occured_year, Ward
)
select year, Ward, Crime_Count
from RankedCrimes
where Crime_Rank <= 10
order by year, Crime_Rank;  -- file saved as 'top_crime_ward'


-- Insight 6 --> Locations with the most reported crimes of all years
with RankedLocation as (
    select Crime_occured_year as year, Location_Description, count(*) as Crime_Count, rank() over (partition by Crime_occured_year order by count(*) desc) as Crime_Rank
    from processed_crime_data
    group by Crime_occured_year, Location_Description
)
select year, Location_Description, Crime_Count
from RankedLocation
where Crime_Rank <= 10
order by year, Crime_Rank;  -- file saved as 'top_crime_location'


-- Insight 7 --> Analyze crime frequency across different times of day (morning, afternoon, evening, night).
select Crime_occured_year as year, Crime_occured_timeperiod as Time_of_Day, count(*) as Crime_Count
from processed_crime_data
group by Crime_occured_year, Crime_occured_timeperiod
order by Crime_occured_year, Crime_Count desc;  -- file saved as 'crime_on_time_of_day'


-- Insight 8 -->  Distribution of crimes by severity based on FBI codes on all year.
select Crime_occured_year as year, FBI_Code, count(*) as Crime_Count
from processed_crime_data
group by Crime_occured_year, FBI_Code
order by Crime_occured_year, Crime_Count desc;  -- file saved as 'severity_by_FBI_codes'


-- Insight 9 --> Top crime types in the most affected community areas of all years
with CrimeCounts as (
    select Crime_occured_year as year, Community_Area, Primary_Type, count(*) AS Crime_Count
    from processed_crime_data
    where Community_Area != -1 
    group by Crime_occured_year, Community_Area, Primary_Type
)
select c.Year, c.Community_Area, c.Primary_Type, c.Crime_Count
from CrimeCounts c
join (
    select year, Community_Area, max(Crime_Count) as Max_Crime_Count
    from CrimeCounts
    group by year, Community_Area
) t on c.Year = t.Year and c.Community_Area = t.Community_Area and c.Crime_Count = t.Max_Crime_Count
order by c.Community_Area, c.year;   -- file saved as 'crime_by_community_area'


-- Insight 10 --> Track which Crime Type showed the most improvement or decline in arrest rates during the first and last year.
with ArrestRates as (
    select Crime_occured_year as year, Primary_Type, sum(case when Arrest = True then 1 else 0 end) as Arrest_Count, count(*) as Total_Crime_Count,
        sum(case when Arrest = True then 1 else 0 end) / count(*) * 100 as Arrest_Rate
    from processed_crime_data
    group by Crime_occured_year, Primary_Type
),
MinMaxYears as (
    select min(year) as MinYear, max(year) AS MaxYear
    from ArrestRates
),
RateComparison as (
    select a.Primary_Type, min(case when a.year = m.MinYear then a.Arrest_Rate end) as First_Year_Rate, max(case when a.year = m.MaxYear then a.Arrest_Rate end) as Last_Year_Rate, m.MinYear as First_Year, m.MaxYear as Last_Year
    from ArrestRates a
    cross join MinMaxYears m
    where a.year in (m.MinYear, m.MaxYear)
    group by a.Primary_Type, m.MinYear, m.MaxYear
)
select Primary_Type, First_Year, First_Year_Rate, Last_Year, Last_Year_Rate, (Last_Year_Rate - First_Year_Rate) as Rate_Change,
    case 
        when (Last_Year_Rate - First_Year_Rate) > 0 then 'Improved'
        when (Last_Year_Rate - First_Year_Rate) < 0 then 'Declined'
        else 'No Change'
    end as Status
from RateComparison
order by Rate_Change desc;  -- file saved as 'arrest_improvement_status'


-- Insight 11 --> Evaluate the arrest success rate of different police beats of all year
with ArrestRates as (
    select Beat, Crime_occured_year as year, sum(case when Arrest = True then 1 else 0 end) as Arrest_Count, count(*) as Total_Crime_Count, sum(case when Arrest = True then 1 else 0 end) / count(*) * 100 as Arrest_Success_Rate
    from processed_crime_data
    group by Beat, Crime_occured_year
)
select year, Beat, Arrest_Count, Total_Crime_Count, round(Arrest_Success_Rate, 2) as Arrest_Success_Rate
from ArrestRates
order by year, Arrest_Success_Rate desc;  -- file saved as 'beat_arrest_rate'


-- Insight 12 --> Top 3 locations that reported multiple crimes of the same type of all year.
with CrimeCounts as (
    select Location_Description, Primary_Type, Crime_occured_year as year, count(*) as Crime_Count
    from processed_crime_data
    group by Location_Description, Primary_Type, Crime_occured_year
    having count(*) > 1
),
AggregatedCounts as (
    select year, Location_Description, sum(Crime_Count) as Total_Crime_Count
    from CrimeCounts
    group by year, Location_Description
),
RankedLocations as (
    select year, Location_Description, Total_Crime_Count, rank() over (partition by year order by Total_Crime_Count desc) as Crime_Rank
    from AggregatedCounts
)
select year, Location_Description, Total_Crime_Count
from RankedLocations
where Crime_Rank <=3  -- where Crime_Rank <= 3 if top N wanted else top 1 means use where Crime_Rank = 1
order by year;  -- file saved as 'multiple_crime_location_top3'

-- Insight 13 --> blocks reported the highest number of crimes in all year.
with CrimeCounts as (
    select Crime_occured_year AS year, Block, count(*) as Total_Crime_Count
    from processed_crime_data
    group by Crime_occured_year, Block
),
RankedBlocks as (
    select year, Block, Total_Crime_Count, rank() over (partition by year order by Total_Crime_Count desc) as Crime_Rank
    from CrimeCounts
)
select year, Block, Total_Crime_Count
from RankedBlocks
where Crime_Rank = 1
order by year;  -- file saved as 'highest_crimes_block'


-- Insight 14 --> Determine how arrest rates fluctuate across different seasons of all year.
with SeasonCrimeStats as (
    select Season, Crime_occured_year as year, count(*) as Total_Crimes, sum(case when Arrest = True then 1 else 0 end) as Total_Arrests
    from processed_crime_data
    group by Season, Crime_occured_year
)
select Season, year, Total_Crimes, Total_Arrests, round((Total_Arrests * 100.0 / Total_Crimes), 2) as Arrest_Rate
from SeasonCrimeStats
order by year, Season;   -- file saved as 'arrest_rate_across_season'


-- Insight 15 --> Analyze how the number of domestic-related crimes has changed over the years compared to non-domestic crimes
with CrimeTypeCounts as (
    select Crime_occured_year as year, Domestic, count(*) as Crime_Count
    from processed_crime_data
    group by Crime_occured_year, Domestic
),
PivotedCrimeCounts as (
    select year, sum(case when Domestic = True then Crime_Count else 0 end) as Domestic_Crimes, sum(case when Domestic = False then Crime_Count else 0 end) as Non_Domestic_Crimes
    from CrimeTypeCounts
    group by year
)
select year, Domestic_Crimes, Non_Domestic_Crimes, round((Domestic_Crimes * 100.0 / (Domestic_Crimes + Non_Domestic_Crimes)), 2) as Domestic_Percentage, round((Non_Domestic_Crimes * 100.0 / (Domestic_Crimes + Non_Domestic_Crimes)), 2) as Non_Domestic_Percentage
from PivotedCrimeCounts
order by year;  -- file saved as 'domestic_crime_percentage'

-- Insight 16 --> areas with the highest crime density over the years
select Crime_occured_year as Crime_Year, round(Latitude, 4) as Lat, round(Longitude, 4) as Lng, count(*) AS Crime_Count
from processed_crime_data
where Latitude is not null and Longitude is not null
group by Crime_Year, Lat, Lng
order by Crime_Year, Crime_Count desc;   -- file saved as 'highest_crime_location'



