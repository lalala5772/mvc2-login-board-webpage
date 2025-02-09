<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
<style>
body {
	font-family: 'Arial', sans-serif;
	background-color: #f4f4f4;
	margin: 0;
	padding: 20px;
}

.container {
	max-width: 800px;
	margin: 0 auto;
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h2, .editable-title {
	color: #333;
	font-size: 28px;
	border-bottom: 2px solid #ddd;
	padding-bottom: 10px;
	margin-bottom: 20px;
}

.editable-title {
	width: 100%;
	padding: 12px;
	font-size: 1.2em;
	border: 1px solid #ccc;
	border-radius: 8px;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.editable-title:focus {
	border-color: #007bff;
	box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
	outline: none;
}

.meta-info {
	font-size: 0.9em;
	color: #777;
	margin-bottom: 15px;
}

hr {
	border: none;
	border-top: 1px solid #eee;
	margin: 20px 0;
}

.contents, .editable-contents {
	font-size: 1.1em;
	color: #444;
	line-height: 1.8;
	white-space: pre-wrap;
}

.editable-contents {
	width: 100%;
	height: 200px;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 1em;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.editable-contents:focus {
	border-color: #007bff;
	box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
	outline: none;
}

.button-group {
	margin-top: 30px;
	text-align: right;
}

.button-group button {
	background-color: #007bff;
	color: white;
	border: none;
	padding: 12px 25px;
	margin-left: 10px;
	font-size: 1em;
	border-radius: 8px;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.2s ease;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.button-group button:hover {
	background-color: #0056b3;
	transform: translateY(-2px);
}

.button-group .list-btn, .button-group .back-btn {
	background-color: #6c757d;
}

.button-group .list-btn:hover, .button-group .back-btn:hover {
	background-color: #5a6268;
}

.hidden {
	display: none;
}

/* 댓글 섹션 스타일 */
#reply-section {
	margin: 50px auto 0;
	max-width: 800px;
	padding: 25px;
	background-color: #f9f9f9;
	border-radius: 10px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

#reply-section h3 {
	font-size: 22px;
	color: #333;
	margin-bottom: 20px;
	border-bottom: 2px solid #ddd;
	padding-bottom: 10px;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	font-weight: bold;
	margin-bottom: 10px;
	color: #333;
	font-size: 1.1em;
}

.form-group textarea {
	width: 90%;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 1em;
	resize: none;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.form-group textarea:focus {
	border-color: #007bff;
	box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
	outline: none;
}

@media ( max-width : 768px) {
	.container, #reply-section {
		margin: 20px;
		padding: 20px;
	}
	.button-group button {
		width: 100%;
		margin: 10px 0 0;
	}
}

/* 댓글 박스 스타일 */
/* .reply-item {
	background-color: #f9f9f9;
	padding: 15px;
	margin-bottom: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
} */
.reply-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}

.reply-header strong {
	font-size: 16px;
	color: #333;
}

.reply-date {
	font-size: 12px;
	color: #888;
}

.reply-content {
	font-size: 14px;
	color: #555;
	margin-bottom: 10px;
}

/* 버튼 그룹 스타일 */
.button-group {
	display: flex;
	gap: 10px;
}

.button-group button {
	padding: 8px 8px;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.2s ease;
}

.reply-item {
	position: relative; /* 버튼을 절대 위치로 배치하기 위해 설정 */
	/* padding: 15px; */
	margin-bottom: 15px;
	background-color: #f9f9f9;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.small-button-group {
	position: absolute;
	top: 10px; /* 댓글 상단에서 10px 내려옴 */
	right: 10px; /* 댓글 오른쪽에서 10px 안쪽으로 */
	display: flex;
	gap: 5px; /* 버튼 사이 간격 */
}

.small-button-group button {
	padding: 4px 8px; /* 버튼 크기 작게 */
	font-size: 12px; /* 글자 크기 작게 */
	border: none;
	border-radius: 4px;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.2s ease;
}

.edit-btn {
	background-color: #4CAF50;
	color: white;
}

.edit-btn:hover {
	background-color: #388E3C;
	transform: translateY(-2px);
}

.delete-btn {
	background-color: #f44336;
	color: white;
}

.delete-btn:hover {
	background-color: #d32f2f;
	transform: translateY(-2px);
}

/* 댓글 수정 창 */
.editable-reply {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
	resize: none;
	transition: border-color 0.3s ease, box-shadow 0.3s ease;
	margin-bottom: 10px;
}

.editable-reply:focus {
	border-color: #007bff;
	box-shadow: 0 0 6px rgba(0, 123, 255, 0.3);
	outline: none;
}

.hidden {
	display: none; /* 숨김 처리 */
}
</style>
</head>
<body>
	<div class="container">
		<!-- 폼 시작: 수정 완료 시 이 폼이 서버로 전송됨 -->
		<form id="edit-form" action="/update.board" method="post">
			<!-- 게시글 식별을 위한 seq 값 -->
			<input type="hidden" name="seq" value="${boardDetail.seq}">

			<!-- 제목: 수정 모드에서 input 필드로 변경됨 -->
			<h2 id="post-title">${boardDetail.title}</h2>

			<div class="meta-info">
				<span>작성자: ${boardDetail.writer}</span><br> <span>작성일: <fmt:formatDate
						value="${boardDetail.writeDate}" pattern="yyyy-MM-dd HH:mm:ss" />
				</span><br> <span>조회수: ${boardDetail.viewCount}</span>
			</div>

			<hr>
			<!-- 본문 내용: 수정 모드에서 textarea로 변경됨 -->
			<div id="post-contents" class="contents">
				${boardDetail.contents}</div>

			<div class="button-group">
				<button type="button" id="list-btn" class="list-btn"
					onclick="window.location.href='list.board?cpage=${cpage}'">목록으로</button>

				<c:if test="${username == boardDetail.writer}">
					<button type="button" id="delete-btn"
						onclick="if(confirm('정말 삭제하시겠습니까?')) window.location.href='/delete.board?seq=${boardDetail.seq}'">삭제하기</button>
					<button type="button" id="edit-btn" onclick="editableMode()">수정하기</button>
				</c:if>
			</div>
		</form>


		<div id="reply-section">
			<h3>댓글</h3>
			<div id="reply-list">
				<c:forEach var="reply" items="${replyList}">
					<div class="reply-item" data-reply-id="${reply.id}">
						<!-- 댓글 내용 및 작성자 -->
						<div class="reply-content-wrapper">
							<strong>작성자: ${reply.writer}</strong><br>
							<p class="reply-content">${reply.contents}</p>
							<small class="reply-date"> <fmt:formatDate
									value="${reply.writeDate}" pattern="yyyy-MM-dd HH:mm" />
							</small>
						</div>

						<!-- 수정 모드에서 나타날 폼 (초기에는 숨김) -->
						<form class="edit-reply-form hidden" action="/update.reply"
							method="post">
							<input type="hidden" name="id" value="${reply.id}">
							<!-- 여기서 name을 'id'로 변경 -->
							<textarea name="contents" class="editable-reply">${reply.contents}</textarea>
							<div class="small-button-group">
								<button type="submit" class="edit-btn">수정완료</button>
								<button type="button" class="delete-btn cancel-edit-btn">취소</button>
							</div>
						</form>
						<!-- 수정/삭제 버튼 -->
						<div class="small-button-group">
							<button class="edit-btn reply-edit-btn">수정</button>
							<button class="delete-btn" type="button" id="delete-btn"
						onclick="if(confirm('정말 삭제하시겠습니까?')) window.location.href='/delete.reply?id=${reply.id}'">삭제</button>
						</div>

						<hr>
					</div>
				</c:forEach>
			</div>

			<!-- 댓글 작성 폼 -->
			<form id="reply-form" action="/writeReply.reply" method="post">
				<input type="hidden" name="parentSeq" value="${boardDetail.seq}">

				<div class="form-group">
					<textarea id="contents" name="contents" rows="5"
						placeholder="댓글을 입력하세요" required></textarea>
				</div>

				<div class="button-group">
					<button type="submit" class="submit-btn">작성완료</button>
				</div>
			</form>

		</div>
	</div>

	<script>
		function editableMode() {
			const titleElement = document.getElementById('post-title');
			titleElement.outerHTML = `<input type="text" id="post-title" name="title" class="editable-title" value="${boardDetail.title}" required>`;

			const contentsElement = document.getElementById('post-contents');
			contentsElement.outerHTML = `<textarea id="post-contents" name="contents" class="editable-contents" required>${boardDetail.contents}</textarea>`;

			document.getElementById('edit-btn').innerText = '수정완료';
			document.getElementById('edit-btn').setAttribute('onclick',
					'document.getElementById("edit-form").submit()');

			document.getElementById('list-btn').classList.add('hidden');
			document.getElementById('delete-btn').classList.add('hidden');
		}
		
		// 댓글 수정 모드로 전환
		document.querySelectorAll('.reply-edit-btn').forEach(button => {
		    button.addEventListener('click', function() {
		        const replyItem = this.closest('.reply-item');
		        const replyContentWrapper = replyItem.querySelector('.reply-content-wrapper');
		        const editForm = replyItem.querySelector('.edit-reply-form');
		        const editButtonGroup = this.closest('.reply-item').querySelector('.small-button-group:not(.edit-reply-form .small-button-group)');


		        // 댓글 내용 숨기기 & 수정 폼 표시
		        replyContentWrapper.classList.add('hidden');
		        editForm.classList.remove('hidden');

		        // 수정/삭제 버튼 숨기기
		        editButtonGroup.classList.add('hidden');
		    });
		});

		// 댓글 수정 취소
		document.querySelectorAll('.cancel-edit-btn').forEach(button => {
    button.addEventListener('click', function() {
        const replyItem = this.closest('.reply-item');
        const replyContentWrapper = replyItem.querySelector('.reply-content-wrapper');
        const editForm = replyItem.querySelector('.edit-reply-form');
        const editButtonGroup = replyItem.querySelector('.small-button-group');

        // 댓글 내용 표시 & 수정 폼 숨기기
        replyContentWrapper.classList.remove('hidden');
        editForm.classList.add('hidden');

        // 수정/삭제 버튼 다시 표시
        editButtonGroup.classList.remove('hidden');
    });
});

	</script>
</body>
</html>
