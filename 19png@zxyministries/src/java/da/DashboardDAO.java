package da;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import domain.DashboardMetrics;
import domain.Order;
import domain.LowStockProduct;
import domain.CustomerActivity;
import domain.TopCategory;
import domain.TopSellingProduct; // Add this import statement

public class DashboardDAO {
    private Connection conn;

    public DashboardDAO() {
        DatabaseLink db = new DatabaseLink();
        conn = db.getConnection();
    }

    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Replace the Map<String, Object> getDashboardMetrics() method with this:
    public DashboardMetrics getDashboardMetrics() {
        DashboardMetrics metrics = new DashboardMetrics();

        // Get total customers
        try {
            String customerQuery = "SELECT COUNT(*) AS total FROM ADMIN.CUSTOMER";
            PreparedStatement stmt = conn.prepareStatement(customerQuery);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                metrics.setTotalCustomers(rs.getInt("total"));
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.setTotalCustomers(0);
        }

        // Get total products
        try {
            String productQuery = "SELECT COUNT(*) AS total FROM ADMIN.PRODUCTS WHERE STATUS = 'active'";
            PreparedStatement stmt = conn.prepareStatement(productQuery);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                metrics.setTotalProducts(rs.getInt("total"));
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.setTotalProducts(0);
        }

        // Get total orders and revenue
        try {
            String orderQuery = "SELECT COUNT(*) AS total_orders, SUM(PAYAMOUNT) AS total_revenue " +
                    "FROM \"ADMIN\".\"ORDER\" o " +
                    "JOIN \"ADMIN\".\"ORDERSTATUS\" os ON o.ORDERSTATUSID = os.ORDERSTATUSID ";
            PreparedStatement stmt = conn.prepareStatement(orderQuery);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                metrics.setTotalOrders(rs.getInt("total_orders"));
                metrics.setTotalRevenue(rs.getDouble("total_revenue"));
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.setTotalOrders(0);
            metrics.setTotalRevenue(0.0);
        }

        // Get low stock count
        try {
            String lowStockQuery = "SELECT COUNT(*) AS total FROM ADMIN.PRODUCTS WHERE STOCK_QTY < 10 AND STATUS = 'active'";
            PreparedStatement stmt = conn.prepareStatement(lowStockQuery);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                metrics.setLowStockCount(rs.getInt("total"));
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            metrics.setLowStockCount(0);
        }

        return metrics;
    }

