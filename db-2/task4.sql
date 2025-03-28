WITH CarStats AS (
    SELECT 
        C.name AS car_name,
        C.class,
        CL.country,
        AVG(R.position) AS avg_position,
        COUNT(R.race) AS races_count,
        AVG(AVG(R.position)) OVER (PARTITION BY C.class) AS class_avg_position,
        COUNT(*) OVER (PARTITION BY C.class) AS cars_in_class
    FROM Cars C
    JOIN Results R ON C.name = R.car
    JOIN Classes CL ON C.class = CL.class
    GROUP BY C.name, C.class, CL.country
)
SELECT 
    car_name,
    class,
    avg_position,
    races_count,
    country
FROM CarStats
WHERE 
    avg_position < class_avg_position
    AND cars_in_class >= 2
ORDER BY 
    class ASC, 
    avg_position ASC;