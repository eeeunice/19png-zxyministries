package da;

import java.sql.*;
import java.util.*;
import domain.staffprofile;

public class StaffDisplayHelper {
    private Connection conn;
    
    public StaffDisplayHelper() {
        // Use DatabaseLink as recommended in the comments
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection();
    }
    
    public List<staffprofile> getAllStaff() {
        List<staffprofile> staffList = new ArrayList<staffprofile>(); // Compatible with Java 1.5
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
    
    // Add the closeConnection method that was missing
    public void closeConnection() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}