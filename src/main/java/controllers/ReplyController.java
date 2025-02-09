package controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.Statics;
import dao.ReplyDAO;
import dto.BoardDTO;
import dto.ReplyDTO;

@WebServlet("*.reply")
public class ReplyController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");

		String cmd = request.getRequestURI();

		System.out.println("클라이언트 요청: " + cmd);

		ReplyDAO dao = ReplyDAO.getInstance();

		if(cmd.equals("/writeReply.reply")) {
            HttpSession session = request.getSession();
            String writer = (String)session.getAttribute("username");

            if (writer == null) {
                response.sendRedirect("../members/login.jsp");
                return;
            }

            int parentSeq = Integer.parseInt(request.getParameter("parentSeq"));
            String contents = request.getParameter("contents");

            try {
                ReplyDTO dto = new ReplyDTO(0, writer, contents, 0, parentSeq);
                int rs = dao.insert(dto);
                
                if (rs > 0) {
                    // 댓글 작성 후 리다이렉트 (PRG 패턴)
                    String scpage = request.getParameter("cpage");
                    if (scpage == null) scpage = "1";
                    int cpage = Integer.parseInt(scpage);
                    if (cpage < 1) cpage = 1;
                    response.sendRedirect("details.board?cpage=" + cpage + "&id=" + parentSeq);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		else if(cmd.equals("/update.reply")) {
			int result;
			try {
				int id = Integer.parseInt(request.getParameter("id")); 
				String contents = request.getParameter("contents");  

				// 댓글 DTO 불러오기
				ReplyDTO replyDetail = dao.selectById(id);

				// 댓글 내용 업데이트
				result = dao.update(replyDetail, contents); // 댓글 업데이트 메서드 호출
				if(result > 0) {
					System.out.println("댓글 수정 성공");
					response.sendRedirect("details.board?id=" + replyDetail.getParentSeq()); 
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (cmd.equals("/delete.reply")) {
		    try {
		        int id = Integer.parseInt(request.getParameter("id")); 

		        // 댓글 DTO 불러오기
		        ReplyDTO replyDetail = dao.selectById(id);

		        // 댓글 삭제
		        int result = dao.delete(id);
		        if(result > 0) {
		            System.out.println("삭제 성공");
	
		            response.sendRedirect("details.board?id=" + replyDetail.getParentSeq());
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}

	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}


}
