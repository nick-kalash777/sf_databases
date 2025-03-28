WITH ClassStats AS (
    SELECT 
        CL.class,
        CL.country,
        AVG(R.position) AS class_avg_position,
        COUNT(DISTINCT R.race) AS total_races_for_class,
        RANK() OVER (ORDER BY AVG(R.position)) AS class_rank
    FROM Classes CL
    JOIN Cars C ON CL.class = C.class
    JOIN Results R ON C.name = R.car
    GROUP BY CL.class, CL.country
),
MinRankClasses AS (
    SELECT 
        class,
        country,
        class_avg_position,
        total_races_for_class
    FROM ClassStats
    WHERE class_rank = 1
)
SELECT 
    C.name AS car_name,
    M.class,
    ROUND(AVG(R.position), 2) AS car_avg_position,
    COUNT(R.race) AS car_races_count,
    M.country,
    M.total_races_for_class
FROM MinRankClasses M
JOIN Cars C ON M.class = C.class
JOIN Results R ON C.name = R.car
GROUP BY C.name, M.class, M.country, M.total_races_for_class
ORDER BY car_avg_position, car_name;