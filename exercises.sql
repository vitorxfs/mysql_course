
-- 1
SELECT 
	REVERSE(
		UPPER("Why does my cat look at me whith such hatred?")
	);

-- 2
-- WHAT DOES THIS PRINT OUT?
SELECT 
	REPLACE( 
    CONCAT('I', ' ', 'like', ' ', 'cats'), 
    ' ', 
    '-' 
    );

-- 3
SELECT 
	REPLACE( title, ' ', '->' ) 
FROM books;

-- 4
SELECT 
	author_lname AS 'fowards', 
    REVERSE(author_lname) AS 'backwards' 
FROM books;

-- 5
SELECT 
	UPPER( 
		CONCAT( 
			author_fname, 
            ' ', 
            author_lname
		) 
	) AS 'full name in caps' 
FROM books;

-- 6
SELECT 
	CONCAT(
		title, 
        ' was released in ', 
        released_year
	) as 'blurb' 
FROM books;

-- 7
SELECT 
	title, 
    CHAR_LENGTH(title) AS 'character count' 
FROM books;

-- 8
SELECT 
	CONCAT( SUBSTR(title, 1, 10), '...' ) AS 'short title',
    CONCAT(author_lname, ',', author_fname) AS 'author',
    CONCAT(stock_quantity, ' in stock') AS 'quantity'
FROM books;


-- ------------- SECTION 8 -------------------

-- 1
SELECT title FROM books WHERE title LIKE '%stories%';

-- 2
SELECT title, pages FROM books ORDER BY pages DESC LIMIT 1;
-- OR
SELECT title, pages FROM books ORDER BY 2 DESC LIMIT 1;

-- 3
SELECT CONCAT(title, ' - ', released_year) AS 'summary' 
FROM books 
ORDER BY released_year DESC 
LIMIT 3;

-- 4
SELECT title, author_lname FROM books WHERE author_lname LIKE '% %';

-- 5
SELECT title, released_year, stock_quantity FROM books ORDER BY stock_quantity LIMIT 3;
-- OR
SELECT title, released_year, stock_quantity FROM books ORDER BY 3 LIMIT 3;

-- 6
SELECT title, author_lname FROM books ORDER BY author_lname, title;
-- OR
SELECT title, author_lname FROM books ORDER BY 2, 1;

-- 7
SELECT 
	UPPER( 
		CONCAT('my favorite author is ', author_fname, ' ', author_lname, '!') 
	) AS 'yell' 
FROM books 
ORDER BY author_lname;


-- --------SECTION 9--------------

-- 1
SELECT COUNT(*) FROM books;

-- 2
SELECT released_year, COUNT(*) FROM books GROUP BY released_year;

-- 3
SELECT SUM(stock_quantity) FROM books;

-- 4
SELECT author_fname, author_lname, AVG(released_year) 
FROM books GROUP BY author_lname, author_fname;

-- 5
SELECT CONCAT(author_fname, ' ', author_lname) AS 'author'
FROM books 
WHERE pages=(SELECT MAX(pages) FROM books);

-- OR (faster way)
SELECT CONCAT(author_fname, ' ', author_lname) AS 'author' 
FROM books 
ORDER BY pages DESC LIMIT 1;

-- 6
SELECT 
	released_year AS 'year', 
    COUNT(*) AS '# books', 
    AVG(pages) AS 'avg pages' 
FROM books 
GROUP BY released_year;

-- -------SECTION 10-----------

-- 1 
-- WHAT IS A GOOD USE CASE FOR CHAR
-- R: When the data has a fixed size, for example, the abreviation of brazilian states
--    with 2 letters (AM, SP, RJ, etc).

-- 2 
-- FILL WITH THE BEST DATA TYPE FOR EACH COLUMN (price is always < 1 000 000)
CREATE TABLE inventory (
	item_name VARCHAR(255),
    price DECIMAL(8,2),
    quantity INT
);

