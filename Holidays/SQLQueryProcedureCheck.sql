ALTER PROCEDURE sp_SetScheduleForSemistacionarWithHollidays

    @group_name AS NVARCHAR(10),
    @discipline_name AS NVARCHAR(150),
    @teacher_last_name AS NVARCHAR(50),
    @start_date AS DATE,
    @start_time AS TIME,
    @day AS TINYINT
AS
BEGIN
    DECLARE
        @group_id AS INT,
        @discipline_id AS SMALLINT,
        @teacher_id AS SMALLINT,
        @current_date AS DATE,
        @time AS TIME,
        @spend AS BIT,
        @number_of_lessons AS TINYINT,
        @number_count AS TINYINT = 0,
        @date_increment AS INT = 7
    SET
        @group_id = dbo.GETGROUPIDHOMEWORK(@group_name)
    SET
        @discipline_id = dbo.GETDISCIPLINEIDHOMEWORK(@discipline_name)
    SET
        @teacher_id = dbo.GETTEACHERIDHOMEWORK(@teacher_last_name)
    SET
        @current_date = @start_date
    SET
        @time = @start_time
    SET
        @number_of_lessons = dbo.GETNUMBEROFLESSONSHOMEWORK(@discipline_name)
SELECT
    @group_id AS 'Group ID',
    @discipline_id AS 'Discipline ID',
    @teacher_id AS 'Teacher ID',
    @current_date AS 'Date',
    @time AS 'Time',
    @number_of_lessons AS 'Total Number Of Lessons'

    WHILE(@number_count < @number_of_lessons)
        BEGIN
         IF NOT EXISTS (SELECT 1 FROM Holidays WHERE
            (IsRecurring = 1 AND MONTH(@current_date) = MONTH AND DAY(@current_date) = DAY)
            OR
            (IsRecurring = 0 AND YEARSPECIFIC = YEAR(@current_date) AND MONTH(@current_date) = MONTH AND DAY(@current_date) = DAY))
                BEGIN
                    EXECUTE dbo.sp_InsertLessonToSchedule @group_id, @discipline_id, @teacher_id, @current_date, @time
                    SET @number_count = @number_count + 1
                    SET @time = DATEADD(MINUTE, 95, @time)
                    EXECUTE dbo.sp_InsertLessonToSchedule @group_id, @discipline_id, @teacher_id, @current_date, @time
                    SET @time = DATEADD(MINUTE, 190, @time);
                END
        SET @current_date = DATEADD(day, @date_increment, @current_date);
        END
END