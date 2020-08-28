/*
Installation

Was ist im Setup Tuning

Dateipfade Regel:  Empfehlung physikalisch trennen... pro DB

create database testdb;
GO

.mdf Daten
.ldf Log


SAN: --Messen!


tempdb (Seit SQL 2016): #tabellen, Sortieroperation, Indizes, Zeilenversionierung,...
soll schnell sein


Regel der tempdb: ???
Anzahl der Dateien wie kerne max 8.. Gleich große Datenddateien
T1117 T1118
Uniform Extent




MAX RAM Empfehlung 10288

MAXDOP (8)

Volumewartungstask ist mir Sch** egal, weil der SQL Server so gut wie nie vergößern sollt


schulung\Admnstrator
ppedv2019!

3 HyperV Maschinen

12GB
HV-DC:   max 2GB
HV-SQL1: 4,5GB
HV-SQL2: 4,5 GB

TaskManager: Wieviel RAM haben wir eigtl und wieviele Kerne

RAM 16 GB - 3,5 OS (4GB)
Kerne: 4

SQL Server sollte in VMS fixen Arbeitsspeicher haben

default
MN =
max 2,1 PB.. aber wieviel .. sicher nicht alles wg OS: 10% aber nicht mehr als 4GB


Der Max Wert reguliert sofort
Garantie für andere (OS)

Der MIN Wert spielt erst eine Rolle, wenn der Speicher von SQL Server allokiert wurde


MAXDOP...

und ist die Garantie für den sql server
select 13700-10288









*/