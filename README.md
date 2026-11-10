# ATIK – MATH WHIZ

A web-based maths game built with Java Servlets, JSP and JDBC (MySQL). Players answer four questions one at a time, see their score, and appear on a Top 10 leaderboard.

## Project objectives

- Write reusable Java methods for prime numbers, modulus and trigonometry.
- Check every answer with real Java calculations (no stored answers).
- Handle requests and responses with a Servlet and show pages with JSP.
- Save and read scores with JDBC and `PreparedStatement`.
- Show a sorted Top 10 leaderboard.

## Technologies used

- Java 17
- Jakarta Servlet 6 / JSP 3.1 / JSTL 3 (Tomcat 10.1+)
- JDBC with MySQL Connector/J 8
- MySQL 8
- Maven (WAR packaging), JUnit 5 for tests
- HTML and CSS (no JavaScript needed)

## Software requirements

| Software | Version |
|----------|---------|
| JDK | 17 or newer |
| Apache Tomcat | **10.1 or newer** (Tomcat 9 will not work: it uses the `javax` packages) |
| MySQL | 5.7 or 8.x |
| Maven | 3.8 or newer |

## Project structure

```
MathWhiz/
├── src/main/java/
│   ├── controller/GameServlet.java     requests: start, answer, next, result, leaderboard
│   ├── model/                          GameScore, GameState, TrigQuestion, Feedback, QuestionResult
│   ├── service/MathService.java        isPrime, calculateMod, calculateSin/Cos/Tan, scoring
│   ├── service/GameService.java        moves the game from step to step
│   └── dao/                            DBConnection, ScoreDAO (JDBC)
├── src/main/resources/db.properties    database settings
├── src/main/webapp/
│   ├── index.jsp  game.jsp  result.jsp  leaderboard.jsp
│   ├── css/style.css
│   └── WEB-INF/ (web.xml, jspf/header + footer)
├── src/test/java/service/MathServiceTest.java
├── database/math_whiz_db.sql
└── README.md
```

## Database configuration

1. Start MySQL.
2. Create the database and table:

```bash
mysql -u root -p < database/math_whiz_db.sql
```

3. Open `src/main/resources/db.properties` and set your MySQL user and password:

```properties
db.url=jdbc:mysql://localhost:3306/math_whiz_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=root
```

### Database creation SQL

```sql
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
```

## Steps to run the application

1. Set up the database (see above).
2. Build the WAR file:

```bash
mvn clean package
```

3. Copy `target/MathWhiz.war` into Tomcat's `webapps/` folder.
4. Start Tomcat (`bin/startup.sh` or `bin/startup.bat`).
5. Open **http://localhost:8080/MathWhiz/**

Using an IDE (IntelliJ IDEA Ultimate, Eclipse JEE, VS Code with a Tomcat extension)? Open the folder as a Maven project and add a Tomcat 10.1+ run configuration that deploys the `MathWhiz` WAR.

To run the unit tests: `mvn test`

To change the player name shown in the title, edit the `appTitle` value in `src/main/webapp/WEB-INF/web.xml`.

## Game rules and scoring system

The game asks four questions, one after another. After each question you see whether you were right.

| Question | Topic | What you do | Marks |
|----------|-------|-------------|-------|
| Q1 | Prime number | Type a number, then say Yes or No: is it prime? | 2 |
| Q2 | Modulus | Type two numbers (the divisor can't be zero), then type the remainder | 2 |
| Q3 | Trigonometry | Give sin, cos or tan of an angle | 3 |
| Q4 | Trigonometry | Give sin, cos or tan of an angle | 3 |
| | | **Total** | **10** |

Rules:

- **Prime:** `isPrime(int)` returns 1 for a prime and 0 otherwise. Numbers below 2 are not prime.
- **Modulus:** `calculateMod(int, int)` uses `%`. The divisor must not be zero. Negative numbers follow Java's `%` rule.
- **Trigonometry:** angles are in degrees and converted to radians before `Math.sin`, `Math.cos` and `Math.tan` are used. Answers may be decimals (within ±0.01) or fractions like `1/2`.
- **Undefined values:** now and then a question asks for `tan(90°)` or `tan(270°)`. The correct answer is *undefined* (press the Undefined button or type it).
- **Difficulty:** every question is `NORMAL`. The value is saved in the database.
- **Leaderboard:** top 10 by score (highest first). Equal scores: the earlier game ranks higher.

## Test cases (Task 09)

| Test case | Expected result |
|-----------|-----------------|
| Prime input 7 | 1 |
| Prime input 8 | 0 |
| Prime input 1 | 0 |
| Modulus 17 % 5 | 2 |
| Sine 30° | 0.5 |
| Cosine 60° | 0.5 |
| Tangent 45° | 1.0 |
| Divisor 0 | Validation error |
| All answers correct | 10 marks |
| Incorrect answers | Those marks are not awarded |

These are covered in `MathServiceTest.java`.

## Application screenshots

Add your screenshots to the `screenshots/` folder, then keep the lines below.

### Welcome Page
![Welcome Page](screenshots/home.png)

### Game Page
![Game Page](screenshots/game.png)

### Result Page
![Result Page](screenshots/result.png)

### Leaderboard
![Leaderboard](screenshots/leaderboard.png)

## GitHub project directory link

```
https://github.com/<username>/<repository>/tree/main/MathWhiz
```
