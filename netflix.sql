--netflix project
drop table if exists netflix;
create table  netflix
(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(25),
description VARCHAR(250)

);

select * from netflix

select 
	count(*) as total_content

from netflix;


select 
	*
from netflix;

select 
	DISTINCT type
from netflix;

select * from netflix

--bussiness problems
--.1 count the number of movies vc tv shows
select 
type ,
count(*) as total_content
from netflix
group by type

--2. find the most common rating for movies and tv shows
select 
	type,
	rating
	from(
select 
	type,
	rating,
	count(*),
	rank() over( partition by type order by count (*) desc) as ranking
from netflix
group by 1,2
order by 1,3 desc
)as t1
where ranking =1

--3 list all movies relesedes in a  specific year (e.g)2020)

select * from netflix
where 
	type ='Movie'
	AND
	release_year = 2020

--4. find the top 5 countries with the most content on netflix
Select country ,
count(show_id) as total_content
 from netflix
 group by 1

 select 
   unnest(string_to_array(country,',')) as new_country,
   count(show_id) as total_content
from netflix 
group by 1
order by 2 DESC
limit 5

 --5 identify the longest movie pr tv show duration
 SELECT * FROM netflix
 WHERE
 	type ='movie'
 	AND
 	duration=(SELECT MAX(duration) FROM netflix)

  --6 find content added in the last 5 years
  SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


 --7 find all moives and tv shows my rajiv chilka
 SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

--8list all tv showa with more 5 season
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--9 count the number of content items in each gener
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--10 find each year and the avarge number of content relese by india on netflix
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

--11 list all movies that aree documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--12 find all the  ocntent without director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13 find how many movies actor "sallm khaan cast in last 10 year"
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;