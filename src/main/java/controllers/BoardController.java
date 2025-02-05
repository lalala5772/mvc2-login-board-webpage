package controllers;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.Statics;
import dao.BoardDAO;
import dto.BoardDTO;

@WebServlet("*.board")
public class BoardController extends HttpServlet{
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");

		String cmd = request.getRequestURI();

		System.out.println("클라이언트 요청: " + cmd);

		BoardDAO dao = BoardDAO.getInstance();

		if(cmd.equals("/list.board")){
			try {
				int cpage = Integer.parseInt(request.getParameter("cpage"));
				int end = cpage * Statics.recordCountPerPage;
				int start = end - (Statics.recordCountPerPage -1);

				List<BoardDTO> list = dao.selectFromTo(start, end);
				
				String navi = dao.getPageNavi(cpage);
				
				request.setAttribute("list", list);
				request.setAttribute("navi", navi);
				request.setAttribute("cpage", cpage);
				
				request.getRequestDispatcher("/board/list.jsp").forward(request, response);

			}catch(Exception e) {
				e.printStackTrace();
				response.sendRedirect("list.board?cpage=1");
			}
		}
		else if(cmd.equals("/towrite.board")){
			request.getRequestDispatcher("/board/write.jsp").forward(request, response);
		}
		else if(cmd.equals("/write.board")) {

			HttpSession session = request.getSession();
//		    String writer = (String)session.getAttribute("userid");  
		    String writer = (String)session.getAttribute("username");  
		    
		    if (writer == null) {
		        response.sendRedirect("../members/login.jsp");  // 로그인 페이지로 리다이렉트
		        return;  // 이후 코드를 실행하지 않도록 return
		    }
		    
		    // 폼에서 넘어온 제목과 내용 받기
		    String title = request.getParameter("title");
		    String contents = request.getParameter("contents"); 

		    // DB에 저장
		    try {
		        BoardDTO dto = new BoardDTO(0, writer, title, contents, 0); 
		        int rs = dao.insert(dto); 
		        if (rs > 0) {
		            request.getRequestDispatcher("list.board?cpage=1").forward(request, response);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		} 
		else if (cmd.equals("/details.board")) {
		    String idParam = request.getParameter("id"); 
		    int cpage = Integer.parseInt(request.getParameter("cpage"));
		    if (idParam != null && !idParam.isEmpty()) {
		        try {
		            int seq = Integer.parseInt(idParam);  
		            BoardDTO boardDetail = dao.selectById(seq); // 최신 데이터로 갱신
		            boardDetail.incrementViewCount(); // 조회수 증가
		            dao.updateBoard(boardDetail); // DB 업데이트
		            
		            request.setAttribute("boardDetail", boardDetail);
		            request.setAttribute("cpage", cpage);
		            request.getRequestDispatcher("board/details.jsp").forward(request, response);
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.sendRedirect("list.board?cpage=1"); 
		        }
		    } else {
		        response.sendRedirect("list.board?cpage=1"); 
		    }
		}
		else if (cmd.equals("/delete.board")) {
			int result;
			try {

				int seq = Integer.parseInt(request.getParameter("seq"));
				result = dao.deleteBoard(seq);
				if(result > 0) {
					System.out.println("삭제 성공");
					response.sendRedirect("list.board?cpage=1"); 
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (cmd.equals("/update.board")) {
			int result;
			try {
				int seq = Integer.parseInt(request.getParameter("seq"));
				BoardDTO boardDetail = dao.selectById(seq);
				
				String title = request.getParameter("title");
				String contents = request.getParameter("contents");

				result = dao.updateBoardDetails(boardDetail, title, contents);
				if(result > 0) {
					System.out.println("수정 성공");
					response.sendRedirect("details.board"); 
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
