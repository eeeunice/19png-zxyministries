package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import da.DatabaseLink;

public class CustomerDeletionService {
    private static final Logger LOGGER = Logger.getLogger(CustomerDeletionService.class.getName());

    /**
     * Deletes a customer from the database
     * 
     * @param customerId The ID of the customer to delete
     * @return true if deletion was successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteCustomer(String customerId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            DatabaseLink db = new DatabaseLink();
            conn = db.getConnection();
            String sql = "DELETE FROM \"ADMIN\".\"CUSTOMER\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Checks if there are any related records that might prevent customer deletion
     * 
     * @param customerId The ID of the customer to check
     * @return A string describing the remaining records, or null if none found
     */
    public String checkRemainingRecords(String customerId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            DatabaseLink db = new DatabaseLink();
            conn = db.getConnection();

            // Check for orders
            String orderSql = "SELECT COUNT(*) FROM \"ADMIN\".\"ORDER\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(orderSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Orders";
            }

            // Check for reviews
            closeResources(null, stmt, rs);
            String reviewSql = "SELECT COUNT(*) FROM \"ADMIN\".\"REVIEW\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(reviewSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Reviews";
            }

            // Check for shopping cart
            closeResources(null, stmt, rs);
            String cartSql = "SELECT COUNT(*) FROM \"ADMIN\".\"SHOPPINGCART\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(cartSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Shopping Cart";
            }

            // Check for wishlist
            closeResources(null, stmt, rs);
            String wishlistSql = "SELECT COUNT(*) FROM \"ADMIN\".\"WISHLIST\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(wishlistSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Wishlist";
            }

            // Check for feedback
            closeResources(null, stmt, rs);
            String feedbackSql = "SELECT COUNT(*) FROM \"ADMIN\".\"FEEDBACK\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(feedbackSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Feedback";
            }

            // Check for address
            closeResources(null, stmt, rs);
            String addressSql = "SELECT COUNT(*) FROM \"ADMIN\".\"ADDRESS\" WHERE CUSTOMERID = ?";
            stmt = conn.prepareStatement(addressSql);
            stmt.setString(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return "Address";
            }

            return null; // No remaining records found
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking for remaining records", e);
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Closes database resources
     */
    private void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing database resources", e);
        }
    }
}