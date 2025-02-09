<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
// JSP 내장 객체 session을 바로 사용
// 로그인 후 반환받은 username 객체를 받을 수 있음
String username = (String)session.getAttribute("username");

String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="ko">


<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>넥슨</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/8.4.5/swiper-bundle.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Arial', sans-serif;
	background-color: #f5f5f5;
}

#wrapper {
	width: 100%;
	max-width: 1920px;
	margin: 0 auto;
}

/* 헤더 스타일 */
.header {
	width: 100%;
	background-color: #1a1a1a;
	padding: 20px 0;
	border-bottom: 1px solid #333;
}

.header-container {
	max-width: 1200px;
	margin: 0 auto;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 20px;
}

.header-nav {
	display: flex;
	gap: 30px;
}

.header-nav a {
	color: white;
	text-decoration: none;
	font-size: 16px;
}

/* Swiper 배너 영역 */
.swiper {
	width: 100%;
	height: 480px;
}

.swiper-slide {
	position: relative;
}

.swiper-slide img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.slide-content {
	position: absolute;
	bottom: 0;
	left: 0;
	right: 0;
	background: rgba(0, 0, 0, 0.7);
	color: white;
	padding: 20px;
}

.slide-content h2 {
	font-size: 24px;
	margin-bottom: 10px;
}

.slide-content p {
	font-size: 16px;
}

/* 로그인과 추천게임 컨테이너 */
.main-content-wrapper {
	max-width: 1200px;
	margin: 20px auto;
	display: flex;
	gap: 20px;
	padding: 0 20px;
}

/* 로그인 영역 */
.login-section {
	width: 300px;
	padding: 20px;
	border: 1px solid #ddd;
	background: white;
}

.login-container {
	display: flex;
	flex-direction: column;
}

.login-main {
	margin-bottom: 20px;
}

.login-button, .login-input>.login-button {
	display: block;
	width: 100%;
	padding: 12px;
	background: #1a1a1a;
	color: white;
	text-align: center;
	margin-bottom: 10px;
	text-decoration: none;
	border-radius: 4px;
}

/* 로그인 필드 추가 - 미르 */
.login-input-field {
	/* width: 320px; */
	/* width: 100%; */
	/* padding: 30px; */
	
}

.login-field {
	padding: 20px 0px;
	width: 300px;
	position: relative;
}

.login-icon {
	position: absolute;
	top: 30px;
	color: #7875B5;
}

.login-input {
	border: none;
	border-bottom: 2px solid #D1D1D4;
	background: none;
	padding: 10px;
	padding-left: 24px;
	font-weight: 700;
	width: 75%;
	transition: .2s;
}

.login-input:active, .login-input:focus, .login-input:hover {
	outline: none;
	border-bottom-color: #6A679E;
}

/* 추천게임 영역 */
.myInfo {
	flex: 1;
	padding: 20px;
	border: 1px solid #ddd;
	background: white;
}

.title {
	margin-bottom: 20px;
	border-bottom: 1px solid #ddd;
	padding-bottom: 10px;
}

.recommendGame {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
}

.game-card {
	border: 1px solid #ddd;
	padding: 10px;
	background: white;
}

.game-card img {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

/* 전체게임 영역 */
#allGame {
	width: 100%;
	max-width: 1200px;
	margin: 0 auto 40px;
	padding: 20px;
	border: 1px solid #ddd;
	background: white;
}

.game-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-top: 20px;
}

/* 푸터 */
.footer {
	width: 100%;
	background: #1a1a1a;
	color: #999;
	padding: 40px 0;
}

.footer-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 20px;
}

.footer-links {
	display: flex;
	justify-content: space-between;
	margin-bottom: 30px;
}

.footer-column {
	flex: 1;
}

.footer-column h3 {
	color: white;
	margin-bottom: 15px;
}

.footer-column ul {
	list-style: none;
}

.footer-column ul li {
	margin-bottom: 10px;
}

.footer-column a {
	color: #999;
	text-decoration: none;
}

.footer-bottom {
	border-top: 1px solid #333;
	padding-top: 20px;
	text-align: center;
}
</style>
</head>

