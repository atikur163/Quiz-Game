<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.game}"><c:redirect url="/index.jsp"/></c:if>
<c:if test="${sessionScope.game.finished}"><c:redirect url="/result"/></c:if>
<c:set var="g" value="${sessionScope.game}"/>
<c:set var="pageTitle" value="Question ${g.questionNumber}"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="hud">
    <span>Playing as <strong><c:out value="${g.playerName}"/></strong></span>
    <span class="score-chip">Score <strong>${g.score}</strong> / ${g.maxScore}</span>
</div>

<ol class="progress" aria-label="Progress">
    <c:forEach begin="1" end="4" var="i">
        <c:choose>
            <c:when test="${g.correctAnswers[i - 1]}"><li class="right"><span class="sr-only">Question ${i} correct</span></li></c:when>
            <c:when test="${i lt g.questionNumber or (i == g.questionNumber and not empty g.feedback)}"><li class="wrong"><span class="sr-only">Question ${i} missed</span></li></c:when>
            <c:otherwise><li class="${i == g.questionNumber ? 'current' : ''}"><span class="sr-only">Question ${i}</span></li></c:otherwise>
        </c:choose>
    </c:forEach>
</ol>

<section class="card question">
    <div class="q-head">
        <h1 class="q-title">Question ${g.questionNumber} of 4</h1>
        <span class="badge">${g.currentMarks} marks</span>
    </div>

    <c:if test="${not empty error}">
        <p class="alert" role="alert"><c:out value="${error}"/></p>
    </c:if>

    <c:choose>

        <%-- After an answer: show the result and wait for "Next" --%>
        <c:when test="${not empty g.feedback}">
            <div class="feedback ${g.feedback.correct ? 'good' : 'bad'}" role="status">
                <h2><c:out value="${g.feedback.title}"/></h2>
                <p><c:out value="${g.feedback.detail}"/></p>
                <p class="earned">${g.feedback.marksAwarded} of ${g.feedback.marksPossible} marks</p>
            </div>
            <form method="post" action="${ctx}/game">
                <input type="hidden" name="action" value="next">
                <button class="btn" type="submit" autofocus>
                    <c:choose>
                        <c:when test="${g.step == 5}">See my score</c:when>
                        <c:otherwise>Next question</c:otherwise>
                    </c:choose>
                </button>
            </form>
        </c:when>

        <%-- Question 1, part 1: player picks a number --%>
        <c:when test="${g.step == 0}">
            <p class="expression">Test a number</p>
            <p class="hint">Type any whole number. Next, you will say whether it is prime.</p>
            <form method="post" action="${ctx}/game" class="answer-form" autocomplete="off">
                <input type="hidden" name="action" value="answer">
                <label for="value">Your number</label>
                <input id="value" name="value" type="text" inputmode="numeric" required autofocus
                       placeholder="For example 29"
                       value="<c:out value="${param.value}"/>">
                <button class="btn" type="submit">Continue</button>
            </form>
        </c:when>

        <%-- Question 1, part 2: Yes or No --%>
        <c:when test="${g.step == 1}">
            <p class="expression">Is <span class="num"><c:out value="${g.primeNumber}"/></span> a prime number?</p>
            <p class="hint">A prime has exactly two divisors: 1 and itself.</p>
            <form method="post" action="${ctx}/game" class="choice-row">
                <input type="hidden" name="action" value="answer">
                <button class="btn" type="submit" name="choice" value="yes">Yes</button>
                <button class="btn btn-light" type="submit" name="choice" value="no">No</button>
            </form>
        </c:when>

        <%-- Question 2, part 1: player picks two numbers --%>
        <c:when test="${g.step == 2}">
            <p class="expression">Pick two numbers</p>
            <p class="hint">You will find the remainder when the first number is divided by the second. The second number can't be zero.</p>
            <form method="post" action="${ctx}/game" class="answer-form" autocomplete="off">
                <input type="hidden" name="action" value="answer">
                <div class="two-fields">
                    <div>
                        <label for="a">Number to divide</label>
                        <input id="a" name="a" type="text" inputmode="numeric" required autofocus
                               placeholder="For example 17"
                               value="<c:out value="${param.a}"/>">
                    </div>
                    <div>
                        <label for="b">Divide by</label>
                        <input id="b" name="b" type="text" inputmode="numeric" required
                               placeholder="For example 5"
                               value="<c:out value="${param.b}"/>">
                    </div>
                </div>
                <button class="btn" type="submit">Continue</button>
            </form>
        </c:when>

        <%-- Question 2, part 2: player enters the remainder --%>
        <c:when test="${g.step == 3}">
            <p class="expression"><span class="num">${g.modA}</span> mod <span class="num">${g.modB}</span> = ?</p>
            <p class="hint">
                What is the remainder when ${g.modA} is divided by ${g.modB}?
                <c:if test="${g.modA lt 0 or g.modB lt 0}">
                    Negative numbers follow Java's % rule: the remainder takes the sign of the first number.
                </c:if>
            </p>
            <form method="post" action="${ctx}/game" class="answer-form" autocomplete="off">
                <input type="hidden" name="action" value="answer">
                <label for="value">Remainder</label>
                <input id="value" name="value" type="text" inputmode="numeric" required autofocus
                       placeholder="Your answer"
                       value="<c:out value="${param.value}"/>">
                <button class="btn" type="submit">Check answer</button>
            </form>
        </c:when>

        <%-- Questions 3 and 4: trigonometry --%>
        <c:otherwise>
            <c:set var="q" value="${g.currentTrig}"/>
            <p class="expression"><c:out value="${q.expression}"/> = ?</p>
            <p class="hint">
                Round to 2 decimals, or type a fraction like 1/2.
                <c:if test="${q.tan}">If the value doesn't exist, press Undefined.</c:if>
            </p>
            <form method="post" action="${ctx}/game" class="answer-form" autocomplete="off">
                <input type="hidden" name="action" value="answer">
                <label for="value">Your answer</label>
                <input id="value" name="value" type="text" inputmode="decimal" required autofocus
                       placeholder="For example 0.5"
                       value="<c:out value="${param.value}"/>">
                <div class="choice-row">
                    <button class="btn" type="submit">Check answer</button>
                    <c:if test="${q.tan}">
                        <button class="btn btn-light" type="submit" name="undefined" value="1" formnovalidate>Undefined</button>
                    </c:if>
                </div>
            </form>
        </c:otherwise>

    </c:choose>
</section>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
