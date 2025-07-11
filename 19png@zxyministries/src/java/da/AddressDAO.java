package da;

import domain.Address;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {
    private Connection conn;

    public AddressDAO() {
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection();
    }

    public List<Address> getAddressesByCustomerId(String customerId) {
        List<Address> addresses = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // Ensure the table name matches the one you created
            stmt = conn.prepareStatement("SELECT * FROM addresses WHERE customerid = ?");
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                // Generate an address ID if not present in the database
                String addressId = rs.getString("addressid") != null ? 
                                  rs.getString("addressid") : 
                                  "A" + System.currentTimeMillis();
                
                // Create Address object with the correct constructor parameters
                Address address = new Address(
                    addressId,
                    rs.getString("customerid"),
                    rs.getString("street"),
                    rs.getString("zip"),  // This is postcode in Address class
                    rs.getString("city"),
                    rs.getString("state"),
                    "Malaysia"  // Default country if not in database
                );
                addresses.add(address);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving addresses: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt);
        }
        return addresses;
    }

    public void insertAddress(Address address) {
        PreparedStatement stmt = null;
        
        try {
            stmt = conn.prepareStatement("INSERT INTO addresses (addressid, customerid, street, city, state, zip) VALUES (?, ?, ?, ?, ?, ?)");
            stmt.setString(1, address.getAddressId());
            stmt.setString(2, address.getCustomerId());
            stmt.setString(3, address.getStreet());
            stmt.setString(4, address.getCity());
            stmt.setString(5, address.getState());
            stmt.setString(6, address.getPostcode());  // Changed from getZip() to getPostcode()
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Address inserted successfully for customer: " + address.getCustomerId());
            } else {
                System.err.println("Failed to insert address for customer: " + address.getCustomerId());
            }
        } catch (SQLException e) {
            System.err.println("Error inserting address: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt);
        }
    }
    
    // Method to update an existing address
    public void updateAddress(Address address) {
        PreparedStatement stmt = null;
        
        try {
            stmt = conn.prepareStatement("UPDATE addresses SET street = ?, city = ?, state = ?, zip = ? WHERE addressid = ?");
            stmt.setString(1, address.getStreet());
            stmt.setString(2, address.getCity());
            stmt.setString(3, address.getState());
            stmt.setString(4, address.getPostcode());
            stmt.setString(5, address.getAddressId());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Address updated successfully: " + address.getAddressId());
            } else {
                System.err.println("Failed to update address: " + address.getAddressId());
            }
        } catch (SQLException e) {
            System.err.println("Error updating address: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt);
        }
    }
    
    // Method to delete an address
    public void deleteAddress(String addressId) {
        PreparedStatement stmt = null;
        
        try {
            stmt = conn.prepareStatement("DELETE FROM addresses WHERE addressid = ?");
            stmt.setString(1, addressId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Address deleted successfully: " + addressId);
            } else {
                System.err.println("Failed to delete address: " + addressId);
            }
        } catch (SQLException e) {
            System.err.println("Error deleting address: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt);
        }
    }
    
    // Helper method to close resources
    private void closeResources(ResultSet rs, Statement stmt) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Method to close the connection when done with DAO
    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("Database connection closed");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