<body>
	<c:if test="${not empty signupSuccess}">
		<script>
        alert("${signupSuccess}");
    </script>
	</c:if>

	<div id="wrapper">
		<!-- 헤더 -->
		<header class="header">
			<div class="header-container">
				<h1 style="color: white;">NEXON</h1>
				<nav class="header-nav">
					<a href="#">PC</a> <a href="#">모바일</a> <a href="list.board?cpage=1">회원게시판</a>
					<a href="#">고객센터</a>
				</nav>
			</div>
		</header>

		<!-- Swiper 배너 -->
		<div class="swiper">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<img src="https://picsum.photos/1920/480" alt="배너 1">
					<div class="slide-content">
						<h2>메이플스토리</h2>
						<p>새로운 업데이트와 함께 찾아온 신규 컨텐츠를 만나보세요!</p>
					</div>
				</div>
				<div class="swiper-slide">
					<img src="https://picsum.photos/1920/480" alt="배너 2">
					<div class="slide-content">
						<h2>던전앤파이터</h2>
						<p>새로운 캐릭터 업데이트! 지금 바로 만나보세요.</p>
					</div>
				</div>
				<div class="swiper-slide">
					<img src="https://picsum.photos/1920/480" alt="배너 3">
					<div class="slide-content">
						<h2>FIFA ONLINE 4</h2>
						<p>신규 시즌 업데이트! 새로운 선수들과 함께하세요.</p>
					</div>
				</div>
			</div>
			<div class="swiper-pagination"></div>
			<div class="swiper-button-next"></div>
			<div class="swiper-button-prev"></div>
		</div>

		<!-- 메인 콘텐츠 -->
		<div class="main-content-wrapper">
			<!-- 추천 게임 -->
			<div class="myInfo">
				<div class="title">
					<h2>추천게임</h2>
				</div>
				
				<div class="recommendGame">
					<div class="game-card">
						<a href="game1.jsp"> <img src="https://picsum.photos/285/200"
							alt="게임 1">
						</a>
					</div>
					<div class="game-card">
						<a href="game2.jsp"> <img src="https://picsum.photos/285/200"
							alt="게임 2">
						</a>
					</div>
					<div class="game-card">
						<a href="game3.jsp"> <img src="https://picsum.photos/285/200"
							alt="게임 3">
						</a>
					</div>
					<div class="game-card">
						<a href="game4.jsp"> <img src="https://picsum.photos/285/200"
							alt="게임 4">
						</a>
					</div>
				</div>

			</div>

			<!-- 로그인 섹션 -->
			<div class="login-section">
				<div class="login-container">
					<!-- session username기록 있을 경우 (login되어 있을 경우) -->
					<!-- 로그인 성공 메시지 -->

					<% if (username != null) { %>
					<div class="mb-4">
						<h3><%= username %>님 안녕하세요!
						</h3>
						<p>로그인에 성공했습니다.</p>
						<a href="/logout.members"><button>로그아웃</button></a>
						<!-- 로그아웃 버튼 -->
					</div>
				</div>
				<% } else { %>
				<div class="login-main">
					<h2 style="margin-bottom: 20px;">로그인</h2>
					<form class="login-input-field" action="/login.members"
						method="post">
						<div class="login-field">
							<i class="login-icon fas fa-user"></i> <input type="text"
								class="login-input" name="id" placeholder="User name / Email"
								required>
						</div>
						<div class="login-field">
							<i class="login-icon fas fa-lock"></i> <input type="password"
								class="login-input" name="passwd" placeholder="Password"
								required>
						</div>
						<input type="submit" value="로그인 하기" class="login-button">
					</form>
					<a href="#" class="login-button" style="background: #4285f4;">Google
						로그인</a> <a href="#" class="login-button" style="background: #3b5998;">Facebook로그인</a>
				</div>
				<div class="login-options">
					<h3 style="margin-bottom: 15px;">빠른 메뉴</h3>
					<a href="#" style="display: block; margin-bottom: 10px;">ID 찾기</a>
					<a href="#" style="display: block; margin-bottom: 10px;">비밀번호
						찾기</a> <a href="members/signup.jsp" style="display: block;">회원가입</a>
				</div>
				<% } %>
			</div>

		</div>
	</div>
	</div>

	<!-- 전체 게임 -->
	<div id="allGame">
		<h2>전체게임</h2>
		<div class="game-grid">
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 1">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 2">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 3">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 4">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 5">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 6">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 7">
			</div>
			<div class="game-card">
				<img src="https://picsum.photos/285/200" alt="게임 8">
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<footer class="footer">
		<div class="footer-container">
			<div class="footer-links">
				<div class="footer-column">
					<h3>회사소개</h3>
					<ul>
						<li><a href="#">넥슨 소개</a></li>
						<li><a href="#">연혁</a></li>
						<li><a href="#">채용안내</a></li>
					</ul>
				</div>
				<div class="footer-column">
					<h3>고객지원</h3>
					<ul>
						<li><a href="#">고객센터</a></li>
						<li><a href="#">보안센터</a></li>
						<li><a href="#">PC방 찾기</a></li>
					</ul>
				</div>
				<div class="footer-column">
					<h3>정책</h3>
					<ul>
						<li><a href="#">이용약관</a></li>
						<li><a href="#">개인정보처리방침</a></li>
						<li><a href="#">청소년보호정책</a></li>
					</ul>
				</div>
			</div>
			<div class="footer-bottom">
				<p>© NEXON Korea Corporation All Rights Reserved.</p>
			</div>
		</div>
	</footer>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/8.4.5/swiper-bundle.min.js"></script>
	<script>
		new Swiper('.swiper', {
			loop : true,
			autoplay : {
				delay : 3000,
				disableOnInteraction : false,
			},
			pagination : {
				el : '.swiper-pagination',
				clickable : true,
			},
			navigation : {
				nextEl : '.swiper-button-next',
				prevEl : '.swiper-button-prev',
			},
		});
		
		
		//login 실패 시 출력 
        <% if ("fail".equals(status)) { %>
            alert("로그인에 실패했습니다. 다시 시도하세요.");
        <% } else if ("error".equals(status)) { %>
            alert("오류가 발생했습니다. 관리자에게 문의하세요.");
        <% } %>
	</script>
</body>

</html>
