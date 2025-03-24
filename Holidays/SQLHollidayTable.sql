USE VPD_311_import;
GO

CREATE TABLE Holidays
(
    Month           INT             NOT NULL,
    Day             INT             NOT NULL,
    HolidayName     NVARCHAR(100)   NOT NULL,
    IsRecurring     BIT                         DEFAULT 1, -- Добавляем Флаг для повторяющихся праздников
    YearSpecific    INT             NOT NULL,
    CONSTRAINT PK_Holidays PRIMARY KEY (Month, Day, YearSpecific) --Первичные ключи
)