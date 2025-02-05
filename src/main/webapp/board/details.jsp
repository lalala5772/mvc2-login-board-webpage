<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
            padding: 10px;
            font-size: 1.2em;
            border: 1px solid #ccc;
            border-radius: 5px;
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
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
        }

        .button-group {
            margin-top: 30px;
            text-align: right;
        }

        .button-group button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            margin-left: 10px;
            font-size: 1em;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button-group button:hover {
            background-color: #0056b3;
        }

        .button-group .list-btn {
            background-color: #6c757d;
        }

        .button-group .list-btn:hover {
            background-color: #5a6268;
        }

        .hidden {
            display: none;
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
                <span>작성자: ${boardDetail.writer}</span><br>
                <span>작성일: 
                    <fmt:formatDate value="${boardDetail.writeDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                </span><br>
                <span>조회수: ${boardDetail.viewCount}</span>
            </div>

            <hr>
            <!-- 본문 내용: 수정 모드에서 textarea로 변경됨 -->
            <div id="post-contents" class="contents">
                ${boardDetail.contents}
            </div>

            <div class="button-group">
                <button type="button" id="list-btn" class="list-btn" onclick="window.location.href='list.board?cpage=${cpage}'">목록으로</button>

                <c:if test="${username == boardDetail.writer}">
                    <button type="button" id="delete-btn" onclick="if(confirm('정말 삭제하시겠습니까?')) window.location.href='/delete.board?seq=${boardDetail.seq}'">삭제하기</button>
                    <button type="button" id="edit-btn" onclick="editableMode()">수정하기</button>
                </c:if>
            </div>
        </form>
    </div>

    <script>
        function editableMode() {
            // 제목을 input 필드로 변경
            const titleElement = document.getElementById('post-title');
            const originalTitle = titleElement.innerText;
            titleElement.outerHTML = `<input type="text" id="post-title" name="title" class="editable-title" value="${boardDetail.title}" required>`;

            // 본문 내용을 textarea로 변경
            const contentsElement = document.getElementById('post-contents');
            const originalContents = contentsElement.innerText;
            contentsElement.outerHTML = `<textarea id="post-contents" name="contents" class="editable-contents" required>${boardDetail.contents}</textarea>`;

            // 버튼 변경: '수정하기' -> '수정완료', 나머지 버튼 숨기기
            document.getElementById('edit-btn').innerText = '수정완료';
            document.getElementById('edit-btn').setAttribute('onclick', 'document.getElementById("edit-form").submit()');

            document.getElementById('list-btn').classList.add('hidden');
            document.getElementById('delete-btn').classList.add('hidden');
        }
    </script>
</body>
</html>
