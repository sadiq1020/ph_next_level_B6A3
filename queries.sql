-- Create a new Database
create database "Vehicle Rental System";

-- create tables
-- 1. create users table
CREATE TABLE
  users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL, 
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Customer')) 
  ) 

-- 2. create vehicles table
CREATE TABLE
  vehicles (
  vehicle_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL, 
  type VARCHAR(20) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
  model VARCHAR(30) NOT NULL,
  registration_number VARCHAR(50) UNIQUE NOT NULL,
  rental_price INT NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('available', 'rented', 'maintenance')) DEFAULT 'available'
  )

-- 3. create bookings table
CREATE TABLE
  bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users (user_id),
  vehicle_id INT REFERENCES vehicles (vehicle_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  total_cost NUMERIC(10,2) NOT NULL
  )

------------------------------------------- 
-- insert data into users
INSERT INTO users (name, email, phone, role) VALUES
('Alice', 'alice@example.com', '1234567890', 'Customer'),
('Bob', 'bob@example.com', '0987654321', 'Admin'),
('Charlie', 'charlie@example.com', '1122334455', 'Customer'),
('David', 'david@example.com', '5566778899', 'Customer'),
('Eve', 'eve@example.com', '9988776655', 'Admin'),
('Frank', 'frank@example.com', '4433221100', 'Customer'),
('Grace', 'grace@example.com', '1231231234', 'Customer'),
('Heidi', 'heidi@example.com', '3213214321', 'Customer'),
('Ivan', 'ivan@example.com', '5556667777', 'Customer'),
('Judy', 'judy@example.com', '8889990000', 'Customer');

-- insert data into vehicles
INSERT INTO vehicles (name, type, model, registration_number, rental_price, status) VALUES
('Toyota Corolla', 'car', '2022', 'ABC-123', 50, 'available'),
('Honda Civic', 'car', '2021', 'DEF-456', 60, 'rented'),
('Yamaha R15', 'bike', '2023', 'GHI-789', 30, 'available'),
('Ford F-150', 'truck', '2020', 'JKL-012', 100, 'maintenance'),
('Tesla Model 3', 'car', '2023', 'MNO-345', 120, 'available'),
('Suzuki Gixxer', 'bike', '2022', 'PQR-678', 25, 'available'),
('Chevrolet Silverado', 'truck', '2021', 'STU-901', 110, 'available'),
('Hyundai Elantra', 'car', '2022', 'VWX-234', 55, 'available'),
('Kawasaki Ninja', 'bike', '2021', 'YZA-567', 45, 'available'),
('Ram 1500', 'truck', '2023', 'BCD-890', 105, 'rented');

-- insert data into bookings
INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, status, total_cost) VALUES
(1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
(1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
(3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
(1, 1, '2023-12-10', '2023-12-12', 'pending', 100),
(4, 5, '2024-01-05', '2024-01-10', 'completed', 600),
(6, 3, '2024-01-15', '2024-01-16', 'completed', 30),
(7, 7, '2024-02-01', '2024-02-04', 'confirmed', 330),
(8, 8, '2024-02-10', '2024-02-15', 'completed', 275),
(9, 6, '2024-03-01', '2024-03-02', 'cancelled', 25),
(10, 10, '2024-03-10', '2024-03-15', 'pending', 525);

-------------------------------------------

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


