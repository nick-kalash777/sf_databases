WITH ClientBookings AS (
    SELECT 
        c.ID_customer,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS total_hotels,
        SUM(r.price) AS total_spent
    FROM 
        Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer
    HAVING 
        COUNT(b.ID_booking) > 2 
        AND COUNT(DISTINCT h.ID_hotel) >= 2
),

RichClients AS (
    SELECT 
        c.ID_customer,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM 
        Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY c.ID_customer
    HAVING SUM(r.price * (b.check_out_date - b.check_in_date)) > 500
)

SELECT 
    f.ID_customer,
    c.name AS "Имя",
    f.total_bookings AS "Общее количество бронирований",
    f.total_spent AS "Общая сумма",
    f.total_hotels AS "Уникальных отелей"
FROM 
    ClientBookings f
JOIN RichClients s ON f.ID_customer = s.ID_customer
JOIN Customer c ON f.ID_customer = c.ID_customer
ORDER BY 
    "Общая сумма" ASC;