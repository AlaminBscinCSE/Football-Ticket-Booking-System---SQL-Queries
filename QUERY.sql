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
    Matches
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

-- Query 3: Retrieve all booking records where the payment status is NULL
-- and display 'Action Required' instead of NULL using COALESCE().
SELECT
    booking_id,
    user_id,
    match_id,
    coalesce(payment_status, 'Action Required') AS systematic_status
FROM
    Bookings
WHERE
    payment_status IS NULL

-- Query 4: Retrieve match booking details along with the user's full name
-- and the scheduled match fixture teams using INNER JOIN.

SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM
    Bookings AS b
INNER JOIN
    Users AS u
    ON b.user_id = u.user_id
INNER JOIN
    Matches AS m
    ON b.match_id = m.match_id; 

-- Query 5: Display all users and their booking IDs,
-- including users who have never purchased a ticket using LEFT JOIN.
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM
    Users AS u
LEFT JOIN
    Bookings AS b
    ON u.user_id = b.user_id;

-- Query 6: Find all ticket bookings where the total cost is
-- greater than the average total cost of all bookings using a subquery.

SELECT
    booking_id,
    match_id,
    total_cost
FROM
    Bookings
WHERE
    total_cost > (
        SELECT
            AVG(total_cost)
        FROM
            Bookings
    ); 

-- Query 7: Retrieve the top 2 most expensive matches,
-- skipping the highest-priced match using ORDER BY, OFFSET, and LIMIT.

SELECT
    match_id,
    fixture,
    base_ticket_price
FROM
    Matches
ORDER BY
    base_ticket_price DESC
LIMIT 2
OFFSET 1;