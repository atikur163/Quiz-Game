<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.game}"><c:redirect url="/index.jsp"/></c:if>
<c:if test="${not sessionScope.game.finished}"><c:redirect url="/game"/></c:if>
<c:set var="g" value="${sessionScope.game}"/>
<c:set var="pageTitle" value="Your score"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<section class="card result">
    <h1 class="result-title">
        <c:choose>
            <c:when test="${g.score == 10}">Perfect score, <c:out value="${g.playerName}"/>!</c:when>
            <c:when test="${g.score ge 7}">Great work, <c:out value="${g.playerName}"/>!</c:when>
            <c:when test="${g.score ge 4}">Good effort, <c:out value="${g.playerName}"/>.</c:when>
            <c:otherwise>Keep practising, <c:out value="${g.playerName}"/>.</c:otherwise>
        </c:choose>
    </h1>

    <p class="big-score"><span class="highlight">${g.score}</span><span class="out-of"> / ${g.maxScore}</span></p>

    <div class="table-wrap">
        <table class="table">
            <thead>
                <tr><th>Question</th><th>Result</th><th class="num-col">Marks</th></tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${g.results}">
                    <tr>
                        <td><c:out value="${row.topic}"/></td>
                        <td><span class="${row.correct ? 'tag-good' : 'tag-bad'}">${row.correct ? 'Correct' : 'Missed'}</span></td>
                        <td class="num-col">${row.marksAwarded} / ${row.marksPossible}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:choose>
        <c:when test="${g.saved}">
            <p class="note good-note">Saved to the leaderboard (difficulty: <c:out value="${g.difficulty}"/>).</p>
        </c:when>
        <c:when test="${not empty g.saveError}">
            <p class="alert" role="alert"><c:out value="${g.saveError}"/></p>
        </c:when>
    </c:choose>

    <div class="choice-row">
        <a class="btn" href="${ctx}/index.jsp">Play again</a>
        <a class="btn btn-light" href="${ctx}/leaderboard">View leaderboard</a>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
