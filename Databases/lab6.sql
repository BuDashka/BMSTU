use master;
go
if DB_ID (N'lab6') is not null
drop database lab6;
go
create database lab6
on (
NAME = lab6dat,
FILENAME = 'C:\Databases\DB6\lab6dat.mdf',
SIZE = 10,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5
)
log on (
NAME = lab6log,
FILENAME = 'C:\Databases\DB6\lab6log.ldf',
SIZE = 5,
MAXSIZE = 20,
FILEGROWTH = 5
);
go 

use lab6;
go 
if OBJECT_ID(N'Author',N'U') is NOT NULL
	DROP TABLE Author;
go


-- ������� ������� � ���������������� ��������� ������.
-- �������� ����, ��� ������� ������������ ����������� (CHECK), �������� �� ��������� (DEFAULT).

CREATE TABLE Author (
	author_id int IDENTITY(1,1) PRIMARY KEY,
	surname nchar(30) NOT NULL,
	name nchar(30) NOT NULL,
	date_of_birth numeric(4) NULL CHECK (date_of_birth>1500 AND date_of_birth<2000),
	date_of_death numeric(4) NULL CHECK (date_of_death>1500 AND date_of_death<2000), 
	biography nvarchar(1000) DEFAULT ('Unknown'),
	CONSTRAINT checkAuthor CHECK (date_of_birth<date_of_death)
	);
go

INSERT INTO Author(name,surname,date_of_birth,date_of_death)
VALUES (N'������',N'����', 1947, NULL),
	   (N'�������',N'�������',1962, NULL),
	   (N'������',N'�����',1969,NULL),
	   (N'�����',N'����� ����', 1859, 1930),
	   (N'������',N'�������', 1812, 1870),
	   (N'�����',N'������', 1854, 1900),
	   (N'������',N'�� ����-��������', 1900, 1944)
	   --  ��������� ������ --
	   -- ,(N'���',N'��������', 1920, 2012)--
	   -- ,(N'�����������',N'�����', 1989, 1986) --
go

SELECT * FROM Author
go
print 'go-go-go'
go
waitfor delay '00:00:15'
print ('q1: ' + cast(IDENT_CURRENT('dbo.Author') as nvarchar(3)))
print ('q1(scope): ' + cast(SCOPE_IDENTITY() as nvarchar(3)))

-- �������� ������������� SCOPE_IDENTITY() --
SELECT IDENT_CURRENT('dbo.Author') as last_id
go 

/* DELETE FROM Author
WHERE date_of_birth < 1900
go

INSERT INTO Author(name,surname,date_of_birth,date_of_death)
VALUES (N'�������',N'�����', 1896, 1940)

SELECT * FROM Author
go */


-- ������� ������� � ��������� ������ �� ������ ����������� ����������� ��������������

if OBJECT_ID(N'Book',N'U') is NOT NULL
	DROP TABLE Book;
go

CREATE TABLE Book (
	book_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWID()),
	author nchar(50) NOT NULL,
	name nchar(50) NOT NULL,
	genre nchar(20) NOT NULL CHECK (genre IN (N'�����',N'������� ����������',N'�����',N'��������',
											N'�������', N'������',N'������', N'����������', N'�����')),
	publish_year numeric(4) NOT NULL CHECK (publish_year>1500 AND publish_year<2000),
	publish_house varchar(100) NULL DEFAULT ('Unknown'),
	cost_of smallmoney NULL CHECK (cost_of > 0),
	);
go

INSERT INTO Book(author,name,genre,publish_year)
-- ��� ��������� ������������ ����������� �������������� -- 
-- OUTPUT inserted.book_id -- 
VALUES (N'��������� ������',N'������� ������', N'�����', 1831),
	   (N'���� ����',N'20 000 ��� ��� �����',N'������� ����������', 1916),
	   (N'����� ������',N'�������� ������� �������',N'��������',1926),
	   (N'������ ����',N'1408', N'�������', 1926),
	   (N'������ ���������',N'1408', N'������', 1936),
	   (N'������ ����',N'������� �����', N'�����', 1910)
