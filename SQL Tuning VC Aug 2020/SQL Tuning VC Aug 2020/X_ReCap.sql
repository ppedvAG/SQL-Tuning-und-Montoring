/*
SETUP:

Volumewartungstask (Sicherheitsrichtlinie).. Ausnullen.. f�r guten Admin/Dev egal
	--ordentliche Gr��e


--TX---> (LOG(ldf)+RAM)--> Commit--> CHECKPOINT-->HDD

--> InMemory: Einschr�nkungen..keine References.. schnell schreiben.. Staging (haben auch Logfile)

--HADR--> AVG  (reicht wenn im RAM) nach Commit 


Goldene Regel : trenne Daten von Log pro DB pyhsikalisch


MAXDOP (2019): 50% der CPUs max 8
--> pro Server, pro DB, pro Abfrage


RAM (2019): Min und MAX (sollte man einstellen)


TempDB: Trenne Daten von Logfile--> soviele Dateien wie Cores (8)... immer gleich gro�, Uniform Extents
(-T1117/1118)
--> #tabellen, ##Tabellen, #proc (Security), Zeilenversionierung,Index Rebuild mit Sort in Tempdb, 



DATENBANK

	--Verg��erungsraten
	-- 

Gezielt Redundanz.. andreasr|ppedv.de

--Partitionierung






*/
