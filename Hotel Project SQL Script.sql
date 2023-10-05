use theap44a_hotel;
show tables;
-- Explore tables
select * from hotel2018;
select * from hotel2019;
select * from hotel2020;
select * from market_segment;
select * from meal_cost;

-- Query 1
-- Is hotel revenue increasing year on year?   
 
   -- Hotel's Revenue of 3 years
   select arrival_date_year as Year, round(sum(((adults+children)* 
   meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)
   +(stays_in_weekend_nights + stays_in_week_nights)*adr)-
    ((((adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)
    +(stays_in_weekend_nights + stays_in_week_nights)*adr)) 
	* market_segment.discount))) as Yearwise_Total_Revenue from hotel2018 inner join market_segment
   on hotel2018.market_segment= market_segment.market_segment inner join meal_cost 
   on meal_cost.meal = hotel2018.meal where is_canceled=0 union
   
      select arrival_date_year, round(sum(((adults+children)* 
      meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)
   +(stays_in_weekend_nights + stays_in_week_nights)*adr)-
    ((((adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)
    +(stays_in_weekend_nights + stays_in_week_nights)*adr)) 
	* market_segment.discount))) as revenue2019 from hotel2019 inner join market_segment
   on hotel2019.market_segment= market_segment.market_segment inner join meal_cost 
   on meal_cost.meal = hotel2019.meal where is_canceled=0 union
   
   select arrival_date_year, round(sum(((adults+children)* meal_cost.cost*
   (stays_in_weekend_nights + stays_in_week_nights)
   +(stays_in_weekend_nights + stays_in_week_nights)*daily_room_rate)-
    ((((adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)
    +(stays_in_weekend_nights + stays_in_week_nights)*daily_room_rate)) 
	* market_segment.discount))) as revenue2020 from hotel2020 inner join market_segment
   on hotel2020.market_segment= market_segment.market_segment inner join meal_cost 
   on meal_cost.meal = hotel2020.meal where is_canceled=0;
  -- ****************************************************************************************** -- 
   -- Query 2
   -- What market segment are major contributors of the revenue per year? 
   -- Is there a change year on year?
   
 select * from(select hotel2018.arrival_date_year as Year,hotel2018.market_segment as Market_Segment,
 round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)-
    ((((stays_in_weekend_nights + stays_in_week_nights)*adr)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)) 
	* market_segment.discount))) as Total_Revenue from hotel2018 inner join market_segment
	on hotel2018.market_segment= market_segment.market_segment inner join meal_cost 
    on meal_cost.meal = hotel2018.meal where is_canceled=0 group by 2
    order by 3 ) as Revenue_2018_By_Mkt_Seg union
    
    select * from(select hotel2019.arrival_date_year as Year ,hotel2019.market_segment as Market_segment,
    round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)-
    ((((stays_in_weekend_nights + stays_in_week_nights)*adr)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)) 
	* market_segment.discount))) as Revenue_19 from hotel2019 inner join market_segment
	on hotel2019.market_segment= market_segment.market_segment inner join meal_cost 
    on meal_cost.meal = hotel2019.meal where is_canceled=0 group by 2
    order by  3 ) as Revenue_2019_By_Mkt_Seg union 
    
    select * from (select hotel2020.arrival_date_year as Year,hotel2020.market_segment as Market_Segment,
    round(sum(((stays_in_weekend_nights + stays_in_week_nights)*daily_room_rate)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)-
    ((((stays_in_weekend_nights + stays_in_week_nights)*daily_room_rate)+   
	(adults+children)* meal_cost.cost*(stays_in_weekend_nights + stays_in_week_nights)) 
	* market_segment.discount))) as Revenue_20 from hotel2020 inner join market_segment
	on hotel2020.market_segment= market_segment.market_segment inner join meal_cost 
    on meal_cost.meal = hotel2020.meal where is_canceled=0 group by 2
    order by 3 ) as Revenue_2020_By_Mkt_Seg; 
   
-- ************************************************************************************--
-- Query 3
-- When is the hotel at maximum occupancy? Is the period consistent across the years?

select * from (select arrival_date_year,arrival_date_month,count(*) as  Highest_occupancy_Count
 from hotel2018 where is_canceled=0 
group by arrival_date_month order by 2 desc limit 2) as Highest_occupancy_In_Month_Of union  
select * from(select arrival_date_year,arrival_date_month,count(*) from hotel2019 where is_canceled=0 
group by arrival_date_month order by 2 desc limit 2) as Highest_occupancy_In_Month_Of union 
select * from (select arrival_date_year,arrival_date_month,count(*) from hotel2020 where is_canceled=0 
group by arrival_date_month order by 2 desc limit 2) as Highest_occupancy_In_Month_Of; 
 
-- *********************************************************************************** --
-- Query 4
-- When are people cancelling the most?
select * from (select arrival_date_year as Year,arrival_date_month as Month,count(*) as No_Of_Canceled_Booking 
from hotel2018 where is_canceled=1 
group by 2 order by 3 desc limit 2) as Canceled_2018 union
select * from(select arrival_date_year as Year,arrival_date_month as Month,count(*) as No_Of_Canceled_Booking 
from hotel2019 where is_canceled=1 
group by 2 order by 3 desc limit 2) as Canceled_2019 union
select * from (select arrival_date_year as Year,arrival_date_month as Month,count(*) as No_Of_Canceled_Booking 
from hotel2020 where is_canceled=1
group by 2 order by 3 desc limit 2) as Canceled_2020;

-- ************************************************************************************** --
-- Query 5
-- Are families with kids more likely to cancel the hotel booking?
select * from (select arrival_date_year as Year, count(*) as Non_Family, 
  (select count(*) from hotel2018 where is_canceled=1 AND babies+children!=0)
  as Family from hotel2018 where is_canceled=1 AND babies+children=0)
  as Cancelation_2018 union
 
 select * from(select arrival_date_year as Year, count(*) as Cancelations_No_Baby, 
  (select count(*) from hotel2019 where is_canceled=1 AND babies+children!=0)
  as Cancelation_with_Baby from hotel2019 where is_canceled=1 AND babies+children=0) as Cancelation_2019  union
 
 select * from(select arrival_date_year as Year, count(*) as Cancelations_No_Baby, 
  (select count(*) from hotel2020 where is_canceled=1 AND babies+children!=0)
  as Cancelation_with_Baby from hotel2020 where is_canceled=1 AND babies+children=0) as Cancelation_2020 ;
 