    public Map<String, Double> getMonthlySalesData() {
        Map<String, Double> monthlySales = new LinkedHashMap<>();

        try {
            String salesQuery = "SELECT MONTH(ORDERDATE) AS month, YEAR(ORDERDATE) AS year, SUM(PAYAMOUNT) AS total " +
                    "FROM ADMIN.ORDER " +
                    "GROUP BY YEAR(ORDERDATE), MONTH(ORDERDATE) " +
                    "ORDER BY YEAR(ORDERDATE), MONTH(ORDERDATE) LIMIT 12";
            PreparedStatement stmt = conn.prepareStatement(salesQuery);
            ResultSet rs = stmt.executeQuery();

            String[] monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov",
                    "Dec" };

            while (rs.next()) {
                int month = rs.getInt("month");
                int year = rs.getInt("year");
                double total = rs.getDouble("total");
                String key = monthNames[month - 1] + " " + year;
                monthlySales.put(key, total);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return monthlySales;
    }

    // Replace the List<Map<String, Object>> getRecentOrders(int limit) method with
    // this:
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();

        try {
            String orderQuery = "SELECT o.ORDERID, c.CUSTNAME, o.ORDERDATE, o.PAYAMOUNT, s.STATUS " +
                    "FROM \"ADMIN\".\"ORDER\" o " + // Note the escaped double quotes
                    "JOIN ADMIN.CUSTOMER c ON o.CUSTOMERID = c.CUSTOMERID " +
                    "JOIN ADMIN.ORDERSTATUS s ON o.ORDERSTATUSID = s.ORDERSTATUSID " +
                    "ORDER BY o.ORDERDATE DESC " +
                    "FETCH FIRST ? ROWS ONLY";
            PreparedStatement stmt = conn.prepareStatement(orderQuery);
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("ORDERID"));
                order.setCustomerName(rs.getString("CUSTNAME"));
                order.setOrderDate(rs.getTimestamp("ORDERDATE")); // Fix: directly use the Timestamp
                order.setTotalAmount(rs.getDouble("PAYAMOUNT")); // Fix: use setTotalAmount instead of setAmount
                order.setStatus(rs.getString("STATUS"));
                orders.add(order);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Replace the List<Map<String, Object>> getLowStockProducts() method with this:
    public List<LowStockProduct> getLowStockProducts() {
        List<LowStockProduct> products = new ArrayList<>();

        try {
            String productQuery = "SELECT p.PRODUCT_ID, p.PRODUCT_NAME, c.CATEGORY_NAME, p.STOCK_QTY " +
                    "FROM ADMIN.PRODUCTS p " +
                    "JOIN ADMIN.CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID " +
                    "WHERE p.STOCK_QTY < 10 AND p.STATUS = 'active' " +
                    "ORDER BY p.STOCK_QTY ASC";
            PreparedStatement stmt = conn.prepareStatement(productQuery);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LowStockProduct product = new LowStockProduct();
                product.setProductId(rs.getString("PRODUCT_ID"));
                product.setProductName(rs.getString("PRODUCT_NAME"));
                product.setCategory(rs.getString("CATEGORY_NAME"));
                product.setStockQty(rs.getInt("STOCK_QTY"));
                products.add(product);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    // Replace the List<Map<String, Object>> getCustomerActivityLog(int limit)
    // method with this:
    public List<CustomerActivity> getCustomerActivityLog(int limit) {
        List<CustomerActivity> activityLog = new ArrayList<>();

        try {
            // Fix: Escape the ORDER table name with double quotes
            String query = "SELECT c.CUSTNAME, o.ORDERDATE, o.PAYAMOUNT, s.STATUS " +
                    "FROM \"ADMIN\".\"ORDER\" o " + // Note the escaped double quotes
                    "JOIN ADMIN.CUSTOMER c ON o.CUSTOMERID = c.CUSTOMERID " +
                    "JOIN ADMIN.ORDERSTATUS s ON o.ORDERSTATUSID = s.ORDERSTATUSID " +
                    "ORDER BY o.ORDERDATE DESC " +
                    "FETCH FIRST ? ROWS ONLY";

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CustomerActivity activity = new CustomerActivity();
                activity.setCustomerName(rs.getString("CUSTNAME"));
                activity.setDate(rs.getTimestamp("ORDERDATE")); // Pass Timestamp directly
                activity.setAmount(rs.getDouble("PAYAMOUNT"));
                activity.setStatus(rs.getString("STATUS"));
                activityLog.add(activity);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activityLog;
    }

    // Add this method to your DashboardDAO class
    // Replace the Map<String, Integer> getTopCategories() method with this:
    public List<TopCategory> getTopCategories() {
        List<TopCategory> topCategories = new ArrayList<>();

        try {
            String categoryQuery = "SELECT c.CATEGORY_NAME, COUNT(p.PRODUCT_ID) as product_count " +
                    "FROM ADMIN.PRODUCTS p " +
                    "JOIN ADMIN.CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID " +
                    "WHERE p.STATUS = 'active' " +
                    "GROUP BY c.CATEGORY_NAME " +
                    "ORDER BY product_count DESC " +
                    "FETCH FIRST 5 ROWS ONLY";
            PreparedStatement stmt = conn.prepareStatement(categoryQuery);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TopCategory category = new TopCategory();
                category.setCategoryName(rs.getString("CATEGORY_NAME"));
                category.setProductCount(rs.getInt("product_count"));
                topCategories.add(category);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return topCategories;
    }

    // Add this method to get the total number of active categories
    public int getCategoryCount() {
        int count = 0;
        try {
            String query = "SELECT COUNT(*) AS total FROM ADMIN.CATEGORIES WHERE STATUS = 'active'";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            count = 0;
        }
        return count;
    }

    // Add this method to get the total stock quantity of all products
    public int getTotalStock() {
        int totalStock = 0;
        try {
            String query = "SELECT SUM(STOCK_QTY) AS total FROM ADMIN.PRODUCTS WHERE STATUS = 'active'";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                totalStock = rs.getInt("total");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            totalStock = 0;
        }
        return totalStock;
    }

    public List<TopSellingProduct> getTopSellingProducts(int limit) {
        List<TopSellingProduct> topProducts = new ArrayList<>();

        try {
            String query = "SELECT p.PRODUCT_ID, p.PRODUCT_NAME, c.CATEGORY_NAME, " +
                    "SUM(od.QUANTITY) AS units_sold, " +
                    "SUM(od.QUANTITY * p.PRICE) AS revenue " +
                    "FROM ADMIN.ORDERDETAILS od " +
                    "JOIN ADMIN.PRODUCTS p ON od.PRODUCT_ID = p.PRODUCT_ID " +
                    "JOIN ADMIN.CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID " +
                    "JOIN \"ADMIN\".\"ORDER\" o ON od.ORDERID = o.ORDERID " +
                    "JOIN ADMIN.ORDERSTATUS os ON o.ORDERSTATUSID = os.ORDERSTATUSID " +
                    "WHERE os.STATUS IN ('Shipped', 'Delivered', 'Completed') " +
                    "GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME, c.CATEGORY_NAME " +
                    "ORDER BY units_sold DESC " +
                    "FETCH FIRST ? ROWS ONLY";

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TopSellingProduct product = new TopSellingProduct();
                product.setProductId(rs.getString("PRODUCT_ID"));
                product.setProductName(rs.getString("PRODUCT_NAME"));
                product.setCategory(rs.getString("CATEGORY_NAME"));
                product.setUnitsSold(rs.getInt("units_sold"));
                product.setRevenue(rs.getDouble("revenue"));
                topProducts.add(product);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return topProducts;
    }

    // Method to get count of active promotions
    public int getActivePromotionsCount() {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) AS total FROM ADMIN.PROMOTION " +
                    "WHERE ENDDATE >= CURRENT_TIMESTAMP";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            count = 0;
        }
        return count;
    }

    // Method to get count of scheduled promotions
    public int getScheduledPromotionsCount() {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) AS total FROM ADMIN.PROMOTION " +
                    "WHERE STARTDATE > CURRENT_TIMESTAMP";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            count = 0;
        }
        return count;
    }

    // Method to get total discount amount
    public double getTotalDiscountAmount() {
        double total = 0.0;
        try {
            String sql = "SELECT SUM(DISCOUNTAMOUNT) AS total FROM ADMIN.DISCOUNT " +
                    "WHERE STATUSDISCOUNTS = 'active'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("total");
                if (rs.wasNull()) {
                    total = 0.0;
                }
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            total = 0.0;
        }
        return total;
    }
}