<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${not requestScope.loaded}"><c:redirect url="/leaderboard"/></c:if>
<c:set var="pageTitle" value="Leaderboard"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<section class="card board">
    <h1 class="q-title">Top 10 scores</h1>

    <c:choose>
        <c:when test="${requestScope.dbError}">
            <p class="alert" role="alert">The leaderboard can't load. Check that MySQL is running and that db.properties is correct.</p>
        </c:when>
        <c:when test="${empty scores}">
            <p class="hint">No scores yet. Play a game to be the first on the board.</p>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
                <table class="table">
                    <thead>
                        <tr>
                            <th class="num-col">Rank</th>
                            <th>Player</th>
                            <th class="num-col">Score</th>
                            <th>Difficulty</th>
                            <th>Played</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${scores}" varStatus="loop">
                            <tr class="${loop.count == 1 ? 'first-place' : ''}">
                                <td class="num-col">${loop.count}</td>
                                <td><c:out value="${s.playerName}"/></td>
                                <td class="num-col"><strong>${s.score}</strong> / 10</td>
                                <td><c:out value="${s.difficulty}"/></td>
                                <td><c:out value="${s.playedAtText}"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="choice-row">
        <a class="btn" href="${ctx}/index.jsp">Play a game</a>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
