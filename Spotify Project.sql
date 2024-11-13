create database if not exists project;

use project;

show tables;

-- Backup Table

CREATE TABLE `spotify_1` (
  `track_id` int DEFAULT NULL,
  `track_name` text,
  `album_name` text,
  `release_date` text,
  `track_number` int DEFAULT NULL,
  `acousticness` double DEFAULT NULL,
  `danceability` double DEFAULT NULL,
  `energy_level` double DEFAULT NULL,
  `instrumentalness` double DEFAULT NULL,
  `liveness` double DEFAULT NULL,
  `volume_level_db` double DEFAULT NULL,
  `speechiness` double DEFAULT NULL,
  `tempo_bpm` double DEFAULT NULL,
  `mood_positive_negative` double DEFAULT NULL,
  `popularity_score` int DEFAULT NULL,
  `duration_ms` int DEFAULT NULL,
  `duration_min` decimal(10,2) DEFAULT NULL,
  `weighted_score` decimal(10,2) DEFAULT NULL,
  `rating` varchar(10) DEFAULT NULL,
  `mood` varchar(20) DEFAULT NULL,
  `acousticness_category` varchar(50) DEFAULT NULL,
  `vibe_category` varchar(50) DEFAULT NULL,
  `instrumentalness_category` varchar(50) DEFAULT NULL,
  `danceability_category` varchar(50) DEFAULT NULL,
  `popularity_category` varchar(20) DEFAULT NULL,
  `energy_description` varchar(20) DEFAULT NULL,
  `Volume_Description` varchar(20) DEFAULT NULL,
  `tempo_description` varchar(20) DEFAULT NULL,
  `Release_Year` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from spotify;


ALTER TABLE spotify RENAME COLUMN MyUnknownColumn TO track_id;
ALTER TABLE spotify RENAME COLUMN name TO track_name;
ALTER TABLE spotify RENAME COLUMN album TO album_name;
ALTER TABLE spotify RENAME COLUMN release_date TO release_date;
ALTER TABLE spotify RENAME COLUMN track_number TO track_number;
ALTER TABLE spotify RENAME COLUMN id TO spotify_track_id;
ALTER TABLE spotify RENAME COLUMN uri TO spotify_uri;
ALTER TABLE spotify RENAME COLUMN acousticness TO acousticness;
ALTER TABLE spotify RENAME COLUMN danceability TO danceability;
ALTER TABLE spotify RENAME COLUMN energy TO energy_level;
ALTER TABLE spotify RENAME COLUMN instrumentalness TO instrumentalness;
ALTER TABLE spotify RENAME COLUMN liveness TO liveness;
ALTER TABLE spotify RENAME COLUMN loudness TO volume_level_db;
ALTER TABLE spotify RENAME COLUMN speechiness TO speechiness;
ALTER TABLE spotify RENAME COLUMN tempo TO tempo_bpm;
ALTER TABLE spotify RENAME COLUMN valence TO mood_positive_negative;
ALTER TABLE spotify RENAME COLUMN popularity TO popularity_score;
ALTER TABLE spotify RENAME COLUMN duration_ms TO duration_ms;

describe spotify;

ALTER TABLE spotify
ADD COLUMN Release_Year int;

UPDATE spotify
SET Release_Year = CASE
    WHEN Release_Date LIKE '%-%-%' THEN YEAR(STR_TO_DATE(Release_Date, '%d-%m-%Y'))
    WHEN Release_Date LIKE '%/%/%' THEN YEAR(STR_TO_DATE(Release_Date, '%m/%d/%Y'))
END;

ALTER TABLE spotify
ADD duration_min DECIMAL(10, 2);

UPDATE spotify
SET duration_min = ROUND(duration_ms / 60000.0, 2);

ALTER TABLE spotify
ADD weighted_score DECIMAL(10, 2);

UPDATE spotify
SET weighted_score = (0.7 * popularity_score + 0.3 * energy_level);


select count(*) from spotify;

ALTER TABLE spotify
DROP COLUMN spotify_track_id,
DROP COLUMN spotify_uri;

SHOW COLUMNS FROM spotify;

ALTER TABLE spotify
ADD rating VARCHAR(10);


UPDATE spotify
SET rating = 
    CASE 
        WHEN popularity_score >= 30 AND energy_level >= 0.8 THEN 'High'
        WHEN popularity_score >= 20 AND energy_level >= 0.5 THEN 'Medium'
        ELSE 'Low'
    END;

ALTER TABLE spotify
ADD mood VARCHAR(20);

update spotify
    set mood =
    CASE
        WHEN mood_positive_negative >= 0.5 THEN 'Joyful'
        WHEN mood_positive_negative >= 0.3 THEN 'Mixed Feelings'
        ELSE 'Downcast'
    END ;


ALTER TABLE spotify
ADD acousticness_category VARCHAR(50);

UPDATE spotify
SET acousticness_category = CASE
    WHEN Acousticness >= 0.8 THEN 'Very High'
    WHEN Acousticness >= 0.6 THEN 'High'
    WHEN Acousticness >= 0.4 THEN 'Moderate'
    WHEN Acousticness >= 0.2 THEN 'Low'
    ELSE 'Very Low'
END;

ALTER TABLE spotify
ADD vibe_category VARCHAR(50);


UPDATE spotify
SET vibe_category = CASE 
    WHEN energy_level >= 0.8 THEN 'Party Anthem'
    WHEN energy_level >= 0.6 THEN 'Dance Hit'
    WHEN energy_level >= 0.4 THEN 'Moderate Groove'
    WHEN energy_level >= 0.2 THEN 'Chill Vibe'
    ELSE 'Barely Moving'
END;


ALTER TABLE spotify
ADD instrumentalness_category VARCHAR(50);

UPDATE spotify
SET instrumentalness_category = CASE
    WHEN instrumentalness >= 0.8 THEN 'High'
    WHEN instrumentalness >= 0.6 THEN 'Most'
    WHEN instrumentalness >= 0.4 THEN 'Somewhat'
    WHEN instrumentalness >= 0.2 THEN 'Slight'
    ELSE 'None'
END;


ALTER TABLE spotify
ADD danceability_category VARCHAR(50);

UPDATE spotify
SET danceability_category = CASE
    WHEN danceability >= 0.8 THEN 'Party Anthem'
    WHEN danceability >= 0.6 THEN 'Dance Hit'
    WHEN danceability >= 0.4 THEN 'Moderate Groove'
    WHEN danceability >= 0.2 THEN 'Chill Vibe'
    ELSE 'Barely Moving'
END;


ALTER TABLE spotify
ADD popularity_category VARCHAR(20);

UPDATE spotify
SET popularity_category = 
    CASE
        WHEN popularity_score >= 40 THEN 'Viral'
        WHEN popularity_score >= 30 THEN 'Trending'
        WHEN popularity_score >= 20 THEN 'Popular'
        ELSE 'Under the Radar'
    END;


ALTER TABLE spotify
ADD energy_description VARCHAR(20);

UPDATE spotify
SET energy_description = 
CASE
    WHEN Energy_Level >= 0.9 THEN 'High Energy'
    WHEN Energy_Level >= 0.7 THEN 'Moderate Energy'
    WHEN Energy_Level >= 0.5 THEN 'Low Energy'
    ELSE 'Very Low Energy'
END;

ALTER TABLE spotify
ADD Volume_Description VARCHAR(20);

UPDATE spotify
SET Volume_Description = CASE
    WHEN Volume_Level_dB >= -5 THEN 'Loud'
    WHEN Volume_Level_dB >= -10 THEN 'Moderate'
    WHEN Volume_Level_dB >= -15 THEN 'Soft'
    ELSE 'Very Soft'
END;


ALTER TABLE spotify ADD COLUMN tempo_description VARCHAR(20);

UPDATE spotify
SET tempo_description = 
   CASE 
       WHEN tempo_bpm >= 150 THEN 'Fast Paced'
       WHEN tempo_bpm >= 120 THEN 'Upbeat'
       WHEN tempo_bpm >= 100 THEN 'Moderate'
       ELSE 'Slow'
   END;


select * from spotify;

WITH duplicates AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY track_name, album_name ORDER BY track_id) AS row_num
    FROM
        spotify
)
DELETE FROM spotify
WHERE track_id IN (
    SELECT track_id
    FROM duplicates
    WHERE row_num > 1
);


