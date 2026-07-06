CREATE DATABASE Football_Ticket_Booking_System


-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
   
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name varchar(100),
    email varchar(150) UNIQUE,
    role varchar(20) CHECK (role IN ('Ticket Manager', 'Football Fan')),
    phone_number varchar(14)
);


-- =========================================================================
-- 2. CREATE Matches TABLE
-- =========================================================================

CREATE TABLE Matches (
    match_id serial PRIMARY KEY,
    fixture varchar(150) NOT NULL,
    tournament_category varchar(150) NOT NULL,
    base_ticket_price decimal(10, 2) NOT NULL CHECK (base_ticket_price >= 0),
    match_status varchar(20) NOT NULL CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);


-- =========================================================================
-- 3. CREATE Bookings TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id serial PRIMARY KEY,
    user_id int NOT NULL REFERENCES Users (user_id),
    match_id int NOT NULL REFERENCES Matches (match_id),
    seat_number varchar(50),
    payment_status varchar(20) CHECK (
        payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    ),
    total_cost decimal(10, 2) NOT NULL CHECK (total_cost >= 0)
);



-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);


-- Query 1: Retrieve all upcoming football matches in the Champions League
-- where the match status is 'Available'.
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM
    matches
WHERE
    tournament_category = 'Champions League'
    AND match_status = 'Available'


-- Query 2: Search for users whose full names start with 'Tanvir'
-- or contain the phrase 'Haque' (case-insensitive).

SELECT
    user_id,
    full_name,
    email
FROM
    Users
WHERE
    full_name ILIKE 'Tanvir%'
    OR full_name ILIKE '%Haque%';

