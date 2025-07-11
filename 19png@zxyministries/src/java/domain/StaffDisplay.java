package domain;

import java.sql.*;
import java.util.*;

public class StaffDisplay {
    private Connection conn;
    
    public StaffDisplay() {
        try {
            String host = "jdbc:derby://localhost:1527/SkincareDB";
            String user = "admin";
            String password = "secret";
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<staffprofile> getAllStaff() {
        List<staffprofile> staffList = new ArrayList<staffprofile>();
        String query = "SELECT STAFFID, MANAGERID, STAFFNAME, STAFFEMAIL, STAFFPHONE, STAFFPASSWORD, ROLE FROM STAFF";
        
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffprofile staff = new staffprofile(
                    rs.getString("STAFFID"),
                    rs.getString("STAFFNAME"),
                    rs.getString("STAFFEMAIL"),
                    rs.getString("STAFFPHONE"),
                    rs.getString("STAFFPASSWORD"),
                    rs.getString("ROLE")
                );
                staffList.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return staffList;
    }
    
    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}