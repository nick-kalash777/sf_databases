SELECT 
    c.name AS "Имя",
    c.email AS "Электронная почта",
    c.phone AS "Телефон",
    COUNT(b.ID_booking) AS "Общее количество бронирований",
    STRING_AGG(DISTINCT h.name, ', ') AS "Отели",
    ROUND(AVG(b.check_out_date - b.check_in_date), 1) AS "Средняя длительность (дней)"
FROM 
    Customer c
JOIN 
    Booking b ON c.ID_customer = b.ID_customer
JOIN 
    Room r ON b.ID_room = r.ID_room
JOIN 
    Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY 
    c.ID_customer, c.name, c.email, c.phone
HAVING 
    COUNT(b.ID_booking) > 2 
    AND COUNT(DISTINCT h.ID_hotel) >= 2
ORDER BY 
    "Общее количество бронирований" DESC;