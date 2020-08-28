Select c.country, count(*) as Anzahl from customers c
 group by country
order by anzahl

---FROM --JOIN (Alias) --> WHERE --> GROUP BY -- > HAVING
--SELECT (Alias, berechnung) --> TOP DISTINCT --> Order by -- Ausgabe


--tu nie im Having etwas filtern was ein where erldigen kann
--Having enthält immer nur Filter auf Agg



--HEAP --bei der ersten Seiten.. 

--_CL sucht ab dem Wurzelknoten