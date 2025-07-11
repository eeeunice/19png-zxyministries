package da;

import domain.staff_displaycust;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;

public class Customerdisplay_cust {
    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private final String tableName = "CUSTOMER";
    private Connection conn;

    public Customerdisplay_cust() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<staff_displaycust> getAllCustomers() {
        List<staff_displaycust> customers = new ArrayList<>();
        String query = "SELECT * FROM " + tableName;

        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                staff_displaycust customer = new staff_displaycust(
                        rs.getString("CUSTOMERID"),
                        rs.getString("CUSTNAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PHONENUM"),
                        rs.getDate("DATEOFBIRTH"),
                        rs.getString("GENDER"),
                        rs.getTimestamp("REGISTRATIONDATE"));
                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public int getNewCustomersThisMonth() {
        int count = 0;

        // Get the first day of current month
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);

        java.sql.Timestamp firstDayOfMonth = new java.sql.Timestamp(cal.getTimeInMillis());

        String query = "SELECT COUNT(*) FROM " + tableName + " WHERE REGISTRATIONDATE >= ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setTimestamp(1, firstDayOfMonth);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public double getAverageOrderValue() {
        double avgValue = 0.0;

        String query = "SELECT AVG(PAYAMOUNT) FROM \"ADMIN\".\"ORDER\" WHERE ORDERSTATUSID IN (SELECT ORDERSTATUSID FROM \"ADMIN\".\"ORDERSTATUS\" WHERE STATUS = 'Shipped')"; 

        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                avgValue = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return avgValue;
    }
}
