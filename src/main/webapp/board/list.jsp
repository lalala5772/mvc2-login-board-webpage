<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	background-color: #f8f8f8;
}

.board-container {
	width: 80%;
	max-width: 900px;
	min-height: 500px;
	background: white;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	text-align: center;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

h2 {
	margin-bottom: 20px;
}

.board-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: auto;
}

.board-table th, .board-table td {
	border: 1px solid #ddd;
	padding: 12px;
	text-align: center;
}

/* 비율 설정: seq:1, 제목:5, 작성자:2, 날짜:2, 조회:2 */
.board-table th.seq, .board-table td.seq {
	width: 10%;
}

.board-table th.title, .board-table td.title {
	width: 50%;
	text-align: left;
	padding-left: 15px;
}

.board-table th.author, .board-table td.author {
	width: 10%;
}

.board-table th.date, .board-table td.date {
	width: 10%;
}

.board-table th.views, .board-table td.views {
	width: 10%;
}

.board-table th {
	background: #f4f4f4;
}

.no-content {
	color: gray;
	height: 300px;
	vertical-align: middle;
}

.pagination {
	margin: 20px 0;
}

.pagination a {
	text-decoration: none;
	padding: 8px 12px;
	margin: 2px;
	color: black;
	border: 1px solid #ddd;
	border-radius: 4px;
	display: inline-block;
}

.pagination a:hover {
	background: #ddd;
}

.write-btn {
	padding: 10px 20px;
	border: none;
	background: #007bff;
	color: white;
	border-radius: 4px;
	cursor: pointer;
	align-self: flex-end;
}

.write-btn:hover {
	background: #0056b3;
}

/* 반응형 스타일 */
@media ( max-width : 600px) {
	.board-container {
		width: 90%;
		padding: 15px;
	}
	.board-table th, .board-table td {
		padding: 8px;
	}
	.pagination a {
		padding: 6px 10px;
	}
	.write-btn {
		padding: 8px 16px;
	}
}
</style>
</head>
<body>
	<div class="board-container">
		<h2>자유게시판</h2>
		<table class="board-table">
			<thead>
				<tr>
					<th class="seq">번호</th>
					<th class="title">제목</th>
					<th class="author">작성자</th>
					<th class="date">날짜</th>
					<th class="views">조회</th>
				</tr>
			</thead>
			<tbody id="board-content">
				<c:choose>
					<c:when test="${not empty list}">
						<!-- 게시판 글이 있을 때 -->
						<c:forEach var="board" items="${list}">
							<tr>
								<td class="seq">${board.seq}</td>
								<td class="title">
									<a href="${pageContext.request.contextPath}/details.board?id=${board.seq}&cpage=${cpage}">${board.title}</a>
								</td>
								<td class="author">${board.writer}</td>
								<td class="date">${board.displayTime}</td>
								<td class="views">${board.viewCount}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<!-- 게시판 글이 없을 때 -->
						<tr>
							<td colspan="5" class="no-content">표시할 내용이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>

		</table>

		<div class="pagination">
			${navi}
		</div>
		 <!-- 페이지 네비게이션 -->
    <%-- <div class="pagination">
        <c:forEach var="pageNum" items="${pageNumbers}">
            <a href="javascript:void(0);" class="page-link" data-page="${pageNum}">${pageNum}</a>
        </c:forEach>
    </div> --%>
		

		<button class="write-btn">
			<a href="/towrite.board"> 작성하기</a>
		</button>
	</div>
	
	<!-- <script>
        $(document).ready(function () {
            // 현재 페이지 세션 저장
            let savedPage = sessionStorage.getItem("currentPage");
            if (savedPage) {
                $(".page-link[data-page='" + savedPage + "']").addClass("active");
            }

            $(".page-link").on("click", function () {
                /* let selectedPage = $(this).data("page"); */
                let selectedPage = $(this).html();
                /* alert(selectPage); */
                sessionStorage.setItem("currentPage", selectedPage);
                window.location.href = "/list.board?cpage=" + selectedPage;
            }); 
            
        });
    </script> -->

	<script type="text/javascript">
    if (performance.navigation.type === 2) { // 페이지가 새로고침되었는지 확인
        window.location.reload(); // 페이지 새로고침
    }
</script>


</body>
</html>