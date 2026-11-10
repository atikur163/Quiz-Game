<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Welcome"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<section class="card welcome">
    <h1 class="hero-title"><c:out value="${initParam.appTitle}"/></h1>
    <p class="lead">Four questions, one at a time. Prime numbers, remainders and trigonometry. Ten marks to win.</p>

    <ul class="marks-row" aria-label="Marks for each question">
        <li><strong>2</strong> Prime</li>
        <li><strong>2</strong> Modulus</li>
        <li><strong>3</strong> Trig</li>
        <li><strong>3</strong> Trig</li>
    </ul>

    <c:if test="${not empty error}">
        <p class="alert" role="alert"><c:out value="${error}"/></p>
    </c:if>

    <form method="post" action="${ctx}/game" class="answer-form" autocomplete="off">
        <input type="hidden" name="action" value="start">
        <label for="playerName">Your name</label>
        <input id="playerName" name="playerName" type="text" maxlength="30" required autofocus
               placeholder="Type your name"
               value="<c:out value="${not empty param.playerName ? param.playerName : sessionScope.game.playerName}"/>">
        <button class="btn" type="submit">Start game</button>
    </form>
</section>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
