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

print ('q2: ' + cast(IDENT_CURRENT('dbo.Author') as nvarchar(3)))
print ('q2 (scope): ' + cast(SCOPE_IDENTITY() as nvarchar(3)))

SELECT * FROM Author

select newid()