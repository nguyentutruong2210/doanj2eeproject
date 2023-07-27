package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class KETNOI_MOD {
	private Connection cnn=null;
	public KETNOI_MOD()
	{
		try {
			String url="jdbc:sqlserver://MSI;databaseName=SHOPCONGNGHE;useUnicode=true;characterEncoding=UTF-8";
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			try {
				cnn=DriverManager.getConnection(url,"sa","1234");
			} catch (SQLException e) {
			
				e.printStackTrace();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	public Connection getConnect()
	{
		return cnn;
	}
	
}
