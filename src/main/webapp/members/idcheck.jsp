<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복체크 결과</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>
<body>
	 <c:choose>
		<c:when test="${result == true }">
			<table border="1" style="width:100%;height:150px;">
				<tr>
					<th>중복체크 결과
				</tr>
				<tr>
					<td align="center">이미 사용중인 ID 입니다.
				</tr>
				<tr>
					<td align="center"><button id="close">닫기</button></td>
				</tr>
			</table>
			<script>
				$("#close").on("click",function(){
					opener.document.getElementById("userid").value="";
					window.close();
				});
			</script>
		</c:when>
		<c:otherwise>
			<table border="1" style="width:100%;height:150px;">
				<tr>  
					<th colspan="2">중복체크 결과
				</tr>
				<tr>
					<td colspan="2" align="center">사용 가능한 ID 입니다.<br> 사용하시겠습니까?
				</tr>
				<tr>
					<td align="center"><button id="use">사용</button></td>
					<td align="center"><button id="cancel">취소</button></td>
				</tr>
			</table>
			<script>
				$("#use").on("click",function(){
					window.close();
				})
				$("#cancel").on("click",function(){
					opener.document.getElementById("userid").value="";
					window.close();
				})
			</script>
		</c:otherwise>
	</c:choose>
</body>
</html>