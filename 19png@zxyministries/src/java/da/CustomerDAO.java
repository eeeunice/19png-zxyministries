package da;

import domain.Customer;
import java.sql.*;



public class CustomerDAO {
    private Connection conn;

    public CustomerDAO() {
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection(); // Establish connection using DatabaseLink
    }

    // Method to get a customer by ID
    public Customer getCustomerById(String customerId) {
        Customer customer = null;
        try {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customer WHERE customerid = ?");
            stmt.setString(1, customerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                customer = new Customer(
                    rs.getString("customerid"),
                    rs.getString("custname"),
                    rs.getString("email"),
                    rs.getString("phonenum"),
                    rs.getDate("dateofbirth"),
                    rs.getString("addressid"),
                    rs.getString("gender"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getTimestamp("registrationdate")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close(); // Close connection after use
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return customer;
    }

    // Method to insert a new customer
    public void insertCustomer(Customer customer) {
        try {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO customer (customerid, custname, email, phonenum, dateofbirth, addressid, gender, username, password, registrationdate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            stmt.setString(1, customer.getCustomerId());
            stmt.setString(2, customer.getCustName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhoneNum());
            stmt.setDate(5, new java.sql.Date(customer.getDateOfBirth().getTime()));
            stmt.setString(6, customer.getAddressid());
            stmt.setString(7, customer.getGender());
            stmt.setString(8, customer.getUsername());
            stmt.setString(9, customer.getPassword());
            stmt.setTimestamp(10, customer.getRegistrationDate());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close(); // Close connection after use
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}