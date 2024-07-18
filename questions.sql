-- Question 1: Find the 5 oldest users
-- We want to reward our users who have been around the longest. 
SELECT
    username,
    created_at
FROM
    users
ORDER BY
    created_at ASC
LIMIT
    5;

-- Question 2: What days of the week do most users register on? 
-- We need to optimize our ad campaign schedule
SELECT
    DAYNAME(created_at) AS day_of_week,
    COUNT(created_at) AS num_registered
FROM
    users
GROUP BY
    day_of_week
ORDER BY
    num_registered DESC;

-- Question 3: Identify Inactive Users (find users with no photos)
-- We want to target our inactive users with an email campaign 
SELECT
    username,
    image_url
FROM
    users
    LEFT JOIN photos ON users.id = user_id
WHERE
    image_url IS NULL;

-- Question 4: Who won in this contest?
-- Who got the most likes on a single photo?
SELECT
    username,
    image_url,
    COUNT(likes.user_id) num_likes
FROM
    users
    INNER JOIN photos ON users.id = photos.user_id
    INNER JOIN likes on photos.id = likes.photo_id
GROUP BY
    username,
    image_url
ORDER BY
    num_likes DESC
LIMIT
    1;

-- Question 5: How many times does the average user post? 
WITH post_total AS (
    SELECT
        username,
        IFNULL(COUNT(photos.created_at), 0) AS num_posts
    FROM
        users
        LEFT JOIN photos on users.id = photos.user_id
    GROUP BY
        username
)
SELECT
    username,
    AVG(num_posts) AS avg_posts_per_user,
    AVG(num_posts) OVER() AS avg_posts_total_users
FROM
    post_total
GROUP BY
    username
ORDER BY
    avg_posts_per_user DESC;

-- Question 6: What are the top 5 most commonly used hashtags?
-- A brand wants to know which hashtags to use in  a post
SELECT
    tag_name,
    count(tag_id) AS total_uses
FROM
    tags
    INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY
    tag_name
ORDER BY
    total_uses DESC
limit
    5;

-- Question 7: Find users who have liked every single photo on the site
-- Solve the bot problem on this site
SELECT
    username,
    COUNT(user_id) num_likes
FROM
    users
    INNER JOIN likes on users.id = likes.user_id
GROUP BY
    username
HAVING
    num_likes = (
        SELECT
            COUNT(id) num_photos
        FROM
            photos
    )