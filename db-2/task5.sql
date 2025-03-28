WITH CarAverages AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
LowPositionCars AS (
    SELECT 
        car_name,
        car_class,
        average_position,
        race_count
    FROM CarAverages
    WHERE average_position > 3.0
),
ClassRaceCounts AS (
    SELECT 
        c.class AS car_class,
        COUNT(DISTINCT r.race) AS total_race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
),
ClassLowPositionCounts AS (
    SELECT 
        car_class,
        COUNT(car_name) AS low_position_count
    FROM LowPositionCars
    GROUP BY car_class
)
SELECT 
    lpc.car_name,
    lpc.car_class,
    ROUND(lpc.average_position, 4) AS average_position,
    lpc.race_count,
    cl.country AS country,
    crc.total_race_count,
    clpc.low_position_count
FROM LowPositionCars lpc
JOIN ClassLowPositionCounts clpc ON lpc.car_class = clpc.car_class
JOIN Classes cl ON lpc.car_class = cl.class
JOIN ClassRaceCounts crc ON lpc.car_class = crc.car_class
ORDER BY 
    clpc.low_position_count DESC,
    lpc.average_position DESC;