go
INSERT INTO Book(book_id,author,name,genre,publish_year)
-- ��� ��������� ������������ ����������� �������������� -- 
-- OUTPUT inserted.book_id -- 
VALUES ('294B4012-1617-482A-8058-F73039852768',N'��������� ������',N'������� ������', N'�����', 1831)

SELECT * FROM Book
go


-- ������� ������� � ��������� ������ �� ������ ������������������
IF EXISTS (SELECT * FROM sys.sequences WHERE NAME = N'TestSequence' AND TYPE='SO')
DROP SEQUENCE TestSequence
go

CREATE SEQUENCE TestSequence
	START WITH 0
	INCREMENT BY 1
	MAXVALUE 10;
go

if OBJECT_ID(N'ArrayList',N'U') is NOT NULL
	DROP TABLE List;
go

CREATE TABLE ArrayList (
	element_id int PRIMARY KEY NOT NULL,
	element nchar(50) DEFAULT (N'�������'),
	);
go

INSERT INTO ArrayList(element_id,element)
VALUES (NEXT VALUE FOR DBO.TestSequence,N'������'),
	   (NEXT VALUE FOR DBO.TestSequence,N'������'),
	   (NEXT VALUE FOR DBO.TestSequence,N'�������'),
	   (NEXT VALUE FOR DBO.TestSequence,N'������'),
	   (NEXT VALUE FOR DBO.TestSequence,N'������')
go

SELECT * From ArrayList
go


-- ������� ��� ��������� �������, � �������������� �� ��� ��������� �������� �������� --
-- ��� ����������� ��������� ����������� (NO ACTION| CASCADE | SET NULL | SET DEFAULT). --
if OBJECT_ID(N'FK_Patient',N'F') IS NOT NULL
	ALTER TABLE Visit DROP CONSTRAINT FK_Patient
go

if OBJECT_ID(N'Patient',N'U') is NOT NULL
	DROP TABLE Patient;
go
	
CREATE TABLE Patient (
	patient_id int PRIMARY KEY NOT NULL,
	number_patient_card int NULL,
	name nchar(50) NOT NULL,
	gender nchar(1) CHECK (gender IN (N'�',N'�')),
	date_of_birth datetime NULL
	);
go

INSERT INTO Patient(patient_id,name,gender)
VALUES (1,N'������ ����������',N'�'),
	   (2,N'���� ������',N'�'),
	   (3,N'��������� �������',N'�'),
	   (4,N'�������� ����������',N'�'),
	   (5,N'�������� ������',N'�'),
	   (6,N'������ �������',N'�'),
	   (7,N'�������� ����������',N'�')
go

SELECT * FROM Patient
go

if OBJECT_ID(N'Visit',N'U') is NOT NULL
	DROP TABLE Visit;
go

CREATE TABLE Visit (
	visit_id int IDENTITY(1,1) PRIMARY KEY,
	visit_date date DEFAULT (CONVERT(date,GETDATE())),
	visit_time time(0) DEFAULT (CONVERT(time,GETDATE())),
	visit_patient int NULL,
	visit_reason nchar(100) DEFAULT (N'���������� ������� �������'),
	CONSTRAINT FK_Patient FOREIGN KEY (visit_patient) REFERENCES Patient (patient_id)
	-- ON UPDATE CASCADE --
	-- ON UPDATE SET NULL --
	-- ON UPDATE SET DEFAULT --
	-- ON DELETE CASCADE --
	-- ON DELETE SET NULL --
	ON DELETE SET DEFAULT
	);
go

INSERT INTO Visit(visit_date,visit_time,visit_patient)
VALUES (CONVERT(date,N'11-01-2014'),CONVERT(time,N'12:20:00'),3),
	   (CONVERT(date,N'19-03-2014'),CONVERT(time,N'13:30:00'),6),
	   (CONVERT(date,N'21-06-2014'),CONVERT(time,N'15:00:00'),2),
	   (CONVERT(date,N'26-08-2014'),CONVERT(time,N'16:10:00'),7),
	   (CONVERT(date,N'06-10-2014'),CONVERT(time,N'17:20:00'),3)  
go

SELECT * FROM Visit
go


/* DELETE FROM Patient
WHERE gender = N'�'
go 

SELECT * FROM Patient
go
SELECT * FROM Visit
go */