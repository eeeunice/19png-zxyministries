package domain;

public class LowStockProduct {
    private String productId;
    private String productName;
    private String category;
    private int stockQty;
    
    // Default constructor
    public LowStockProduct() {
    }
    
    // Parameterized constructor
    public LowStockProduct(String productId, String productName, String category, int stockQty) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
        this.stockQty = stockQty;
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
    
    public int getStockQty() {
        return stockQty;
    }
    
    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }
}