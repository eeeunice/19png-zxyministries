package domain;

public class TopSellingProduct {
    private String productId;
    private String productName;
    private String category;
    private int unitsSold;
    private double revenue;

    // Default constructor
    public TopSellingProduct() {
    }

    // Parameterized constructor
    public TopSellingProduct(String productId, String productName, String category, int unitsSold, double revenue) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
        this.unitsSold = unitsSold;
        this.revenue = revenue;
    }

    // Getters and setters
    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getUnitsSold() {
        return unitsSold;
    }

    public void setUnitsSold(int unitsSold) {
        this.unitsSold = unitsSold;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}