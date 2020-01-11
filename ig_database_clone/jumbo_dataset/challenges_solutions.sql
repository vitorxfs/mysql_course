-- 1. Finding 5 oldest users
SELECT * FROM users ORDER BY created_at LIMIT 5;

-- 2. What day of the week do most users register on?
SELECT 
	DAYNAME(created_at) AS week_day, 
    COUNT(*) AS 'count'
FROM users
GROUP BY DAYNAME(created_at)
HAVING COUNT(*) = (
	SELECT 
		COUNT(*) 
	FROM users 
	GROUP BY DAYNAME(created_at) 
	ORDER BY COUNT(*) DESC LIMIT 1
);


-- 3. Find the users who have never posted a photo
SELECT users.id, username, users.created_at
FROM users
LEFT JOIN photos
	ON photos.user_id = users.id
WHERE photos.id IS NULL;


-- 4. Who posted the most liked photo
SELECT 
	users.username, 
    photos.id
	photos.image_url, 
	COUNT(*) AS no_likes
FROM photos
INNER JOIN likes
	ON likes.photo_id = photos.id
INNER JOIN users
	ON photos.user_id = users.id
GROUP BY likes.photo_id
ORDER BY no_likes DESC
LIMIT 1;

-- 5. Avg number of photos per user
SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg;


-- 6. Top 5 most commonly used hashtags
SELECT tag_name, COUNT(*) AS total
FROM photo_tags
INNER JOIN tags
	ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;


-- 7. Find users who have liked every single photo on the site
SELECT username, COUNT(*) AS num_likes
FROM users
INNER JOIN likes
	ON likes.user_id = users.id
GROUP BY users.id
HAVING COUNT(*) = (SELECT COUNT(*) FROM photos);

