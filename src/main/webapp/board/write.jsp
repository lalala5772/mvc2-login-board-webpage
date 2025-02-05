<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작성하기</title>
<style>
/* 글 작성 페이지 스타일 */
.write-container {
	width: 80%;
	max-width: 700px;
	background: white;
	padding: 20px;
	margin: 50px auto;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.write-container h2 {
	text-align: center;
	margin-bottom: 20px;
}

.form-group {
	display: flex;
	flex-direction: column;
	margin-bottom: 20px;
}

.form-group label {
	font-weight: bold;
	margin-bottom: 10px;
}

.form-group input, .form-group textarea {
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 16px;
}

.button-group {
	display: flex;
	justify-content: space-between;
}

.submit-btn, .back-btn {
	padding: 12px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 16px;
}

.submit-btn {
	background: #007bff;
	color: white;
}

.submit-btn:hover {
	background: #0056b3;
}

.back-btn {
	background: #6c757d;
	color: white;
}

.back-btn:hover {
	background: #5a6268;
}

/* 반응형 스타일 */
@media ( max-width : 600px) {
	.write-container {
		width: 90%;
		padding: 15px;
	}
	.submit-btn, .back-btn {
		width: 48%;
		padding: 10px;
	}
}
</style>
</head>
<body>
	<div class="write-container">
	<h2>글 작성하기</h2>
	<form id="write-form" action="/write.board" method="POST">
		<div class="form-group">
			<label for="title">제목</label>
			<input type="text" id="title" name="title" placeholder="제목을 입력하세요" required>
		</div>

		<div class="form-group">
			<label for="contents">내용</label>
			<textarea id="contents" name="contents" rows="10" placeholder="내용을 입력하세요" required></textarea>
		</div>

		<div class="button-group">
			<button type="submit" class="submit-btn">작성완료</button>
			<button type="button" class="back-btn" onclick="window.location.href='list.board'">목록으로</button>
		</div>
	</form>
</div>


</body>
</html>