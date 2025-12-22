# Vehicle Rental System - Database Design & SQL Queries

## Overview

This project implements a comprehensive database solution for a **Vehicle Rental System** that manages users, vehicles, and booking operations. The system is designed to handle real-world scenarios including customer registrations, vehicle inventory management, and rental booking workflows.

The database supports multiple user roles, tracks vehicle availability in real-time, and maintains a complete history of all rental transactions with their current status.

## Database Schema

The system consists of three core tables with the following relationships:

### 1. Users Table
Stores information about all system users including both customers and administrators.

**Columns:**
- `user_id` (SERIAL PRIMARY KEY) - Unique identifier for each user
- `name` (VARCHAR(50)) - User's full name
- `email` (VARCHAR(100) UNIQUE) - User's email address (must be unique)
- `phone` (VARCHAR(20)) - Contact phone number
- `role` (VARCHAR(20)) - User role (either 'Admin' or 'Customer')

### 2. Vehicles Table
Maintains the complete inventory of available vehicles for rent.

**Columns:**
- `vehicle_id` (SERIAL PRIMARY KEY) - Unique identifier for each vehicle
- `name` (VARCHAR(50)) - Vehicle name/brand
- `type` (VARCHAR(20)) - Vehicle type ('car', 'bike', or 'truck')
- `model` (VARCHAR(30)) - Vehicle model year/version
- `registration_number` (VARCHAR(50) UNIQUE) - Unique registration plate number
- `rental_price` (INT) - Daily rental price
- `status` (VARCHAR(20)) - Current availability status ('available', 'rented', or 'maintenance')

### 3. Bookings Table
Records all rental bookings and their transaction details.

**Columns:**
- `booking_id` (SERIAL PRIMARY KEY) - Unique identifier for each booking
- `user_id` (INT REFERENCES users) - Foreign key linking to the customer
- `vehicle_id` (INT REFERENCES vehicles) - Foreign key linking to the rented vehicle
- `start_date` (DATE) - Rental start date
- `end_date` (DATE) - Rental end date
- `status` (VARCHAR(20)) - Booking status ('pending', 'confirmed', 'completed', or 'cancelled')
- `total_cost` (NUMERIC(10,2)) - Total rental cost for the booking period

## Entity Relationships

- **Users → Bookings**: One-to-Many relationship (one user can make multiple bookings)
- **Vehicles → Bookings**: One-to-Many relationship (one vehicle can have multiple bookings over time)
- **Each Booking**: Links exactly one user to one vehicle for a specific time period

## Sample Data

The database includes sample data for demonstration and testing purposes:
- **10 users** (mix of customers and administrators)
- **10 vehicles** (cars, bikes, and trucks with varying availability)
- **10 bookings** (representing different booking scenarios and statuses)

## SQL Queries Explained

### Query 1: JOIN - Retrieve Booking Information with Customer and Vehicle Details

**Purpose:** Display comprehensive booking information including customer names and vehicle names for easy reference.

**Concepts Used:** INNER JOIN

**Query:**
```sql
SELECT booking_id, users.name AS customer_name, vehicles.name AS vehicle_name, 
       start_date, end_date, bookings.status 
FROM bookings 
INNER JOIN users ON bookings.user_id = users.user_id 
INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;
```

**Explanation:**
- Joins three tables (bookings, users, vehicles) to consolidate related information
- Uses INNER JOIN to match bookings with corresponding user and vehicle records
- Returns only bookings that have valid user and vehicle references
- Provides a complete view of each booking with human-readable customer and vehicle names

---

### Query 2: EXISTS - Find Vehicles That Have Never Been Booked

**Purpose:** Identify vehicles in the inventory that have no booking history, useful for analyzing vehicle utilization and identifying underperforming assets.

**Concepts Used:** NOT EXISTS, Subquery

**Query:**
```sql
SELECT * FROM vehicles
WHERE NOT EXISTS (
    SELECT name FROM bookings 
    WHERE bookings.vehicle_id = vehicles.vehicle_id
);
```

**Explanation:**
- Uses NOT EXISTS to find vehicles without any matching records in the bookings table
- The subquery checks for any booking entries associated with each vehicle
- Returns vehicles that have never been rented (no matching vehicle_id in bookings)
- Helps identify new inventory or vehicles that may need marketing attention

---

### Query 3: WHERE - Retrieve Available Vehicles of a Specific Type

**Purpose:** Filter vehicles based on type and availability status, commonly used for customer-facing search functionality.

**Concepts Used:** SELECT, WHERE, AND clause

**Query:**
```sql
SELECT * FROM vehicles
WHERE type = 'car' AND status = 'available';
```

**Explanation:**
- Applies multiple filter conditions using the WHERE clause
- Filters by vehicle type (in this example, 'car') and availability status ('available')
- Returns only vehicles that match both conditions
- This query pattern can be easily modified to search for 'bike' or 'truck' types
- Essential for showing customers only the vehicles they can currently rent

---

### Query 4: GROUP BY and HAVING - Find Popular Vehicles

**Purpose:** Identify vehicles with high booking frequency (more than 2 bookings) to analyze demand patterns and popular inventory.

**Concepts Used:** GROUP BY, HAVING, COUNT, JOIN

**Query:**
```sql
SELECT vehicles.name AS vehicle_name, COUNT(*) AS total_bookings 
FROM bookings
JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id 
GROUP BY vehicles.name 
HAVING COUNT(*) > 2;
```

**Explanation:**
- Groups booking records by vehicle name using GROUP BY
- Counts the number of bookings for each vehicle using COUNT(*)
- The HAVING clause filters the grouped results to show only vehicles with more than 2 bookings
- Different from WHERE: HAVING filters aggregated data after grouping, while WHERE filters rows before grouping
- Useful for identifying high-demand vehicles that may need additional inventory or pricing optimization

---

## Use Cases

This database system supports various real-world scenarios:

1. **Customer Management** - Track customer information and rental history
2. **Inventory Management** - Monitor vehicle availability and maintenance schedules
3. **Booking Operations** - Process reservations and track rental periods
4. **Business Analytics** - Analyze popular vehicles, revenue patterns, and customer behavior
5. **Admin Functions** - Manage users, vehicles, and oversee all booking operations

## Technologies Used

- **Database:** PostgreSQL
- **SQL Concepts:** Table creation, constraints, foreign keys, JOINs, subqueries, aggregate functions

## Setup Instructions

1. Create the database:
   ```sql
   CREATE DATABASE "Vehicle Rental System";
   ```

2. Run the SQL script:
   - Execute the queries in `queries.sql` to create tables and populate sample data

3. Test the queries:
   - Run each of the four sample queries to verify database functionality

---

**Project Type:** Database Design & SQL Practice  
**Focus Areas:** ERD Design, SQL Queries, Database Relationships  
**Difficulty Level:** Beginner to Intermediate
