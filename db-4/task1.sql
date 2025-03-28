WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT 
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName AS "Название отдела",
    r.RoleName AS "Название роли",
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS "Проекты",
    STRING_AGG(DISTINCT t.TaskName, ', ') AS "Задачи"
FROM Subordinates s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN Tasks t ON s.EmployeeID = t.AssignedTo
LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
GROUP BY s.EmployeeID, s.Name, s.ManagerID, d.DepartmentName, r.RoleName
ORDER BY s.Name;