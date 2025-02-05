package controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MembersDAO;
import dto.MembersDTO;

@WebServlet("*.members")
public class MembersController extends HttpServlet{
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String cmd = request.getRequestURI();

		System.out.print("클라이언트 요청: " + cmd);

		MembersDAO dao = MembersDAO.getInstance();

		//client request 처리 			
		try {
			if (cmd.equals("/login.members")) {
				System.out.println("Processing /login.members...");

				String id = request.getParameter("id");
				String passwd = request.getParameter("passwd");

				String username = dao.login(id, passwd);

				if (username != null) {
					request.getSession().setAttribute("username", username);
				} else {
					request.setAttribute("error", "Invalid ID or Password");
				}
				// index.jsp로 포워딩
				request.getRequestDispatcher("index.jsp").forward(request, response);
			}
			else if (cmd.equals("/logout.members")) {
				// 로그아웃 처리
				request.getSession().invalidate(); // 세션 무효화
				response.sendRedirect("index.jsp"); // index.jsp로 리다이렉트
			}
			else if(cmd.equals("/signup.members")) {
			    // 회원가입 
			    String id = request.getParameter("userid");
			    String passwd = request.getParameter("password"); // 수정: input name="password"에 맞춰 변경
			    String username = request.getParameter("name");
			    String email = request.getParameter("email");
			    String phone = request.getParameter("phone");
			    String postcode = request.getParameter("postcode");
			    String address1 = request.getParameter("address1");
			    String address2 = request.getParameter("address2");
			    
			    System.out.println("1: " + postcode);
			    
			    MembersDTO dto = new MembersDTO(id, passwd, username, email, phone, postcode, address1, address2);
			    
			    System.out.println("2: " + dto.getPostcode());
			    
			    int result = dao.signup(dto);
			    
			    if(result > 0) {
			        // 회원가입 성공 시 세션에 사용자 정보 저장 (로그인 유지)
			        HttpSession session = request.getSession();
			        session.setAttribute("username", username);

			        // 성공 메시지를 index.jsp로 전달
			        request.setAttribute("signupSuccess", "회원가입이 성공적으로 완료되었습니다!");

			        // index.jsp로 포워딩
			        request.getRequestDispatcher("index.jsp").forward(request, response);
			    } else {
			        // 회원가입 실패 시 실패 메시지 전달 및 signup.jsp로 포워딩
			        request.setAttribute("signupError", "회원가입에 실패했습니다. 다시 시도해주세요.");
			        
			        // 폼 초기화 없이 입력된 데이터 유지하기 위해 다시 전달
			        request.setAttribute("userid", id);
			        request.setAttribute("name", username);
			        request.setAttribute("email", email);
			        request.setAttribute("phone", phone);
			        request.setAttribute("postcode", postcode);
			        request.setAttribute("address1", address1);
			        request.setAttribute("address2", address2);
			        
			        request.getRequestDispatcher("members/signup.jsp").forward(request, response);
			    }
			}

			else if(cmd.equals("/idcheck.members")) {
				String id = request.getParameter("userid");
				
				boolean result = dao.idcheck(id);
				
				request.setAttribute("result", result);
				request.getRequestDispatcher("/members/idcheck.jsp").forward(request, response);
			}

		}catch(Exception e) {
			e.printStackTrace(); 
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}




}
