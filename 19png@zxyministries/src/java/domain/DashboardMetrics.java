package domain;

public class DashboardMetrics {
    private int totalCustomers;
    private int totalProducts;
    private int totalOrders;
    private double totalRevenue;
    private int lowStockCount;
    
    // Default constructor
    public DashboardMetrics() {
    }
    
    // Parameterized constructor
    public DashboardMetrics(int totalCustomers, int totalProducts, int totalOrders, 
                           double totalRevenue, int lowStockCount) {
        this.totalCustomers = totalCustomers;
        this.totalProducts = totalProducts;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.lowStockCount = lowStockCount;
    }
    
    // Getters and setters
    public int getTotalCustomers() {
        return totalCustomers;
    }
    
    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }
    
    public int getTotalProducts() {
        return totalProducts;
    }
    
    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }
    
    public int getTotalOrders() {
        return totalOrders;
    }
    
    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }
    
    public double getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public int getLowStockCount() {
        return lowStockCount;
    }
    
    public void setLowStockCount(int lowStockCount) {
        this.lowStockCount = lowStockCount;
    }
}