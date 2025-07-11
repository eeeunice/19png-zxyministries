package da;

import domain.staffprofile;
import java.sql.Timestamp;
import java.sql.*;

public class staffpro {
    private static String host = "jdbc:derby://localhost:1527/SkincareDB";
    private static String user = "admin";
    private static String password = "secret";
    private static Connection conn;
    
    

    
    // Initialize DB connection
    static {
        try {
            conn = DriverManager.getConnection(host, user, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Existing method to retrieve staff...
    public static staffprofile getStaffByEmailAndPassword(String email, String password) {
        staffprofile staff = null;
        String query = "SELECT STAFFID, STAFFNAME, STAFFEMAIL, STAFFPHONE, STAFFPASSWORD, ROLE FROM STAFF WHERE STAFFEMAIL = ? AND STAFFPASSWORD = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    staff = new staffprofile(
                        rs.getString("STAFFID"),
                        rs.getString("STAFFNAME"),
                        rs.getString("STAFFEMAIL"),
                        rs.getString("STAFFPHONE"),
                        rs.getString("STAFFPASSWORD"),
                        rs.getString("ROLE")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }

    // 🔄 Update staff profile by ID
    public static boolean updateStaffProfile(staffprofile staff) {
        String query = "UPDATE STAFF SET STAFFNAME = ?, STAFFEMAIL = ?, STAFFPHONE = ?, STAFFPASSWORD = ?, ROLE = ? WHERE STAFFID = ?";
    
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, staff.getStaffName());
            stmt.setString(2, staff.getStaffEmail());
            stmt.setString(3, staff.getStaffPhone());
            stmt.setString(4, staff.getStaffPassword());
            stmt.setString(5, staff.getRole());
            stmt.setString(6, staff.getStaffId());
    
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // 🆕 Add new staff member
    public static boolean addStaff(staffprofile staff) {
        String query = "INSERT INTO STAFF (STAFFID, STAFFNAME, STAFFEMAIL, STAFFPHONE, STAFFPASSWORD, ROLE, UPDATED_AT, CREATED_AT) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"; 
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            // Generate a new staff ID
            String staffId = generateStaffId();
            
            stmt.setString(1, staffId);
            stmt.setString(2, staff.getStaffName());
            stmt.setString(3, staff.getStaffEmail());
            stmt.setString(4, staff.getStaffPhone());
            stmt.setString(5, staff.getStaffPassword());
            stmt.setString(6, staff.getRole());
            
            // Current timestamp for both UPDATED_AT and CREATED_AT
            Timestamp currentTime = new Timestamp(System.currentTimeMillis());
            stmt.setTimestamp(7, currentTime);
            stmt.setTimestamp(8, currentTime);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Generate a random unique staff ID
    private static String generateStaffId() {
        String prefix = "S";
        boolean isUnique = false;
        String randomId = "";
        
        while (!isUnique) {
            // Generate a random 3-digit number
            int randomNum = 100 + (int)(Math.random() * 900); // Random number between 100-999
            randomId = prefix + String.format("%03d", randomNum);
            
            // Check if this ID already exists in the database
            String query = "SELECT COUNT(*) FROM STAFF WHERE STAFFID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, randomId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    // ID doesn't exist, so it's unique
                    isUnique = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
                // If there's an error, return a fallback ID to avoid infinite loop
                return prefix + String.format("%03d", System.currentTimeMillis() % 1000);
            }
        }
        
        return randomId;
    }

    // Get staff by ID
    public static staffprofile getStaffById(String staffId) {
        staffprofile staff = null;
        String query = "SELECT STAFFID, STAFFNAME, STAFFEMAIL, STAFFPHONE, STAFFPASSWORD, ROLE FROM STAFF WHERE STAFFID = ?";
    
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, staffId);
    
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    staff = new staffprofile(
                        rs.getString("STAFFID"),
                        rs.getString("STAFFNAME"),
                        rs.getString("STAFFEMAIL"),
                        rs.getString("STAFFPHONE"),
                        rs.getString("STAFFPASSWORD"),
                        rs.getString("ROLE")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }

    public static boolean deleteStaff(String staffId) {
        String query = "DELETE FROM STAFF WHERE STAFFID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, staffId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
