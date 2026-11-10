# ATIK – MATH WHIZ

A web-based maths game built with **Java Servlets, JSP and JDBC (MySQL)**. Players enter their name, answer four maths questions one at a time, see their final score, and appear on a Top 10 leaderboard.

Every answer is checked by real Java methods. No answers are stored in advance.

## Project objectives

- Write reusable Java methods for prime numbers, modulus and trigonometry.
- Check every answer with Java calculations.
- Handle requests and responses with a Servlet and show pages with JSP.
- Save and read scores with JDBC and `PreparedStatement`.
- Show a sorted Top 10 leaderboard.
- Document and publish the project on GitHub.

## Features

- Questions appear one after another, with instant feedback after each one.
- Running score and a progress bar while playing.
- Trigonometry questions use common angles. Sometimes `tan(90°)` or `tan(270°)` appears, where the correct answer is *undefined*.
- Scores are saved with player name, score, difficulty and date/time.
- Top 10 leaderboard, sorted by score (highest first), then by time (earliest first).
- Light, graph-paper themed design that works on phones and desktops.

## Technologies used

| Area | Technology |
|------|------------|
| Language | Java 17 |
| Web | Jakarta Servlet 6, JSP 3.1, JSTL 3 |
| Server | Apache Tomcat 10.1+ (or the built-in embedded Tomcat) |
| Database | MySQL 8 with JDBC (MySQL Connector/J) |
| Build | Maven (WAR packaging) |
| Testing | JUnit 5 |
| Front end | HTML and CSS |

## Software requirements

| Software | Version |
|----------|---------|
| JDK | 17 or newer |
| Apache Tomcat | 10.1 or newer (optional, see "Run the application") |
| MySQL | 5.7 or 8.x |
| Maven | 3.8 or newer (IntelliJ includes it) |

> Tomcat 9 will not work. This project uses the `jakarta.*` packages.

## Project structure

```
MathWhiz/
├── src/main/java/
│   ├── controller/GameServlet.java     start, answer, next, result and leaderboard requests
│   ├── launcher/Main.java              runs the game with an embedded Tomcat (IDE use only)
│   ├── model/                          GameScore, GameState, TrigQuestion, Feedback, QuestionResult
│   ├── service/MathService.java        isPrime, calculateMod, calculateSin/Cos/Tan, scoring
│   ├── service/GameService.java        moves the game from step to step
│   └── dao/                            DBConnection, ScoreDAO (JDBC)
├── src/main/resources/db.properties    database settings
├── src/main/webapp/
│   ├── index.jsp  game.jsp  result.jsp  leaderboard.jsp
│   ├── css/style.css
│   └── WEB-INF/                        web.xml, shared header and footer
├── src/test/java/service/MathServiceTest.java
├── database/math_whiz_db.sql
├── screenshots/
├── pom.xml
└── README.md
```

## UML diagrams

The diagrams use Mermaid, which GitHub shows as pictures automatically.

### Class diagram

```mermaid
classDiagram
    direction LR

    class GameServlet {
        -GameService gameService
        -ScoreDAO scoreDAO
        #doGet(req, resp)
        #doPost(req, resp)
        -saveScore(GameState)
    }

    class GameService {
        +cleanName(String) String$
        +validateName(String) String$
        +startGame(String) GameState
        +submitPrimeNumber(GameState, String) String
        +submitPrimeChoice(GameState, String) String
        +submitModOperands(GameState, String, String) String
        +submitModAnswer(GameState, String) String
        +submitTrig(GameState, String) String
        +next(GameState) boolean
    }

    class MathService {
        +isPrime(int) int$
        +calculateMod(int, int) int$
        +calculateSin(double) double$
        +calculateCos(double) double$
        +calculateTan(double) double$
        +isTrigAnswerCorrect(String, double, String) boolean$
        +generateTrigQuestion(Random, TrigQuestion) TrigQuestion$
        +calculateScore(boolean, boolean, boolean, boolean) int$
    }

    class GameState {
        -String playerName
        -String difficulty
        -int step
        -Integer primeNumber
        -Integer modA
        -Integer modB
        -boolean[] correct
        -boolean saved
        +getScore() int
        +isFinished() boolean
        +getResults() List~QuestionResult~
    }

    class TrigQuestion {
        -String function
        -int angle
        +getExpression() String
    }

    class Feedback {
        -boolean correct
        -String title
        -String detail
        -int marksAwarded
        -int marksPossible
    }

    class QuestionResult {
        -String topic
        -boolean correct
        -int marksAwarded
        -int marksPossible
    }

    class GameScore {
        -int id
        -String playerName
        -int score
        -String difficulty
        -LocalDateTime playedAt
    }

    class ScoreDAO {
        +save(GameScore)
        +getTopScores(int) List~GameScore~
    }

    class DBConnection {
        +getConnection() Connection$
    }

    GameServlet --> GameService : uses
    GameServlet --> ScoreDAO : uses
    GameServlet ..> GameState : keeps in session
    GameService ..> MathService : calculates answers
    GameService ..> GameState : updates
    GameState "1" *-- "2" TrigQuestion
    GameState "1" o-- "0..1" Feedback
    GameState ..> QuestionResult : creates
    MathService ..> TrigQuestion : creates
    ScoreDAO ..> GameScore : reads and writes
    ScoreDAO ..> DBConnection : opens connection
```