-- Basic Statistics: Count and Average

-- 1. Count total number of tracks
SELECT COUNT(*) AS total_tracks FROM spotify;

-- 2. Average duration of tracks
SELECT round(AVG(duration_min),2) AS average_duration_min, round(avg(duration_ms),2) as average_duration_ms FROM spotify;

-- 3. Average popularity score
SELECT round(avg(popularity_score),2) AS average_popularity FROM spotify;

-- 4. Average energy level
SELECT round(AVG(energy_level),2) AS average_energy FROM spotify;

-- 5. Maximum and Minimum Energy Level
SELECT round(MAX(energy_level),2) AS max_energy, round(MIN(energy_level),2) AS min_energy
FROM spotify;

-- 6. Count Tracks by Acousticness Level
SELECT acousticness_category, COUNT(*) AS count_of_tracks
FROM spotify
GROUP BY acousticness_category;

-- 7. Tracks Grouped by Popularity Level
SELECT popularity_category, COUNT(*) AS track_count
FROM spotify
GROUP BY popularity_category;

-- 8. Average Tempo (BPM) for Tracks with High Energy
SELECT round(AVG(tempo_bpm),2) AS avg_tempo_high_energy
FROM spotify
WHERE energy_description = 'High Energy';

-- 9. Maximum and Minimum Tempo (BPM)
SELECT round(MAX(tempo_bpm)) AS max_tempo, round(MIN(tempo_bpm)) AS min_tempo
FROM spotify;

