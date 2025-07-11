package da;

import domain.Manager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ManagerDAO {
    private Connection connection;
    
    public ManagerDAO() {
        DatabaseLink db = new DatabaseLink();
        connection = db.getConnection();
    }
    
    public Manager getManagerById(String managerId) {
        Manager manager = null;
        // Change manager_id to MANAGERID
        String sql = "SELECT * FROM manager WHERE MANAGERID = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, managerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                manager = new Manager();
                // Change manager_id to MANAGERID
                manager.setManagerId(rs.getString("MANAGERID"));
                // Update other column names to match database schema
                manager.setName(rs.getString("MANAGERNAME"));
                manager.setEmail(rs.getString("MANAGEREMAIL"));
                manager.setPhone(rs.getString("MANAGERPHONE"));
                manager.setUsername(rs.getString("MANAGERUSERNAME"));
                manager.setPassword(rs.getString("MANAGERPASSWORD"));
            }
            
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return manager;
    }
    
    public boolean updateManager(Manager manager, String currentPassword) {
        boolean success = false;
        // Update column names to match database schema
        String sql = "UPDATE manager SET MANAGERNAME = ?, MANAGEREMAIL = ?, MANAGERPHONE = ?, MANAGERUSERNAME = ? WHERE MANAGERID = ? AND MANAGERPASSWORD = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, manager.getName());
            stmt.setString(2, manager.getEmail());
            stmt.setString(3, manager.getPhone());
            stmt.setString(4, manager.getUsername());
            stmt.setString(5, manager.getManagerId());
            stmt.setString(6, currentPassword);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return success;
    }
    
    public boolean updateManagerPassword(String managerId, String currentPassword, String newPassword) {
        boolean success = false;
        // Update column names to match database schema
        String sql = "UPDATE manager SET MANAGERPASSWORD = ? WHERE MANAGERID = ? AND MANAGERPASSWORD = ?";
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, managerId);
            stmt.setString(3, currentPassword);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return success;
    }
    
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}