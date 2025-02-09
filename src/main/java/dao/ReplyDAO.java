package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.BoardDTO;
import dto.ReplyDTO;

public class ReplyDAO {

	//singleton pattern 적용 
	private static  ReplyDAO instance;
	public synchronized static  ReplyDAO getInstance(){
		if(instance == null){
			instance = new  ReplyDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{

		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/orcl");

		return ds.getConnection();

	}

	public int insert(ReplyDTO dto) throws Exception {
		String sql = "insert into reply(id, writer, contents, write_date, parent_seq) values(reply_seq.nextval, ?, ?, sysdate, ?)";

		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql)) {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			pstat.setString(1, dto.getWriter());  
			pstat.setString(2, dto.getContents()); 
			pstat.setInt(3, dto.getParentSeq());  

			return pstat.executeUpdate(); 
		}
	}
	
	public List<ReplyDTO> getRepliesByParentSeq(int parentSeq) {
	    List<ReplyDTO> replies = new ArrayList<>();
	    String sql = "SELECT * FROM reply WHERE parent_seq = ? ORDER BY write_date DESC";
	    
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	         
	        pstmt.setInt(1, parentSeq);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            ReplyDTO dto = new ReplyDTO(
	                rs.getInt("id"),
	                rs.getString("writer"),
	                rs.getString("contents"),
	                rs.getTimestamp("write_date"),
	                rs.getInt("parent_seq")
	            );
	            replies.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return replies;
	}
	
	public ReplyDTO selectById(int id) throws Exception {
		String sql = "SELECT * FROM reply WHERE id = ?";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setInt(1, id);
			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					String writer = rs.getString("id");
					String contents = rs.getString("contents");
					Timestamp writeDate = rs.getTimestamp("write_date");
					int parentSeq = rs.getInt("parent_seq");

					return new ReplyDTO(id, writer, contents, writeDate, parentSeq);
				}
			}
		}
		return null;  
	}
	
	public int update(ReplyDTO replyDetail, String newContents) throws Exception {
	    String sql = "UPDATE reply SET contents = ?, write_date = CURRENT_TIMESTAMP WHERE id = ?";
	    try (Connection con = this.getConnection(); 
	         PreparedStatement pstat = con.prepareStatement(sql)) {

	        pstat.setString(1, newContents);
	        pstat.setInt(2, replyDetail.getId());

	        return pstat.executeUpdate();  // 업데이트 성공 시 1 반환
	    }
	}
	
	public int delete(int id) throws Exception{

		String sql ="delete from reply where id = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)){

			pstat.setInt(1, id);

			int result = pstat.executeUpdate();

			return result;
		}

	}




}
