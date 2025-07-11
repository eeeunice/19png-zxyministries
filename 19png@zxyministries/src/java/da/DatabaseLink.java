//please use this as a link get connetion db
//DatabaseLink db = new DatabaseLink();
//Connection conn = db.getConnection();

package da;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseLink {

    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private Connection conn;

    public DatabaseLink() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("Database connection established.");
        } catch (ClassNotFoundException e) {
            System.err.println("Derby JDBC driver not found:");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Failed to connect to the database:");
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return conn;
    }

    public void shutDown() {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed.");
            } catch (SQLException ex) {
                System.err.println("Error while closing the connection:");
                ex.printStackTrace();
            }
        }
    }
}