-- 10. Tracks with the Highest Popularity Score
SELECT *
FROM spotify
ORDER BY popularity_score DESC
LIMIT 5;

-- 11. Track Count by Mood
SELECT mood, COUNT(*) AS track_count
FROM spotify
GROUP BY mood;

-- 12. Average Weighted Score by Popularity Level
SELECT popularity_category, 
	   round(AVG(weighted_score),2) AS avg_weighted_score,
       round(max(weighted_score),2) AS max_weighted_score,
       round(min(weighted_score),2) AS min_weighted_score
FROM spotify
GROUP BY popularity_category;

-- 13. Top 5 Longest Tracks (By Duration)
SELECT *, duration_min
FROM spotify
ORDER BY duration_ms DESC
LIMIT 5;

-- 14. Tracks with Low Acousticness and High Energy
SELECT *
FROM spotify
WHERE acousticness_category = 'Very Low' AND energy_description = 'High Energy';

-- 15.  Percentage of Tracks with High Energy
SELECT round((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM spotify),2) AS percentage_high_energy
FROM spotify
WHERE energy_description = 'High Energy';

-- 16. Count of Tracks with Specific Mood
SELECT mood, COUNT(*) AS track_count
FROM spotify
WHERE mood IN ('Joyful', 'Downcast')
GROUP BY mood;


-- 17. Average Popularity by Tempo Range
SELECT
  CASE
    WHEN tempo_bpm BETWEEN 0 AND 100 THEN 'Slow'
    WHEN tempo_bpm BETWEEN 101 AND 150 THEN 'Moderate'
    WHEN tempo_bpm > 150 THEN 'Fast'
    else 'Super Fast'
  END AS tempo_range,
  AVG(popularity_score) AS avg_popularity
FROM spotify
GROUP BY tempo_range;

-- 18. Tracks with High Speechiness and Liveness
SELECT *
FROM spotify
WHERE speechiness > 0.5 AND liveness > 0.5;

-- 19. Find Tracks Released in 2022 with High Popularity
SELECT *
FROM spotify
WHERE release_year = 2022 AND popularity_score > 25;

-- 20. Find Tracks Grouped by Acousticness Level and Danceability Level
SELECT acousticness_category, danceability_category, COUNT(*) AS track_count
FROM spotify
GROUP BY acousticness_category, danceability_category;