-- 3
-- WHAT'S THE DIFFERENCE BETWEEN DATETIME AND TIMESTAMP?
-- R: DATETIME has a wider range of time available to store, while TIMESTAMP is very
--    limited (it goes from around 1970 to 2038). Because of that, TIMESTAMP is often used
--    to store the date when the data was inserted, so the DEFAULT NOW() ON UPDATE NOW() usage is
--    very common.

-- 4
-- PRINT OUT THE CURRENT TIME
SELECT CURTIME();

-- 5
-- PRINT OUT THE CURRENT DATE
SELECT CURDATE();

-- 6
-- PRINT OUT THE CURRENT DAY OF THE WEEK (THE NUMBER)
SELECT DAYOFWEEK(CURDATE());

-- 7
-- PRINT OUT THE DAY NAME OF THE WEEK (THE NAME)
SELECT  DAYNAME(CURDATE());

-- 8
-- PRINT OUT THE CURRENT DAY USING THIS FORMAT: MM/DD/YYYY
SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y');

-- 9
-- PRINT OUT THE CURRENT DAY AND TIME USING THIS FORMAT: January 2nd at 3:15
SELECT DATE_FORMAT(NOW(), '%M %D at %h:%i');

-- 10
-- CREATE A TWEETS TABLE THAT STORES:
-- - A TWEET CONTENT
-- - A USERNAME
-- - TIME IT WAS CREATED
CREATE TABLE tweets (
	content VARCHAR(140),
    username VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);


-- -------SECTION 11-----------

-- 1
SELECT title, released_year FROM books WHERE released_year < 1980;

-- 2
SELECT title, author_lname FROM books WHERE author_lname = 'eggers' || author_lname = 'chabon';
-- OR
SELECT title, author_lname FROM books WHERE author_lname IN ('eggers', 'chabon');

-- 3
SELECT title, author_lname, released_year FROM books WHERE author_lname='lahiri' && released_year > 2000;
 
-- 4
SELECT title, pages FROM books WHERE pages BETWEEN 100 AND 200;

-- 5
SELECT title, author_lname FROM books WHERE author_lname LIKE 'c%' || author_lname LIKE 's%';

-- 6
SELECT title, author_lname,
	CASE
		WHEN title LIKE '%stories%' THEN 'Short Stories'
        WHEN title = 'just kids' || title LIKE 'a heartbreaking work%' THEN 'Memoir'
        ELSE 'Novel'
	END AS 'Genre'
FROM books;

-- 7
SELECT title, author_lname, 
	CASE
		WHEN COUNT(*) = 1 THEN CONCAT(COUNT(*), ' book')
        ELSE CONCAT(COUNT(*), ' books')
	END AS 'COUNT'
FROM books GROUP BY author_lname, author_fname;


-- --------- SECTION 16 - node random fake data ------------

-- 1. Find earliest date a user joined
SELECT 
	DATE_FORMAT(MIN(created_at), '%M %D %Y') AS earliest_date 
FROM users;


-- 2. find email of the first (earliest) user using subquery
SELECT email
FROM users 
WHERE created_at = ( 
	SELECT MIN(created_at) 
	FROM users 
);
 
-- 3. users according to the month they joined
SELECT 
	MONTHNAME(created_at) AS month,
	COUNT(*) as count
FROM users
GROUP BY month
ORDER BY count DESC;


-- 4. count number of users with yahoo emails
SELECT COUNT(*) as yahoo_users
FROM users
WHERE email LIKE '%@yahoo.com';


-- 5. total number of users for each email host
SELECT 
	CASE
		WHEN email LIKE '%@gmail.com' THEN 'gmail'
		WHEN email LIKE '%@yahoo.com' THEN 'yahoo'
		WHEN email LIKE '%@hotmail.com' THEN 'hotmail'
		ELSE 'other'
	END AS provider,
	COUNT(*) AS total_users
FROM users
GROUP BY provider
ORDER BY total_users DESC;