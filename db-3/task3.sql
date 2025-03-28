WITH HotelCategories AS (
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerPreferences AS (
    SELECT 
        c.ID_customer,
        c.name,
        COALESCE(
            MAX(CASE WHEN hc.hotel_category = 'Дорогой' THEN 3 
                     WHEN hc.hotel_category = 'Средний' THEN 2 
                     ELSE 1 END), 
            0
        ) AS priority,
        STRING_AGG(DISTINCT hc.hotel_name, ', ') AS visited_hotels
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel
    GROUP BY c.ID_customer, c.name
)
SELECT 
    cp.ID_customer,
    cp.name AS "name",
    CASE 
        WHEN cp.priority >= 3 THEN 'Дорогой'
        WHEN cp.priority = 2 THEN 'Средний'
        ELSE 'Дешевый'
    END AS "preferred_hotel_type",
    cp.visited_hotels AS "visited_hotels"
FROM CustomerPreferences cp
ORDER BY 
    CASE 
        WHEN cp.priority >= 3 THEN 3
        WHEN cp.priority = 2 THEN 2
        ELSE 1
    END,
    name;