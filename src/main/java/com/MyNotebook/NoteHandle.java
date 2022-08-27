package com.MyNotebook;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;


public class NoteHandle extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    public NoteHandle() {
        super();
       
    }

protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	
	JsonObject data = new Gson().fromJson(request.getReader().readLine(), JsonObject.class);
	System.out.println("patates");
	
	
	
	
	
	
	
	    int id =   data.get("id").getAsInt();
		
		String title = data.get("title").getAsString();
		String body = data.get("body").getAsString();
		String date = data.get("date").getAsString();
		String update = data.get("update").getAsString();
		
		
		
		
		
		String sql1 = "INSERT INTO `notes`.`my_notes` (`id`, `title`, `body`, `date`) VALUES ("+"'"+id+"'"+", "+"'"+title+"'"+", "+"'"+body+"'"+", "+"'"+date+"'"+")";
		String sql2 = "UPDATE `notes`.`my_notes` SET `title` ="+"'"+title+ "', `body` ="+"'"+body+"', `date` =" +"'"+date+"' WHERE `id` ='"+id+"';";
		String url = "jdbc:mysql://localhost:3307/notes";
		String username = "root";
		String password = "19051991";
		
		
		try {
			
			
			if(update.equals("no")) {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url,username,password);
			Statement st = conn.createStatement();
			boolean rs = st.execute(sql1);
			st.close();
			conn.close();
			}
			else {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn = DriverManager.getConnection(url,username,password);
				Statement st = conn.createStatement();
				
				int rs = st.executeUpdate(sql2);
				
				st.close();
				conn.close();
				
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		
		
		
}

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	
	ArrayList<JsonObject> jsonList = new ArrayList<JsonObject>();
	
	String sql = "SELECT * FROM `notes`.`my_notes`;";
	String url = "jdbc:mysql://localhost:3307/notes";
	String username = "root";
	String password = "19051991";
	
	
	try {
		
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection(url,username,password);
		Statement st = conn.createStatement();
		
		
		
		if(request.getParameter("request").equals("delete")) {
			
			String sql3 = "DELETE FROM `notes`.`my_notes` WHERE (`id` = '"+request.getParameter("id_row")+"');";
			
			int rs = st.executeUpdate(sql3);
			
			
			
			
		}
		else if(!request.getParameter("request").equals("hi")) {
			
			
			
			String sql2 = "SELECT * FROM `notes`.`my_notes` WHERE `id`="+"'"+request.getParameter("id_row")+"';";
			
			ResultSet rs = st.executeQuery(sql2);
			rs.next();
			JsonObject oneRow = new JsonObject();
			
			oneRow.addProperty("title",rs.getString("title"));
			oneRow.addProperty("body",rs.getString("body"));
			
			
			String rowJson2 = new Gson().toJson(oneRow);
			
			System.out.println(rowJson2);
			
			response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(rowJson2);
		    
		    
		    rs.close();
			
		}
		
		else {
		ResultSet rs = st.executeQuery(sql);
		
		while(rs.next()) {
			JsonObject data = new JsonObject();
			data.addProperty("id",rs.getInt("id"));
			data.addProperty("title",rs.getString("title"));
			data.addProperty("body",rs.getString("body"));
			data.addProperty("date",rs.getString("date"));
			jsonList.add(data);
			
		}
		
		String json = new Gson().toJson(jsonList);
		
		System.out.println(json);
		
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
		
		
		
	    rs.close();
		
		
		
		}
		
		st.close();
		conn.close();
		
		
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	
	
	
}
	

}
}
