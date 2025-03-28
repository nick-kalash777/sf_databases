WITH CarStats AS (
    SELECT 
        C.class,
        C.name AS car_name,
        AVG(R.position) AS avg_position,
        COUNT(R.race) AS races_count,
        RANK() OVER (PARTITION BY C.class ORDER BY AVG(R.position)) AS rank
    FROM Cars C
    JOIN Results R ON C.name = R.car
    GROUP BY C.class, C.name
)
SELECT 
    car_name,
    class,
    avg_position,
    races_count
FROM CarStats
WHERE rank = 1
ORDER BY avg_position, car_name;