--DB Design
SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Employees.LastName, Employees.FirstName, Employees.BirthDate, Products.ProductName, 
                         Products.UnitsInStock
INTO KuUm
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID;
GO


insert into kuUm
select * from KuUm
GO


select * into kuum2 from kuum


select top 3 * from kuum2



select top 1 city , sum(unitprice*quantity) from kuum2 group by city;
GO

select top 10 * from kuum2



set statistics io, time on -- Anzahl der Seiten , Dauer in ms der CPU Arbeit und Gesamtdauer und Kompilier/Analysezeit
--nur bei Bedarf

--41613  , CPU-Zeit = 1156 ms, verstrichene Zeit = 169 ms.

--Plan: der tats. ist fast immer identisch mit dem geplanten (ausser bei f())

--ein Symbol tritt immer wieder auf... Indianer? .. Doppelpfeil: Parellelismus

--scheint sich gelohnt zu haben.. mehr CPU Zeit als Dauer

--Symbole: Gather Stream   Repartition Stream.. oft ein Indiz für schlechten MAXDOP
---Wieviele CPUs eigtl...
--im tats Plan finden wir 8 CPU Threads (alle)
--CXPACKET-- mehr CPUS kosten auch ehr CPU Leistung

--Ausscschlaggebend sind die Kosten

--Sind Abfragen mit mehr CPUs immer schneller

--was wenn nur 1 CPU werkelt

--Grundeinstellung: eine oder alle CPUs

select  city , sum(unitprice*quantity) from kuum2 group by city;
GO

--CPU nun 500ms ca 50% aber dafür längere DAuer 500ms

--Effekt mit weniger CPUs könnte sein:
--weniger CPUs schaffen es in gleicher Zeit, aber mit deutlich weniger CPU Aufwand


--wenn wir den MAXDOP ändern, dann werden erst die nächsten Abfragen profiterien
--aber keine laufenden unterbrochen

--Was wären ideale Werte: Faustregel

select  city , sum(unitprice*quantity) from kuum2 group by city
option (maxdop 6)
;


---RUNNING RUNNABLE SUSPENDED


--kann man Paral. messen

select * from sys.dm_os_wait_stats where wait_type like 'CX%'

--Wie kann man parallelismus anpassen ohne Settting oder TSQL...
--> Indizes
--> Partitionierung


--Als wir die TESTDB anlegten haben wir viele Fehler gemacht

--Was wären die eigtl besten Einstellungen bei einer DB
--> in 3 Jahren

--Wachstum nie in %.. Faustregel.. 1 GB
--am besten kein Wachstum.. beobachten


use testdbx;
GO


create table t1 (id int identity, spx char(4100));
GO


set statistics io, time off

insert into t1
select 'XY'
GO 30000

--wie lange dauert der insert von 30000 Zeilen:  26

---wie groß war der Aufwand zum vergrößern der DB

--wie groß ist die Tabelle t1 eigtl...

select 30000*4-- eigtl 120MB aber hat 240MB

--viele Vergrößerungen pro Sekunde
--im bereich 10 ms (HDD dann eher 70ms)
--aber in Summe erklären die ms nicht die Dauer..


--Phänomen : Seiten



--Seite hat immer 8192bytes
--davon sind 8060 bytes Nutzlast.. 
--pro Seite max 700 Slots
--Ziel sollte sein: Seiten so voll wie möglich


--8 Seiten am Stück nennt sich Extent / Block
--SQL Server liest nie einen DS sondern Seiten bzw Blöcke


-- das erklärt auch die 240 MB
--1 DS > 50% einer Seiten dann ist die Seite voll...
--bei Datentypen wie varchar kann seitenübergreifend weggeschrieben werden

--Datentyp image/text/ntext--> 2GB sind seit 2005 depricated
--was wäre die Alternative: Filetable, varchar(max) .. 2GB

--wie kann ich messen, dass eine Seite rel voll ist...?

--rel Tabellen sind: die größten, größte Traffic
dbcc showcontig('t1')
-- Gescannte Seiten.............................: 30000
--- Mittlere Seitendichte (voll).....................: 50.79%

--das ist irre!!
--aber wie kommen wir auf höhere Dichten..?


--statt fixe Datentypen eher flexibel: char und varchar
--datetime...! eigtl ms aber eigtl auch nicht 

--suche alle die im Rentenalter sind: ab 65
use northwind
select * from employees

select * from employees where birthdate < dateadd(yy,-65, getdate())

select * from employees where dateadd(yy,65,birthdate) < getdate()

select * from employees where datediff(yy, birthdate, getdate()) > 65

--Varibale... Datum des Rentenalters errechnen, dann vergleich


select * from orders where year(orderdate) = 1997 --408

select * from orders where orderdate between '1.1.1997' and '31.12.1997'--falsch

select * from orders where orderdate
	between '1.1.1997' and '31.12.1997 23:59:59.999'--falsch

--SEITEN KOMMEN 1:1! IN RAM

--logische Design:
--DB für einen BIB:

--Wie kann man den Füllgrad einer Seite beeinflussen:

--Datentypen--> APP Redesign
--Auslagern in andere zus. Tabellen --> APP Redesign
--Luft rausnehmen: --> Kompression

use testdbx

set statistics io, time on


select * from t1

dbcc showcontig('t1')

/*
Die TABLE-Ebene wurde gescannt.
- Gescannte Seiten.............................: 35574
- Gescannte Blöcke..............................: 4448
- Blockwechsel..............................: 4447
- Seiten pro Block (Durchschnitt)......: 8.0
- Scandichte [Bester Wert:Tatsächlicher Wert].......: 99.98% [4447:4448]
- Blockscanfragmentierung...................: 0.13%
- Bytes frei pro Seite (Durchschnitt).....................: 3983.0
- Mittlere Seitendichte (voll).....................:


*/


--Kompression: Seitenkompression und Zeilenkompression

--240MB-->300kb

