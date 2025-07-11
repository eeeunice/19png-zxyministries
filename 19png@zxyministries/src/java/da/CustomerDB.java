package da;

import domain.CustomerRegister;
import java.sql.*;

public class CustomerDB {
    private String tableName = "CUSTOMER";
    private Connection conn;
    private PreparedStatement stmt;

    public CustomerDB() {
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection();
    }

    public Connection getConnection() {
        return conn;
    }

    public void addCustomer(CustomerRegister customer) throws SQLException {
        String insertStr = "INSERT INTO " + tableName
                + " (CUSTOMERID, CUSTNAME, EMAIL, USERNAME, PASSWORD, PHONENUM, DATEOFBIRTH, ADDRESSID, GENDER, REGISTRATIONDATE) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try {
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, customer.getCustomerId());
            stmt.setString(2, customer.getCustName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getUsername());
            stmt.setString(5, customer.getPassword());
            stmt.setString(6, customer.getPhoneNum());
            stmt.setDate(7, Date.valueOf(customer.getDateOfBirth())); // Assuming yyyy-MM-dd format
            stmt.setString(8, customer.getAddressid());
            stmt.setString(9, customer.getGender());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Creating customer failed, no rows affected.");
            }
            System.out.println("Customer added successfully: " + customer.getCustomerId());
        } catch (SQLException ex) {
            System.err.println("SQL Error adding customer: " + ex.getMessage());
            ex.printStackTrace();
            throw ex; // Re-throw to be handled by the servlet
        }
    }

    // 🔥 Add this method to get next Customer ID
    public String getNextCustomerId() {
        // Generate a random number between 1000 and 9999
        int randomNum = 1000 + (int) (Math.random() * 9000);

        // Create customer ID with format C followed by random number
        String newId = "C" + randomNum;

        // Check if this ID already exists in the database
        String query = "SELECT COUNT(*) FROM " + tableName + " WHERE CUSTOMERID = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, newId);
            ResultSet rs = stmt.executeQuery();

            // If ID exists, recursively try again
            if (rs.next() && rs.getInt(1) > 0) {
                return getNextCustomerId(); // Try again with a different random number
            }

            return newId;
        } catch (SQLException ex) {
            ex.printStackTrace();
            // Fallback to a timestamp-based ID if there's an error
            return "C" + System.currentTimeMillis() % 10000;
        }
    }

    public void shutDown() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public void updateCustomerAddress(String customerId, String addressId) throws SQLException {
        String updateStr = "UPDATE " + tableName + " SET ADDRESSID = ? WHERE CUSTOMERID = ?";
        try {
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, addressId);
            stmt.setString(2, customerId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating customer address failed, no rows affected.");
            }
            System.out.println("Customer address updated successfully: " + customerId + " -> " + addressId);
        } catch (SQLException ex) {
            System.err.println("SQL Error updating customer address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    // Get customer by ID
    public CustomerRegister getCustomerById(String customerId) throws SQLException {
        String query = "SELECT * FROM " + tableName + " WHERE CUSTOMERID = ?";
        CustomerRegister customer = null;

        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customer = new CustomerRegister(
                        rs.getString("CUSTOMERID"),
                        rs.getString("CUSTNAME"),
                        rs.getString("EMAIL"),
                        rs.getString("USERNAME"),
                        rs.getString("PASSWORD"),
                        rs.getString("PHONENUM"),
                        rs.getDate("DATEOFBIRTH").toString(), // Convert to string
                        rs.getString("ADDRESSID"),
                        rs.getString("GENDER"),
                        rs.getTimestamp("REGISTRATIONDATE") != null ? rs.getTimestamp("REGISTRATIONDATE").toString()
                                : null);
            }
            return customer;
        } catch (SQLException ex) {
            System.err.println("SQL Error retrieving customer: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    // Update customer details
    public void updateCustomer(CustomerRegister customer) throws SQLException {
        String updateStr = "UPDATE " + tableName +
                " SET CUSTNAME = ?, EMAIL = ?, USERNAME = ?, PASSWORD = ?, " +
                "PHONENUM = ?, DATEOFBIRTH = ?, GENDER = ? " +
                "WHERE CUSTOMERID = ?";
        try {
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, customer.getCustName());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getUsername());
            stmt.setString(4, customer.getPassword());
            stmt.setString(5, customer.getPhoneNum());
            stmt.setDate(6, Date.valueOf(customer.getDateOfBirth())); // Assuming yyyy-MM-dd format
            stmt.setString(7, customer.getGender());
            stmt.setString(8, customer.getCustomerId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating customer failed, no rows affected.");
            }
            System.out.println("Customer updated successfully: " + customer.getCustomerId());
        } catch (SQLException ex) {
            System.err.println("SQL Error updating customer: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    // Delete customer
    public void deleteCustomer(String customerId) throws SQLException {
        String deleteStr = "DELETE FROM " + tableName + " WHERE CUSTOMERID = ?";
        try {
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, customerId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Deleting customer failed, no rows affected.");
            }
            System.out.println("Customer deleted successfully: " + customerId);
        } catch (SQLException ex) {
            System.err.println("SQL Error deleting customer: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }
}
