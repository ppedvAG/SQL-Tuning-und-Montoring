--Kompression: Seiten oder Zeilenkompression
--pro tabelle

---TEST1:--> 
--Server komplett neustarten: Messung: RAM nach Neustart 289--290MB+ü 590

set statistics io, time on

select * from testdbx..t1

--Seiten:    Dauer: 700    CPU ms: 5500


--Kompression: Seitenkompression-- jetzt ist Tabelle ca 500Kb

--Neustart des Server: RAM: 290MB--> ca gleich  ;-) --> nach Abfrage 
--Seiten kommen auch komprimiert in RAM
set statistics io, time on

select * from testdbx..t1

--Seiten: weniger   Dauer: weniger CPU ms: weniger aber auch mehr .. 

--in der Praxis zuerwarten: mehr CPU, Kompression: ca 40 bis 60%

-->CPU steigt


--Kompression wird nicht wg der komprimierten tabellen gemacht, sondern,
--damit andere Platz im RAM haben

--Warum lassen sich nicht gleich DBs komrimieren

--weil alles mit CPU beantwortet...

















