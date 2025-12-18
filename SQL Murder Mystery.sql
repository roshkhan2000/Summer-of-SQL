SELECT *
FROM crime_scene_report
WHERE 
	city = 'SQL City' 
	AND 
	date = '20180115'
-- first witness lives on  Northwestern Dr
-- second witness is Annabel and lives on Franklin Ave
; 


SELECT *
FROM person AS p
INNER JOIN interview AS i
ON i.person_id = p.id
WHERE
	p.address_street_name = 'Northwestern Dr'
	OR 
	(p.address_street_name = 'Franklin Ave'
	AND 
	p.name LIKE 'Annabel%')
ORDER BY person_id ASC
-- I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
;


SELECT * 
FROM get_fit_now_member AS m
LEFT JOIN person AS p
ON p.id = m.person_id 
LEFT JOIN drivers_license AS d
ON p.license_id = d.id
WHERE
	m.membership_status = 'gold'
	AND
	m.id LIKE '48Z%'
	AND d.plate_number LIKE '%H42W%'
-- Jeremy Bowers, person_id = 67318 is the man Annabel described
;


SELECT *
FROM interview AS i
INNER JOIN person AS p
ON i.person_id = p.id
WHERE i.person_id = 67318
-- I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017
;


SELECT *
FROM person AS p
INNER JOIN drivers_license AS d 
ON p.license_id = d.id
LEFT JOIN facebook_event_checkin AS f
ON p.id = f.person_id 
WHERE 
	d.gender = 'female' 
	AND 
	d.car_make = 'Tesla' 
	AND 
	d.car_model = 'Model S'
	AND 
	d.hair_color = 'red'
	AND 
	f.event_name = 'SQL Symphony Concert'
-- Miranda Priestly, person_id 99716, is the person the murdere described
;