-- 21. Find Tracks with the Most Balanced Acousticness and Danceability
SELECT *
FROM spotify
WHERE acousticness_category = 'Moderate' AND danceability_category = 'Moderate Groove';

-- 22. Tracks with Tempo Above 120 BPM and High Energy
SELECT *
FROM spotify
WHERE tempo_bpm > 120 AND energy_description = 'High Energy';

-- 23. Top 5 Tracks by Weighted Score
SELECT *
FROM spotify
ORDER BY weighted_score DESC
LIMIT 5;

-- 24. Average Duration of Tracks Released After 2020
SELECT round(AVG(duration_min),2) AS avg_duration_minutes
FROM spotify
WHERE release_year > 2020;

-- 25. Distribution of Tracks by Release Year
SELECT release_year, COUNT(*) AS track_count
FROM spotify
GROUP BY release_year
ORDER BY release_year;

-- 26. Correlation Between Popularity and Energy Level
SELECT popularity_score, energy_level
FROM spotify;


-- Distribution-level analysis

-- 1. Distribution of Popularity Category

SELECT popularity_category, count(popularity_category)
from spotify
group by popularity_category;

-- 2. Distribution of Energy Levels
SELECT energy_description, COUNT(energy_description) AS track_count
FROM spotify
GROUP BY energy_description
ORDER BY track_count DESC;

-- 3. Distribution of Track Duration
SELECT 
  CASE
    WHEN duration_ms < 180000 THEN 'Short (Less than 3 min)'
    WHEN duration_ms BETWEEN 180000 AND 300000 THEN 'Medium (3-5 min)'
    WHEN duration_ms > 300000 THEN 'Long (More than 5 min)'
  END AS duration_category,
  COUNT(*) AS track_count
FROM spotify
GROUP BY duration_category;


-- 4. Distribution of Tempo
SELECT tempo_description, COUNT(tempo_description) AS track_count
FROM spotify
GROUP BY tempo_description
ORDER BY track_count DESC;

-- 5. Distribution of Acousticness Levels
SELECT acousticness_category, COUNT(*) AS track_count
FROM spotify
GROUP BY acousticness_category
ORDER BY track_count DESC;

-- 6. Distribution of Mood
SELECT mood, COUNT(*) AS track_count
FROM spotify
GROUP BY mood
ORDER BY track_count DESC;

-- 7. Distribution of Tracks by Release Year
SELECT release_year, COUNT(*) AS track_count
FROM spotify
GROUP BY release_year
ORDER BY release_year DESC;


-- 8. Distribution of Tracks by Danceability Level
SELECT danceability_category, COUNT(*) AS track_count
FROM spotify
GROUP BY danceability_category
ORDER BY track_count DESC;

-- 9. Distribution of Tracks by Loudness
SELECT Volume_Description, COUNT(*) AS track_count
FROM spotify
GROUP BY Volume_Description
ORDER BY track_count DESC;

-- 10. Distribution of Tracks by Valence (Happiness Level)
SELECT 
  CASE
    WHEN liveness < 0.2 THEN 'Very Negative'
    WHEN liveness BETWEEN 0.2 AND 0.5 THEN 'Neutral'
    WHEN liveness BETWEEN 0.5 AND 0.8 THEN 'Positive'
    WHEN liveness > 0.8 THEN 'Very Positive'
    else 'Negative'
  END AS liveness_category,
  COUNT(*) AS track_count
FROM spotify
GROUP BY liveness_category;

-- 12. Distribution of Popularity Score Category
SELECT popularity_category, COUNT(popularity_category) AS track_count
FROM spotify
GROUP BY popularity_category
ORDER BY track_count DESC;

-- 12. Distribution of Vibe Category
SELECT vibe_category, COUNT(vibe_category) AS track_count
FROM spotify
GROUP BY vibe_category
ORDER BY track_count DESC;


-- 13. Distribution of Rating
SELECT rating, COUNT(rating) AS track_count
FROM spotify
GROUP BY rating
ORDER BY track_count DESC;

-- 13. Distribution of Track NO
SELECT track_number, COUNT(track_number) AS track_count
FROM spotify
GROUP BY track_number
ORDER BY track_count DESC;