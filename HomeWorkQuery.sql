


-- 8. Для своей группы выставить расписание на Базовый семестр, там где
--    одну неделю проходит 'Hardware-PC' либо 'Windows', 
--    следующую неделю проходит 'Процедурное программирование на языке C++';
-- 9. *Для стационарно группы (PD_212) выставить расписание на базовый семестр
--    по схеме 12-21
USE VPD_311_import;
--1
SELECT 
    DIR.direction_name, COUNT(DISTINCT GR.group_id) AS N'Колличество Групп', COUNT(DISTINCT ST.stud_id) AS N'Колличество Студентов'
FROM 
    "DisciplinesDirectionsRelation" AS DDR
    LEFT OUTER JOIN "Directions" AS DIR ON DDR.direction = DIR.direction_id
    LEFT OUTER JOIN "Groups" AS GR ON GR.direction = DIR.direction_id
    LEFT OUTER JOIN "Students" AS ST ON ST."group" = GR.group_id 
GROUP BY DIR.direction_name
--2
SELECT 
    DS.discipline_name AS 'Discipline Name', 
    COUNT(TH.teacher_id) AS 'Total Teachers'
FROM 
    "TeachersDisciplinesRelation" AS TDR
    INNER JOIN "Disciplines" AS DS ON TDR.discipline = DS.discipline_id
    INNER JOIN "Teachers" AS TH ON TDR.teacher = TH.teacher_id
GROUP BY DS.discipline_name
--3
SELECT 
    TH.first_name + ' ' + TH.middle_name + ' ' + TH.last_name AS 'Teachers',
    COUNT(DS.discipline_id) AS 'Total Discplines'
FROM 
    "TeachersDisciplinesRelation" AS TDR
    INNER JOIN "Teachers" AS TH ON TDR.teacher = TH.teacher_id
    INNER JOIN "Disciplines" AS DS ON TDR.discipline = DS.discipline_id
GROUP BY TH.first_name, TH.middle_name, TH.last_name
--4
SELECT 
    DIR.direction_name AS 'Direction',
    COUNT(DISTINCT teacher_id) AS 'Total Teachers'
FROM "DisciplinesDirectionsRelation" AS DDR
    INNER JOIN "Disciplines" AS DIS ON DDR.discipline = DIS.discipline_id
    INNER JOIN "TeachersDisciplinesRelation" AS TDR ON DIS.discipline_id = TDR.discipline -- Порядок изменен для ясности
    INNER JOIN "Teachers" AS TH ON TDR.teacher = TH.teacher_id
    INNER JOIN "Directions" AS DIR ON DDR.direction = DIR.direction_id
GROUP BY
    DIR.direction_name
--5
INSERT Students
    (last_name,
    first_name,
    middle_name,
    birth_date,
    [group])
VALUES(N'Deriugin', N'Evgenii', 'Evgenievich', N'1982-08-27', 11 ),
      (N'Kislykov', N'Dmitrii', N'Vichyslavovich', N'1982-08-27', 11)  
        --and so on
--6
SELECT
    DIR.direction_name AS 'Direction name',
    COUNT(DIS.number_of_lessons)
FROM
    "DisciplinesDirectionsRelation" AS DDR
    INNER JOIN "Directions" AS DIR ON DDR.direction = DIR.direction_id
    INNER JOIN "Disciplines" AS DIS ON DDR.discipline = DIS.discipline_id
GROUP BY DIR.direction_name;
--7
DECLARE
    @group_id AS INT = (SELECT 
                            group_id
                        FROM
                            "Groups"
                        WHERE
                            group_name IN('VPD_311')),
    @discipline_id  AS INT = (SELECT TOP 1
                                 discipline_id
                             FROM
                                 "Disciplines"
                             WHERE 
                                 discipline_name LIKE N'Теори%'),
    @teacher_id     AS  SMALLINT = (SELECT
                                        teacher_id
                                    FROM
                                        "Teachers"
                                    WHERE 
                                        first_name IN('Олег')),
    @start_date         AS  DATE,
    @number_of_lessons  AS  TINYINT,
    @date               AS  DATE,
    @time               AS  TIME(0) = N'08:00',
    @lesson_number      AS  TINYINT = 0

SET 
    @number_of_lessons = (          SELECT
                                        number_of_lessons
                                    FROM
                                        "Disciplines"
                                    WHERE
                                          discipline_id = @discipline_id)
SET
    @start_date =   N'2024-12-08'
SET 
    @date = @start_date    
SELECT 
    @group_id AS group_id,
    @discipline_id AS discipline_id,
    @number_of_lessons AS 'Number Of Lessons',
    @teacher_id AS 'Teacher ID',
    @start_date AS 'Start Date',
    @date AS 'Date',
    @time AS 'Time',
    @number_of_lessons AS 'Number Of Lessons',
    @lesson_number AS 'Lesson Number'
PRINT
    CAST(@group_id AS NVARCHAR(10)) + N' ' + 
    CAST(@discipline_id AS NVARCHAR(10)) + N' ' +
    CAST(@teacher_id AS NVARCHAR(10)) + N' ' +
    CAST(@teacher_id AS NVARCHAR(10)) + N' ' +
    CAST(@start_date AS NVARCHAR(10)) + N' ' +
    CAST(@date AS NVARCHAR(10)) + N' ' +
    CAST(@time AS NVARCHAR(10)) + N' ' +
    CAST(@number_of_lessons AS NVARCHAR(10)) + N' ' +
    CAST(@lesson_number AS NVARCHAR(10))


WHILE(@lesson_number < @number_of_lessons)
BEGIN
    IF DATEPART(WEEKDAY, @date) IN (2, 4, 6)
    BEGIN
        INSERT INTO "Schedule"
        (
            [group],
            discipline,
            teacher,
            [date],
            [time],
            spent
        )
        VALUES
        (
            @group_id,
            @discipline_id,
            @teacher_id,
            @date,
            @time,
            IIF(@date < GETDATE(), 1, 0)
        )
        SET
            @lesson_number = @lesson_number + 1;
        INSERT INTO "Schedule"
        (
            [group],
            discipline,
            teacher,
            [date],
            [time],
            spent
        )
        VALUES
        (
            @group_id,
            @discipline_id,
            @teacher_id,
            @date,
            DATEADD(MINUTE, 95, @time),
            IIF(@date < GETDATE(), 1, 0)
        )
        SET
            @lesson_number = @lesson_number + 1;
    END
    SET
        @date = DATEADD(DAY, 1, @date)
END;
--8





