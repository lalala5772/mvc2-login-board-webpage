package controllers;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import commons.Statics;
import dao.BoardDAO;
import dao.FilesDAO;
import dao.ReplyDAO;
import dto.BoardDTO;
import dto.FilesDTO;
import dto.ReplyDTO;

@WebServlet("*.board")
public class BoardController extends HttpServlet{
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");

		String cmd = request.getRequestURI();

		System.out.println("클라이언트 요청: " + cmd);

		BoardDAO dao = BoardDAO.getInstance();
		ReplyDAO replyDao = ReplyDAO.getInstance();
		FilesDAO fdao = new FilesDAO();

		
//		try {
//		    String scpage = request.getParameter("cpage");
//		    if (scpage == null) scpage = "1";
//
//		    int cpage = Integer.parseInt(scpage);
//		    if (cpage < 1) {
//		        cpage = 1;
//		    }
//
//		    // 게시글 목록 조회
//		    int end = cpage * Statics.recordCountPerPage;
//		    int start = end - (Statics.recordCountPerPage - 1);
//		    List<BoardDTO> list = dao.selectFromTo(start, end);
//
//		    // 페이지 네비게이션 계산
//		    int totalCount = dao.getRecordTotalCount();
//		    int pageTotalCount = (int) Math.ceil((double) totalCount / Statics.recordCountPerPage);
//		    int currentPageGroup = (cpage - 1) / Statics.naviCountPerPage;
//		    int startNavi = currentPageGroup * Statics.naviCountPerPage + 1;
//		    int endNavi = Math.min(startNavi + Statics.naviCountPerPage - 1, pageTotalCount);
//
//		    List<Integer> pageNumbers = new ArrayList<>();
//		    if (startNavi > 1) {
//		        pageNumbers.add(startNavi - 1); // 이전 페이지
//		    }
//		    for (int i = startNavi; i <= endNavi; i++) {
//		        pageNumbers.add(i);
//		    }
//		    if (endNavi < pageTotalCount) {
//		        pageNumbers.add(endNavi + 1); // 다음 페이지
//		    }
//
//		    // 모델에 데이터 저장
//		    request.setAttribute("list", list);
//		    request.setAttribute("pageNumbers", pageNumbers);
//		    request.setAttribute("cpage", cpage);
//		    request.setAttribute("totalPages", pageTotalCount);
//
//		    // 뷰로 전달
//		    request.getRequestDispatcher("/board/list.jsp").forward(request, response);
//
//		} catch (Exception e) {
//		    e.printStackTrace();
//		    response.sendRedirect("/error.jsp");
//		}

		if(cmd.equals("/list.board")) {
		    try {
		        String scpage = request.getParameter("cpage");
		        if (scpage == null) scpage = "1";
		        
		        int cpage = Integer.parseInt(scpage);
		        if (cpage < 1) {
		            cpage = 1;
		        }
		        
		        // 게시글 목록 조회
		        int end = cpage * Statics.recordCountPerPage;
		        int start = end - (Statics.recordCountPerPage - 1);
		        List<BoardDTO> list = dao.selectFromTo(start, end);
		        
		        // 페이지 네비게이션 계산
		        int totalCount = dao.getRecordTotalCount();
		        int pageTotalCount = (int) Math.ceil((double) totalCount / Statics.recordCountPerPage);
		        int currentPageGroup = (cpage - 1) / Statics.naviCountPerPage;
		        int startNavi = currentPageGroup * Statics.naviCountPerPage + 1;
		        int endNavi = Math.min(startNavi + Statics.naviCountPerPage - 1, pageTotalCount);
		        
		        StringBuilder navi = new StringBuilder();
		        if (startNavi > 1) {
		            navi.append("<a href='/list.board?cpage=" + (startNavi - 1) + "'>이전</a>");
		        }
		        for (int i = startNavi; i <= endNavi; i++) {
		            navi.append("<a href='/list.board?cpage=" + i + "'>" + i + "</a>");
		        }
		        if (endNavi < pageTotalCount) {
		            navi.append("<a href='/list.board?cpage=" + (endNavi + 1) + "'>다음</a>");
		        }
		        
		        // 모델에 데이터를 담고, 뷰로 전달
		        request.setAttribute("list", list);
		        request.setAttribute("navi", navi.toString());
		        request.setAttribute("cpage", cpage);
		        
		        // 뷰로 전달
		        request.getRequestDispatcher("/board/list.jsp").forward(request, response);
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendRedirect("list.board?cpage=1");
		    }
		}

		else if(cmd.equals("/towrite.board")){
			request.getRequestDispatcher("/board/write.jsp").forward(request, response);
		}
		else if(cmd.equals("/write.board")) {
			
			int maxSize = 1024 * 1024 * 10; //10메가바이
			String savePath = request.getServletContext().getRealPath("upload");
//			System.out.println(savePath);
			
			File filePath = new File(savePath);
			if(!filePath.exists()) {
				filePath.mkdir();
			}
			MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "utf8", new DefaultFileRenamePolicy());
			
			response.sendRedirect("list.board?cpage=1");
			HttpSession session = request.getSession();
            String writer = (String)session.getAttribute("username");
           
            if (writer == null) {
                response.sendRedirect("../members/login.jsp");
                return;
            }

            int seq;
			try {
				seq = dao.getNextVal();
				String title = multi.getParameter("title");
	            String contents = multi.getParameter("contents");
	            BoardDTO dto = new BoardDTO(seq, writer, title, contents, 0);
                int rs = dao.insert(dto);
                
                String oriName = multi.getOriginalFileName("file");
                String sysName = multi.getFilesystemName("file");
                
                System.out.println(oriName +  " "+sysName);
                
                fdao.insert(new FilesDTO(0, oriName, sysName, seq));
                
                if (rs > 0) {
                    // 데이터 저장 후 리다이렉트 (PRG 패턴)
                    response.sendRedirect("list.board?cpage=1");
                }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            
        }
		else if(cmd.equals("/details.board")) {
		    int seq = Integer.parseInt(request.getParameter("id"));  // 게시글 ID 받기
		    BoardDTO boardDetail;
			try {
				boardDetail = dao.selectById(seq);
				request.setAttribute("boardDetail", boardDetail);
				
				List<ReplyDTO> replyList = replyDao.getRepliesByParentSeq(seq);
				request.setAttribute("replyList", replyList);
				
				// 현재 페이지 정보 저장
				String cpage = request.getParameter("cpage");
				if (cpage == null) cpage = "1";
				request.setAttribute("cpage", cpage);
				
				// 상세 페이지로 포워딩
				request.getRequestDispatcher("/board/details.jsp").forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
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
					response.sendRedirect("details.board?seq="+seq); 
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
