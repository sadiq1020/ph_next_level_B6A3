-- Queries Questions Solutions
-- Query 1: JOIN
  -- Retrieve booking information along with:
      -- Customer name
      -- Vehicle name

-- Concepts used: INNER JOIN

select booking_id, users.name as customer_name, vehicles.name as vehicle_name, start_date, end_date, bookings.status from bookings 
inner join users on bookings.user_id = users.user_id 
inner join vehicles on bookings.vehicle_id = vehicles.vehicle_id

-- Query 2: EXISTS
-- Find all vehicles that have never been booked.

-- Concepts used: NOT EXISTS

select * from vehicles
where not exists (
    select name from bookings 
    where bookings.vehicle_id = vehicles.vehicle_id
);

-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).

-- Concepts used: SELECT, WHERE

select * from vehicles
where type = 'car' and status = 'available';


-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

-- Concepts used: GROUP BY, HAVING, COUNT

select vehicles.name as vehicle_name, count(*) as total_bookings from bookings
join vehicles on bookings.vehicle_id = vehicles.vehicle_id 
group by vehicles.name having count(*) > 2;