### Game steps

```mermaid
stateDiagram-v2
    [*] --> Q1_EnterNumber
    Q1_EnterNumber --> Q1_YesOrNo : valid whole number
    Q1_YesOrNo --> Q1_Feedback : Yes or No
    Q1_Feedback --> Q2_EnterNumbers : Next
    Q2_EnterNumbers --> Q2_EnterRemainder : two numbers, divisor not 0
    Q2_EnterRemainder --> Q2_Feedback : answer
    Q2_Feedback --> Q3_Trig : Next
    Q3_Trig --> Q3_Feedback : answer
    Q3_Feedback --> Q4_Trig : Next
    Q4_Trig --> Q4_Feedback : answer
    Q4_Feedback --> Result : See my score
    Result --> [*]
```

### Sequence diagram: playing a game

```mermaid
sequenceDiagram
    actor Player
    participant JSP as JSP pages
    participant Servlet as GameServlet
    participant Game as GameService
    participant Math as MathService
    participant DAO as ScoreDAO
    participant DB as MySQL

    Player->>JSP: Enter name, press Start game
    JSP->>Servlet: POST /game (action=start)
    Servlet->>Game: startGame(name)
    Game->>Math: generateTrigQuestion() x2
    Servlet-->>Player: Redirect to /game (Question 1)

    loop Each answer
        Player->>JSP: Submit answer
        JSP->>Servlet: POST /game (action=answer)
        Servlet->>Game: submit...(state, input)
        Game->>Math: isPrime / calculateMod / calculateSin, Cos, Tan
        Math-->>Game: calculated value
        Game-->>Servlet: feedback stored in GameState
        Servlet-->>Player: Show feedback
        Player->>Servlet: POST /game (action=next)
    end

    Servlet->>Math: calculateScore(...) via GameState.getScore()
    Servlet->>DAO: save(GameScore)
    DAO->>DB: INSERT (PreparedStatement)
    Servlet-->>Player: Redirect to /result

    Player->>Servlet: GET /leaderboard
    Servlet->>DAO: getTopScores(10)
    DAO->>DB: SELECT ... ORDER BY score DESC, played_at ASC LIMIT 10
    DB-->>DAO: rows
    Servlet-->>Player: Leaderboard page
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

Leaderboard query used by the application:

```sql
SELECT id, player_name, score, difficulty, played_at
FROM game_scores
ORDER BY score DESC, played_at ASC
LIMIT 10;
```

## Run the application

First finish the database setup above. Then choose one option.

### Option 1: Run from the IDE (no Tomcat install needed)

1. Open the project folder (the one that contains `pom.xml`) as a Maven project in IntelliJ IDEA.
2. Wait for Maven to import the dependencies.
3. Open `src/main/java/launcher/Main.java` and click the green Run button next to `main`.
4. Open **http://localhost:8080/MathWhiz/**

### Option 2: Deploy a WAR file to Tomcat

1. Build the WAR file:

   ```bash
   mvn clean package
   ```

2. Copy `target/MathWhiz.war` into Tomcat's `webapps/` folder.
3. Start Tomcat (`bin/startup.bat` on Windows, `bin/startup.sh` on Linux and macOS).
4. Open **http://localhost:8080/MathWhiz/**

### Run the unit tests

```bash
mvn test
```

### Change the title

The title shown on every page is the `appTitle` value in `src/main/webapp/WEB-INF/web.xml`.

## Game rules and scoring system

The game asks four questions, one after another. After each question you see whether you were right.

| Question | Topic | What the player does | Marks |
|----------|-------|----------------------|-------|
| Q1 | Prime number | Types a number, then answers Yes or No: is it prime? | 2 |
| Q2 | Modulus | Types two numbers (the divisor can't be zero), then types the remainder | 2 |
| Q3 | Trigonometry | Gives sin, cos or tan of an angle | 3 |
| Q4 | Trigonometry | Gives sin, cos or tan of an angle | 3 |
| | | **Total** | **10** |

Rules:

- **Prime:** `isPrime(int)` returns 1 for a prime and 0 otherwise. Numbers below 2 are not prime.
- **Modulus:** `calculateMod(int, int)` uses `%`. The divisor must not be zero. Negative numbers follow Java's `%` rule.
- **Trigonometry:** angles are in degrees and converted to radians before `Math.sin()`, `Math.cos()` and `Math.tan()` are used. A decimal answer is accepted within ±0.01. Fractions such as `1/2` also work.
- **Undefined values:** for `tan(90°)` and `tan(270°)` the correct answer is *undefined*. Press the Undefined button or type it.
- **Difficulty:** every question is `NORMAL`. The value is saved in the database.

Scoring logic:

```java
int totalScore = 0;

if (primeCorrect) totalScore += 2;
if (modCorrect)   totalScore += 2;
if (trig1Correct) totalScore += 3;
if (trig2Correct) totalScore += 3;
```

## Main Java methods

```java
public static int isPrime(int number)
public static int calculateMod(int a, int b)
public static double calculateSin(double degree)
public static double calculateCos(double degree)
public static double calculateTan(double degree)   // NaN when undefined
```

## Test cases

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

These are covered by `MathServiceTest.java`.

## Application screenshots

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

## Author

**Atik**
