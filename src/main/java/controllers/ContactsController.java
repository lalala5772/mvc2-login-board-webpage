//package servlets;
//
//import java.io.IOException;
//
//import java.io.PrintWriter;
//import java.util.List;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import dao.StudentDao;
//import dto.StudentDto;
//
////frontController pattern
//@WebServlet("*.contacts")
//public class ContactsController extends HttpServlet {
//
//	protected void doGet(HttpServletRequest request, HttpServletResponse response)
//			throws ServletException, IOException {
//		
//		request.setCharacterEncoding("UTF8");
//		response.setCharacterEncoding("UTF-8");
//	    response.setContentType("text/html; charset=UTF-8");
//
//		String cmd = request.getRequestURI();
//
//		System.out.print("클라이언트 요청: " + cmd);
//
//		StudentDao dao = StudentDao.getInstance();
//		String result = "Success";
//		try {
//			if(cmd.equals("/list.contacts")) {
//				 System.out.println("Processing /list.contacts...");
//				
//				List<StudentDto> list = dao.selectAll();
//				for(StudentDto l : list) {
//					System.out.println(l);
//				}
//				
//				request.setAttribute("list", list);
//				System.out.println("List size: " + list.size());
//				
//				request.getRequestDispatcher("listForm.jsp").forward(request, response);
//
//			}
//			else if(cmd.equals("/add.contacts")) {
//				String name = request.getParameter("name");
//				int kor = Integer.parseInt(request.getParameter("kor"));
//				int eng = Integer.parseInt(request.getParameter("eng"));
//				int math = Integer.parseInt(request.getParameter("math"));
//
//				
//				int rs = dao.insert(new StudentDto(0,name, kor, eng, math));
//				
//				PrintWriter pw = response.getWriter();
//				pw.append("<html>");
//				pw.append("<head>");
//				pw.append("</head>");
//				pw.append("<body>");
//				pw.append("<script>");
//				pw.append("alert('" + result + "');");
//				pw.append("location.href='/index.jsp'");
//				pw.append("</script>");
//				pw.append("</body>");
//				pw.append("</html>");
//
//			}
//			else if(cmd.equals("/update.contacts")) {
//				int id = Integer.parseInt(request.getParameter("id"));
//				String name = request.getParameter("name");
//				int kor = Integer.parseInt(request.getParameter("kor"));
//				int eng = Integer.parseInt(request.getParameter("eng"));
//				int math = Integer.parseInt(request.getParameter("math"));
//				
//				dao.updateById(new StudentDto(id,name, kor, eng, math));
//				response.sendRedirect("/index.jsp");
//
//			}
//			else if(cmd.equals("/delete.contacts")) {
//				int id = Integer.parseInt(request.getParameter("id"));
//				int rs = dao.deleteById(id);
//				response.sendRedirect("/index.jsp");
//			}
//
//			
//		}catch(Exception e) {
//			e.printStackTrace(); 
////			result = "Failed";
//		}
//		
//	}
//
//	protected void doPost(HttpServletRequest request, HttpServletResponse response)
//			throws ServletException, IOException {
//		doGet(request, response);
//	}
//
//}
