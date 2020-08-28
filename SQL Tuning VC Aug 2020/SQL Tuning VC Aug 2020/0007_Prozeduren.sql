

--Objekte: cusomerid char(5)
exec gpKundensuche 'ALFKI' -- aus Customers der ALFKI gefunden  (Customerid)

exec gpKundensuche 'A' -- aus Customers alle mit A beginnend

exec gpKundensuche  -- alle Kunden (Customerid)


create proc gpKundenSuche @kdid varchar(5) = '%'
as
select * from customers where customerid like @kdid + '%'


--Uiiiiiiiiiuiuiiuhhhhh

--fazit.. verwende bei variablen Längen bei Varibalen  od Parametern immer etwas mehr.

--mehr als doppelte varchar(50)--> varchar(150).. vor allem bei order by

--sort warning

--Aktivieren des QUeryStore..
--perfektes Instrument zum Auffinden schlecht performender Abfragen
--Ideal auch für Suche nach "verrückten" prozeduren...


create proc gpSuche1 @ID int
as
select * from ku4 where id < @id
GO

select * from ku4 where id < 1000000

dbcc freeeproccache--leert den kompletten ProzCache
--beeer: ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE
--nur aktuell verwendete DB



exec gpSuche1 2 --Table Scan 42000 Seiten

set statistics io, time on
exec gpSuche1 1000000 --IX Seek... 1002233 Seiten!!!!

--Fazit: mach nicht beutzerfreundlich



select * from customers where customerid like 'A%'
select * from customers where left(customerid,1) ='A'


--Alle datensätze aus dem Jahr 1996

select * from ku4 where year (orderdate) = 1996 --immer SCAN
--jeden Datensatz ansehen müssen

select * from ku4 where datepart(yy,orderdate) = 1998

select * from ku4 where orderdate between '1.1.1996' and '31.12.1996 23:59:59.997'

--alle die über 18

select * from employees where birthdate < dateadd(yy, -18, getdate())


declare @var datetime
set @var...

select * from 1 10 30 

--Einsatz von Variablen machen das nicht besser

--F() 

select f(wert), f(Abfrage auf andere Tabellen) from f(tab) where f(sp) > f(wert)

--Funktionen im Plan

--gesch. zeigt Funktion an.. der tats nicht mehr
--gesch. Plan lügt bei der Leistungsbessung
--sets statistics
--Xevents



select * into ku5 from ku4




select * from ku5 where id = 100--einmal


select * from ku5 where city = 'berlin'--puuhh.. ka
select * from ku5 where freight < 1 -- pfff oft oder wenig weiss der Kuckuck

--woher weiss der das..?

--Statistiken.. werden erst erstellt , wenn die Abfrage eine Where Bediungn auf die Spalte nethält


--ProdServer: Abfrage langsam.. Testrechner.... schneller

--Stats sind falsch: Aktualisierung...20% +500+Abfrage 


---Logischer Fluss
--Planwiederverwendung

--Tools... idelae IX Strategie auf Basis 50000 laufen

--Statistiken müssen korrekt sein. Akteulle Statsistiken sind meist korrekter als alte;-)
--tägliche Statsístikaktualisierung!

--sp_updatestats

--SQL macht per default nur Einzelspaltenstatistik, aber keine kombinierten Statistiken..

--Stat oft Grund für schlechte leistung, da falscher Plan entwicklet wird...


















--In der PROC auf ander verzweigen
create proc godemo3 var1 
as
If @var = 1 
select * from orders
ELSE
select * from customers...


dbcc freeproccache
