package da;

import domain.Contact;
import java.sql.*;
import java.util.*;

public class ContactUs {

    private final String host = "jdbc:derby://localhost:1527/SkincareDB";
    private final String user = "admin";
    private final String password = "secret";
    private Connection conn;

    public ContactUs() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private String generateNextContactId() throws SQLException {
        String lastId = null;
        String sql = "SELECT CONTACTUSID FROM CONTACTUS ORDER BY CONTACTUSID DESC FETCH FIRST 1 ROWS ONLY";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        if (rs.next()) {
            lastId = rs.getString("CONTACTUSID");
        }

        rs.close();
        stmt.close();

        if (lastId == null) {
            return "C001";
        }

        int num = Integer.parseInt(lastId.substring(1));
        return String.format("C%03d", num + 1);
    }

    public List<Contact> getAllRecords() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM CONTACTUS";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Contact contact = new Contact(
                        rs.getString("CONTACTUSID"),
                        rs.getString("NAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PHONENUMBER"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("STATUS"),
                        rs.getString("STAFFID"),
                        rs.getString("MANAGERID"),
                        rs.getTimestamp("CURRENT_UPDATE")
                );
                contacts.add(contact);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return contacts;
    }

    public Contact getRecordByID(String contactusId) {
        Contact contact = null;
        String sql = "SELECT * FROM CONTACTUS WHERE CONTACTUSID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contactusId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                contact = new Contact(
                        rs.getString("CONTACTUSID"),
                        rs.getString("NAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PHONENUMBER"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("STATUS"),
                        rs.getString("STAFFID"),
                        rs.getString("MANAGERID"),
                        rs.getTimestamp("CURRENT_UPDATE")
                );
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return contact;
    }

    public void insertRecord(Contact contact) {
        try {
            String newId = generateNextContactId();

            String sql = "INSERT INTO CONTACTUS (CONTACTUSID, NAME, EMAIL, PHONENUMBER, DESCRIPTION, STATUS, CURRENT_UPDATE) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, newId);
                stmt.setString(2, contact.getName());
                stmt.setString(3, contact.getEmail());
                stmt.setString(4, contact.getPhoneNumber());
                stmt.setString(5, contact.getDescription());
                stmt.setString(6, "Pending");
                stmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));

                stmt.executeUpdate();
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void updateRecord(Contact contact) {
        String sql = "UPDATE CONTACTUS SET NAME = ?, EMAIL = ?, PHONENUMBER = ?, DESCRIPTION = ?, STATUS = ?, STAFFID = ?, MANAGERID = ?, CURRENT_UPDATE = ? "
                   + "WHERE CONTACTUSID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getPhoneNumber());
            stmt.setString(4, contact.getDescription());
            stmt.setString(5, contact.getStatus());
            stmt.setString(6, contact.getStaffId());      // Nullable
            stmt.setString(7, contact.getManagerId());    // Nullable
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            stmt.setString(9, contact.getContactusId());

            stmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void deleteRecord(String contactusId) {
        String sql = "DELETE FROM CONTACTUS WHERE CONTACTUSID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contactusId);
            stmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void shutDown() {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
