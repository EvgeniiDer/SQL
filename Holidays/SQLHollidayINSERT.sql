DELETE FROM "Holidays";


INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
VALUES (2, 23, '23 февраля', 1, NULL, NULL);

-- 8 Марта (Международный женский день) - Recurring
INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
VALUES (3, 8, '8 марта', 1, NULL, NULL);

-- 2. Новогодние каникулы (2 недели, с 1 января) - Recurring (требует скрипта, потому что не один день)

-- 3. Майские праздники (10 дней, начиная с 1 мая) - Recurring (требует скрипта, потому что не один день)

-- 4. Летние каникулы (последняя неделя июля и первая неделя августа) - Recurring (требует скрипта)

-- 5. Пасха (3 дня) - вычисляемый праздник (требует функции и скрипт



-- (2) Скрипт для заполнения таблыицы Holidays (Новогодние, Майские, Летние, Пасха)

DECLARE @StartYear INT = YEAR(GETDATE()) -- Текущий год
DECLARE @EndYear INT = @StartYear + 5  -- Заполняем на 5 лет вперед

WHILE @StartYear <= @EndYear
BEGIN
    -- Новогодние каникулы (14 дней)
    DECLARE @NewYearDate DATE = DATEFROMPARTS(@StartYear, 1, 1);
    DECLARE @NewYearCounter INT = 0;
    WHILE @NewYearCounter < 14
    BEGIN
        INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
        VALUES (MONTH(DATEADD(day, @NewYearCounter, @NewYearDate)), DAY(DATEADD(day, @NewYearCounter, @NewYearDate)), 'Новый Год', 0, @StartYear, NULL);
        SET @NewYearCounter = @NewYearCounter + 1;
    END;

    -- Майские праздники (10 дней)
    DECLARE @MayFirstDate DATE = DATEFROMPARTS(@StartYear, 5, 1)
    DECLARE @MayCounter INT = 0
    WHILE @MayCounter < 10
    BEGIN
        INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
        VALUES (MONTH(DATEADD(day, @MayCounter, @MayFirstDate)), DAY(DATEADD(day, @MayCounter, @MayFirstDate)), 'Майские праздники', 0, @StartYear, NULL)
        SET @MayCounter = @MayCounter + 1
    END

    -- Летние каникулы (последняя неделя июля и первая неделя августа)
    DECLARE @JulyLastWeekStart DATE = DATEFROMPARTS(@StartYear, 7, 25) -- Предполагаем, что последняя неделя июля начинается с 25 числа
    DECLARE @SummerCounter INT = 0;
    WHILE @SummerCounter < 14
    BEGIN
        INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
        VALUES (MONTH(DATEADD(day, @SummerCounter, @JulyLastWeekStart)), DAY(DATEADD(day, @SummerCounter, @JulyLastWeekStart)), 'Летние праздники', 0, @StartYear, NULL);
        SET @SummerCounter = @SummerCounter + 1;
    END

    -- Пасха (3 дня)
    DECLARE @EasterDate DATE = dbo.CalculateEasterDate(@StartYear);
    DECLARE @EasterCounter INT = -1; -- Начинаем с дня до Пасхи, чтобы захватить 3 дня
    WHILE @EasterCounter < 2
    BEGIN
        INSERT INTO Holidays (Month, Day, HolidayName, IsRecurring, YearSpecific, CalculationRule)
        VALUES (MONTH(DATEADD(day, @EasterCounter, @EasterDate)), DAY(DATEADD(day, @EasterCounter, @EasterDate)), 'Easter Holiday', 0, @StartYear, 'Calculated using dbo.CalculateEasterDate()');
        SET @EasterCounter = @EasterCounter + 1;
    END

    SET @StartYear = @StartYear + 1;
END;
GO


--DELETE FROM Holidays;