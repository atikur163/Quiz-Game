-- ATIK - MATH WHIZ : database setup (MySQL 5.7+ / 8.x)
-- Run:  mysql -u root -p < database/math_whiz_db.sql

CREATE DATABASE IF NOT EXISTS math_whiz_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE math_whiz_db;

CREATE TABLE IF NOT EXISTS game_scores (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    score       INT          NOT NULL,
    difficulty  VARCHAR(20)  NOT NULL DEFAULT 'NORMAL',
    played_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_leaderboard (score, played_at)
);

-- Top 10 leaderboard query used by the application
-- SELECT id, player_name, score, difficulty, played_at
-- FROM game_scores
-- ORDER BY score DESC, played_at ASC
-- LIMIT 10;
