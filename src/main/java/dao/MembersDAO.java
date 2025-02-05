package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.MembersDTO;

public class MembersDAO {

	//singleton pattern 적용 
	private static MembersDAO instance;
	public synchronized static MembersDAO getInstance(){
		if(instance == null){
			instance = new MembersDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{

		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/orcl");

		return ds.getConnection();

	}

	public String login(String id, String passwd) throws Exception {
		String sql = "SELECT name FROM members WHERE id = ? AND passwd = ?";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, id);
			pstat.setString(2, passwd);

			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					return rs.getString("name");
				} else {
					return null;  // 로그인 실패 시 null 반환
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	public boolean idcheck(String id) throws Exception {
		String sql = "select * from members where id = ?";

		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {

			System.out.println(id + 1);
			pstat.setString(1, id);
			System.out.println(id + 2);

			try(ResultSet rs = pstat.executeQuery();){
				return rs.next();
			}
		} catch (Exception e) {
			e.printStackTrace(); 
			throw e;
		}

	}

	public int signup(MembersDTO dto) throws Exception {

		String sql = "insert into members(id,passwd,name,email,phone, postcode, address1, address2, signup_date ) values(?,?,?,?,?,?,?,?,sysdate)";

		try(Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){

			Class.forName("oracle.jdbc.driver.OracleDriver");

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPasswd());
			pstat.setString(3, dto.getName());
			pstat.setString(4, dto.getEmail());
			pstat.setString(5, dto.getPhone());
			pstat.setString(6, dto.getPostcode());
			pstat.setString(7, dto.getAddress1());
			pstat.setString(8, dto.getAddress2());


			return pstat.executeUpdate();
		}

	}

}

