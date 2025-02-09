package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import commons.Statics;
import dto.BoardDTO;

public class BoardDAO {

	//singleton pattern 적용 
	private static BoardDAO instance;
	public synchronized static BoardDAO getInstance(){
		if(instance == null){
			instance = new BoardDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{

		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/orcl");

		return ds.getConnection();

	}
	
	public int getNextVal() throws Exception{
		String sql = "select board_seq.nextval from dual";
		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery()) {

			rs.next();

			return rs.getInt(1);
		}
	}

	public int insert(BoardDTO dto) throws Exception {
		String sql = "insert into board (seq, writer, title, contents, write_date, view_count) values (?, ?, ?, ?, sysdate, 0)";

		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql)) {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			pstat.setInt(1, dto.getSeq());  
			pstat.setString(2, dto.getWriter());  
			pstat.setString(3, dto.getTitle());  
			pstat.setString(4, dto.getContents()); 

			return pstat.executeUpdate(); 
		}
	}

	public List<BoardDTO> selectAll() throws Exception{

		String sql = "select * from board order by seq desc";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery()) {

			List<BoardDTO> list = new ArrayList<>();
			while (rs.next()) {
				int seq = rs.getInt("seq");
				String writer = rs.getString("writer");
				String title = rs.getString("title");
				String contents = rs.getString("contents");
				Timestamp writeDate = rs.getTimestamp("write_date");
				int viewCount = rs.getInt("view_count");

				BoardDTO dto = new BoardDTO(seq, writer, title, contents, writeDate, viewCount);
				list.add(dto);
			}
			return list;
		} catch (Exception e) {
			e.printStackTrace(); 
			throw e; 
		}
	}

	
	public List<BoardDTO> selectFromTo(int start, int end) throws Exception{

		String sql = "select * from (select board.*, row_number() over(order by seq desc) rnum from board) where rnum between ? and ?";

		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {

			pstat.setInt(1, start);       
			pstat.setInt(2, end);        
		

			try(ResultSet rs = pstat.executeQuery()){

				List<BoardDTO> list = new ArrayList<>();
				while (rs.next()) {
					int seq = rs.getInt("seq");
					String writer = rs.getString("writer");
					String title = rs.getString("title");
					String contents = rs.getString("contents");
					Timestamp writeDate = rs.getTimestamp("write_date");
					int viewCount = rs.getInt("view_count");

					BoardDTO dto = new BoardDTO(seq, writer, title, contents, writeDate, viewCount);
					list.add(dto);
				}
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace(); 
			throw e; 
		}
	}

	//gpt idea
	public BoardDTO selectById(int seq) throws Exception {
		String sql = "SELECT * FROM board WHERE seq = ?";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setInt(1, seq);
			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					String writer = rs.getString("writer");
					String title = rs.getString("title");
					String contents = rs.getString("contents");
					Timestamp writeDate = rs.getTimestamp("write_date");
					int viewCount = rs.getInt("view_count");

					return new BoardDTO(seq, writer, title, contents, writeDate, viewCount);
				}
			}
		}
		return null;  // 해당 글이 없는 경우
	}


	public int updateBoard(BoardDTO dto) throws Exception {
		String sql = "UPDATE board SET title = ?, contents = ?, view_count = ?, write_date = ? WHERE seq = ?";
		int result = 0;

		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, dto.getTitle());            // 제목
			pstat.setString(2, dto.getContents());        // 내용
			pstat.setInt(3, dto.getViewCount());         // 조회수
			pstat.setTimestamp(4, dto.getWriteDate());   // 작성일
			pstat.setInt(5, dto.getSeq());               // 게시글 번호

			result = pstat.executeUpdate();  // update 실행

		} catch (Exception e) {
			e.printStackTrace();
			throw e;  // 예외 발생시 다시 던져서 호출한 곳에서 처리
		}

		return result;  // 업데이트된 레코드 수 반환
	}

	public int deleteBoard(int seq) throws Exception{

		String sql ="delete from board where seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)){

			pstat.setInt(1, seq);

			int result = pstat.executeUpdate();

			return result;
		}

	}

	public int updateBoardDetails(BoardDTO dto, String title, String contents) throws Exception{

		String sql = "UPDATE board SET title = ?, contents = ? WHERE seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)){

			pstat.setString(1, title);
			pstat.setString(2, contents);
			pstat.setInt(3, dto.getSeq());

			int result = pstat.executeUpdate();

			return result;
		}

	}

	public String getPageNavi(int currentPage) throws Exception{

		//전체 글의 개수가 몇 개인가 
		int recordTotalCount = this.getRecordTotalCount();//DB에서 데이터 개수를 조회 해와야 함.

		//한 페이지 당 몇 개씩 보여줄 것인가.
		int recordCountPerPage = Statics.recordCountPerPage;

		// 페이지에 노출될 네비게이터의 개수는 몇 개로 할 것인가.
		int naviCountPerPage = Statics.naviCountPerPage;               

		//전체 페이지의 개수  (paging)
		int pageTotalCount = recordTotalCount / recordCountPerPage + ((recordTotalCount % recordCountPerPage)>0 ? 1 : 0);

		//현재 나의 페이지 
		currentPage = (currentPage < 1 ? 1:currentPage);
		currentPage = (currentPage > recordTotalCount ? recordTotalCount:currentPage);

		int startNavi = (currentPage-1)/naviCountPerPage * naviCountPerPage + 1;
		int endNavi = ((pageTotalCount < (startNavi+naviCountPerPage-1))? pageTotalCount:startNavi+naviCountPerPage-1);

		boolean needPrev = ((startNavi == 1)? false : true);
		boolean needNext =  ((endNavi >= pageTotalCount)?false : true);


		StringBuilder navi = new StringBuilder();

		if(needPrev) navi.append("<a href='/list.board?cpage="+ (startNavi-1) +"'> <"+ "</a>");
		for(int i = startNavi;i<=endNavi;i++) {
			navi.append("<a href='/list.board?cpage="+ i +"'>" + i + "</a>");
		}
		if(needNext) navi.append("<a href='/list.board?cpage="+ (endNavi+1) +"'> >"+ "</a>");

		System.out.println(navi);

		return navi.toString();
	}

	public int getRecordTotalCount() throws Exception{
		String sql = "select count(*) from board";

		try(Connection con =this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery();){
			rs.next();
			return rs.getInt(1);	
		}
	}
	

}
