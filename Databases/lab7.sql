-- ������� ������������� �� ������ ����� �� ������ --
-- ������� 6. --

-- ��� ����� ���������� ���� ������ ������� 6 (lab6)
use lab6;
go

if OBJECT_ID(N'AuthorView',N'V') is NOT NULL
	DROP VIEW AuthorView;
go

CREATE VIEW AuthorView AS
	SELECT *
	FROM Author
	WHERE date_of_birth BETWEEN 1800 AND 1900;
go

SELECT * FROM AuthorView
go

-- ������� ������������� �� ������ ����� ����� -- 
-- ��������� ������ ������� 6. --

if OBJECT_ID(N'PatientVisitView',N'V') is NOT NULL
	DROP VIEW PatientVisitView;
go

CREATE VIEW PatientVisitView AS
	SELECT p.name,p.gender,p.date_of_birth,
		   v.visit_date,v.visit_time,v.visit_reason
	FROM Patient as p INNER JOIN Visit as v ON p.patient_id = v.visit_patient
	-- WITH CHECK OPTION -- 
go

SELECT * FROM PatientVisitView
go

-- ������� ������ ��� ����� �� ������ ������� 6, --
-- ������� � ���� �������������� ���������� ����. --

IF EXISTS (SELECT * FROM sys.indexes  WHERE name = N'IX_Book_name')  
    DROP INDEX IX_Book_name ON Book;  
go
 
CREATE INDEX IX_Book_name   
    ON Book (name)
	INCLUDE (author,publish_year);
go

-- ������� ��������������� ������������� --

if OBJECT_ID(N'BookIndexView',N'V') is NOT NULL
	DROP VIEW BookIndexView;
go


CREATE VIEW BookIndexView 
WITH SCHEMABINDING 
AS
	SELECT author,name,genre,publish_year
	FROM dbo.Book
	WHERE publish_year > 1910;
go

IF EXISTS (SELECT * FROM sys.indexes  WHERE name = N'IX_Book_year')  
    DROP INDEX IX_Book_year ON Book;  
go

DROP INDEX IX_Book_name ON Book;
go 

CREATE INDEX IX_year  
    ON BookIndexView (publish_year);
go
CREATE UNIQUE CLUSTERED INDEX IX_Book_year  
    ON BookIndexView (name,publish_year);
go



SELECT * FROM BookIndexView
go






	 
