--Tab A 1000 DS
--Tab B 100000 DS
--A und B identisch

--select sp, sp from a where sp = wert: 10 zeilen

--select sp, sp from b where sp = wert: 10 zeilen

--Welche wäre schneller



--Dateigruppen:
--Dateigruppen einer oder mehr DAteien dahinter

--Tuning durch mehr Hdds

create table t2 (id int) on HOT

--Verschieben von Tabellen auf andere Dateigruppen

--erfordert zunächst das Löschen der Tabelle


--UMSATZTABELLE

--Part Sicht...

use testdbx


--statt einer Tabelle viele kleinere
--soll sich aber wie Tabelle Umsatz verhalten

create table u2020 (id int identity, Jahr int, sp int)
create table u2019 (id int identity, Jahr int, sp int)
create table u2018 (id int identity, Jahr int, sp int)




create view Umsatz
as
select * from  u2020
UNION ALL
select * from  u2019
UNION ALL
select * from  u2018


select * from umsatz where jahr = 2019

--soll nicht mehr alle tabellen durchgehen müssen

ALTER TABLE dbo.u2018 ADD CONSTRAINT
	CK_u2018 CHECK (jahr=2018)

ALTER TABLE dbo.u2020 ADD CONSTRAINT
	CK_u2020 CHECK (jahr=2020)

	ALTER TABLE dbo.u2019 ADD CONSTRAINT
	CK_u2019 CHECK (jahr=2019)


create table t (id int, spx int not null, spy int sparse null)--30000 Spalten

	--eine NULL braucht keinen Platz, aber NULL braucht mehr
	--bit 98%, "text" 60%, datetime in   42%










select * from umsatz where id = 2 and jahr = 2020


--Select klappt, aber geht auch I U D in Sicht

insert into umsatz (id,jahr,sp) values( 1,2019, 100) 

--es müssen PK sein über die Sicht hinweg und es darf kein Identity Wert vorhanden sein
--
select next value for seqid


insert into umsatz (id,jahr,sp) values(next value for seqid,2020, 100) 

--Gut bei: keine Ent Version (unter SQL 2016 SP1)
--bei Archivtabellen, die sich nicht mehr ändern

--NIX GR:: 1 MIO DS pro Tabelle  > 1% Ergebnismenge.. SCAN

--TAB_partition01..31

--besser gehts mit physikalischer Partitionierung
--es bleibt bei einer Umsatz Tabellen



--lege 4 Dgruppen: bis100, bis200, bis5000, rest



--zuerst die f()

create partition function fZahl(int) --15000 Bereiche sind möglich
as
RANGE LEFT FOR VALUES(100,200)

---------100-----------200--------------------
--   1            2              3


--wäre das möglich
--Kunden splitten: a bis m      n bis r       s bis z
create partition function fZahl(varchar(50)) --15000 Bereiche sind möglich
as
RANGE LEFT FOR VALUES('mzzzzzzz','s')

--jahresweise: 2018 2019 rest
create partition function fZahl(datetime) --15000 Bereiche sind möglich
as
RANGE LEFT FOR VALUES('31.12.2018 23:59.59.999','')



--das wird beim INS fixiert und nicht mehr geändert..vermeide.. deterministisch
create partition function fZahl(dateadd(yy,-1,getdate()),,) --15000 Bereiche sind möglich
as
RANGE LEFT FOR VALUES('31.12.2018 23:59.59.999','')





select $partition.fzahl(117) --2 !  ???


--jetzt das schema

create partition scheme schZahl
as
partition fzahl to (bis100,bis200,rest)
--                        1     2    3


create partition scheme schZahl
as
partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])
--macht durchaus sinn, wird aber nat. schneller wenn es versch HDDs wären


--Tabellen können auf Dgruppen oder auf partSchemas gelegt werden

create table ptab (id int identity, nummer int, spx char(4100)) 
	on schZahl(nummer)

	create table ptab2 (id int identity, nummer int, spx char(4100)) 
	on schZahl(nummer)





declare @i as int = 1

begin tran
while @i<= 30000
		begin
			insert into ptab2 values(@i, 'XY')
			set @i+=1			
		end
commit


--ist das schneller?

--SCAN A bis Z Suche und SEEK herauspicken (geht eigt nur mit IX)
--HEAP oder CL

set statistics io, time on
select * from ptab where id  = 117

select * from ptab where nummer  = 117--

select * from ptab where nummer  = 1117--


--wir sehen, dass aber der Bereich über 200 rel schlecht dimensioniert ist

--neue Grenze 5000

---------100-------------200---------------5000------------
--  1            2               3                   4

--TAB, F(), scheme

--F() schema

--zuerst Schema ändern

alter partition scheme schzahl next used bis5000

select $partition.fzahl(nummer), min(nummer), max(nummer), count(*) from ptab
group by  $partition.fzahl(nummer)


alter partition function fzahl() split RANGE (5000)

select * from ptab where nummer = 1117



--aber grenzen entfernen: 100

alter partition function fzahl() merge range(100)



--Archivierung

select * from ptab where nummer = 5019

--alle Werte über 5000 ins Archiv schieben

--wie sieht aktuell die Lage aus:
CREATE PARTITION FUNCTION [fZahl](int) AS 
RANGE LEFT FOR VALUES (200, 5000)
GO
USE [TESTDBX]
GO

CREATE PARTITION SCHEME [schZahl] AS PARTITION [fZahl] 
TO ([bis200], [bis5000], [rest])
GO


create table archiv(id int not null, nummer int, spx char(4100)) on rest

alter table ptab switch partition 3 to archiv

select * from archiv

--TAB, f(), schema
--nie Tab, 

---Annahme: wir kopieren 100MB / sec
-- 1000MB ins Archiv verschoben....dauert beim arcivieren: 0 sec

--lohnt sich bei sehr großen Tabellen

--Partitionierung läßt sich kombinieren mit: Indizes, einz Part komprimieren

--macht aber nur Sinn 














