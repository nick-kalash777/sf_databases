WITH CarStats AS (
    SELECT 
        C.name AS car_name,
        CL.class,
        CL.country,
        AVG(R.position) AS avg_position,
        COUNT(R.race) AS races_count,
        ROW_NUMBER() OVER (ORDER BY AVG(R.position), C.name) AS rn
    FROM Cars C
    JOIN Results R ON C.name = R.car
    JOIN Classes CL ON C.class = CL.class
    GROUP BY C.name, CL.class, CL.country
)
SELECT 
    car_name,
    class,
    avg_position,
    races_count,
    country
FROM CarStats
WHERE rn = 1;