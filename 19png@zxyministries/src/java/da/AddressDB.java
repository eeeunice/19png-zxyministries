package da;

import domain.Address;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class AddressDB {
    private String tableName = "ADDRESS";
    private Connection conn;
    private PreparedStatement stmt;

    public AddressDB() {
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection();
    }

    public void addAddress(Address address) throws SQLException {
        String insertStr = "INSERT INTO " + tableName
                + " (ADDRESSID, CUSTOMERID, STREET, POSTCODE, CITY, STATE, COUNTRY) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            stmt = conn.prepareStatement(insertStr);
            stmt.setString(1, address.getAddressId());
            stmt.setString(2, address.getCustomerId());
            stmt.setString(3, address.getStreet());
            stmt.setString(4, address.getPostcode());
            stmt.setString(5, address.getCity());
            stmt.setString(6, address.getState());
            stmt.setString(7, address.getCountry());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Creating address failed, no rows affected.");
            }
            System.out.println("Address added successfully: " + address.getAddressId());
        } catch (SQLException ex) {
            System.err.println("SQL Error adding address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex; // Re-throw to be handled by the servlet
        }
    }

    public String getNextAddressId() {
        // Generate a random number between 1000000 and 9999999 (7 digits)
        int randomNum = 1000000 + (int) (Math.random() * 9000000);

        // Create address ID with format A followed by random number
        String newId = "A" + randomNum;

        // Check if this ID already exists in the database
        String query = "SELECT COUNT(*) FROM " + tableName + " WHERE ADDRESSID = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, newId);
            ResultSet rs = stmt.executeQuery();

            // If ID exists, recursively try again
            if (rs.next() && rs.getInt(1) > 0) {
                return getNextAddressId(); // Try again with a different random number
            }

            return newId;
        } catch (SQLException ex) {
            ex.printStackTrace();
            // Fallback to a timestamp-based ID if there's an error
            return "A" + System.currentTimeMillis() % 10000000;
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

    public Address getAddressById(String addressId) throws SQLException {
        String query = "SELECT * FROM " + tableName + " WHERE ADDRESSID = ?";
        Address address = null;

        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, addressId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                address = new Address(
                        rs.getString("ADDRESSID"),
                        rs.getString("CUSTOMERID"),
                        rs.getString("STREET"),
                        rs.getString("POSTCODE"),
                        rs.getString("CITY"),
                        rs.getString("STATE"),
                        rs.getString("COUNTRY"));
            }
            return address;
        } catch (SQLException ex) {
            System.err.println("SQL Error retrieving address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    public void updateAddress(Address address) throws SQLException {
        String updateStr = "UPDATE " + tableName +
                " SET STREET = ?, POSTCODE = ?, CITY = ?, STATE = ?, COUNTRY = ? " +
                "WHERE ADDRESSID = ?";
        try {
            stmt = conn.prepareStatement(updateStr);
            stmt.setString(1, address.getStreet());
            stmt.setString(2, address.getPostcode());
            stmt.setString(3, address.getCity());
            stmt.setString(4, address.getState());
            stmt.setString(5, address.getCountry());
            stmt.setString(6, address.getAddressId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating address failed, no rows affected.");
            }
            System.out.println("Address updated successfully: " + address.getAddressId());
        } catch (SQLException ex) {
            System.err.println("SQL Error updating address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex; // Re-throw to be handled by the servlet
        }
    }

    public void deleteAddress(String addressId) throws SQLException {
        String deleteStr = "DELETE FROM " + tableName + " WHERE ADDRESSID = ?";
        try {
            stmt = conn.prepareStatement(deleteStr);
            stmt.setString(1, addressId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Deleting address failed, no rows affected.");
            }
            System.out.println("Address deleted successfully: " + addressId);
        } catch (SQLException ex) {
            System.err.println("SQL Error deleting address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex; // Re-throw to be handled by the servlet
        }
    }

    public List<Address> getAddressesByCustomerId(String customerId) throws SQLException {
        List<Address> addresses = new ArrayList<>();
        String query = "SELECT * FROM " + tableName + " WHERE CUSTOMERID = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Address address = new Address(
                    rs.getString("ADDRESSID"),
                    rs.getString("CUSTOMERID"),
                    rs.getString("STREET"),
                    rs.getString("POSTCODE"),
                    rs.getString("CITY"),
                    rs.getString("STATE"),
                    rs.getString("COUNTRY")
                );
                addresses.add(address);
            }
        } catch (SQLException ex) {
            System.err.println("SQL Error retrieving addresses: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
        return addresses;
    }
}