package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.FilesDTO;

public class FilesDAO {
	//singleton pattern 적용 
		private static FilesDAO instance;
		public synchronized static FilesDAO getInstance(){
			if(instance == null){
				instance = new FilesDAO();
			}
			return instance;
		}

		private Connection getConnection() throws Exception{

			Context ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/orcl");

			return ds.getConnection();

		}
		
		public int insert(FilesDTO dto) throws Exception{
			String sql = "insert into files values(files_seq.nextval, ?, ?, ?)";
			try(Connection con = this.getConnection()){
				PreparedStatement pstat = con.prepareStatement(sql);
				pstat.setString(1, dto.getOriName());
				pstat.setString(2, dto.getSysName());
				pstat.setInt(3, dto.getParent_seq());
				return pstat.executeUpdate();
			}
		}
}
