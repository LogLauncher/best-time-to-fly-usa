
(SELECT ds.id AS `fk_date_state`, f.arr_delay, f.dep_delay, f.origin, f.dest, f.weather_delay
FROM flights f
INNER JOIN airports a ON
a.iata = f.origin
INNER JOIN date_state ds ON
ds.`date` = f.departure_date AND ds.state_abbr = a.state_abbr
WHERE (f.arr_delay + f.dep_delay) > 0)
UNION
(SELECT ds.id AS `fk_date_state`, f.arr_delay, f.dep_delay, f.origin, f.dest, f.weather_delay
FROM flights f
INNER JOIN airports a ON
a.iata = f.dest
INNER JOIN date_state ds ON
ds.`date` = f.departure_date AND ds.state_abbr = a.state_abbr
WHERE (f.arr_delay + f.dep_delay) > 0);



SELECT t.departure_date, t.state_abbr, SUM(t.nb_flights) AS `nb_flights`, SUM(t.nb_weather_delay) AS `nb_weather_delay` FROM
((SELECT f.departure_date, a.state_abbr, COUNT(*) AS `nb_flights`, SUM(f.weather_delay) AS `nb_weather_delay` FROM flights f
INNER JOIN airports a ON
a.iata = origin
WHERE (f.arr_delay + f.dep_delay) > 0
GROUP BY departure_date, a.state_abbr)
UNION
(SELECT f.departure_date, a.state_abbr, COUNT(*) AS `nb_flights`, SUM(f.weather_delay) AS `nb_weather_delay` FROM flights f
INNER JOIN airports a ON
a.iata = dest
WHERE (f.arr_delay + f.dep_delay) > 0
GROUP BY departure_date, a.state_abbr)) t
GROUP BY departure_date, state_abbr
ORDER BY departure_date, state_abbr;



SELECT t.`date`, t.state_abbr, SUM(t.nb_storms) AS `nb_storms` FROM
((SELECT start_date AS `date`, state_abbr, COUNT(*) AS `nb_storms`
FROM storms
GROUP BY start_date, state_abbr)
UNION
(SELECT end_date AS `date`, state_abbr, COUNT(*) AS `nb_storms`
FROM storms
WHERE start_date != end_date
GROUP BY end_date, state_abbr)) t
GROUP BY t.`date`, t.state_abbr
ORDER BY t.`date`, t.state_abbr;
