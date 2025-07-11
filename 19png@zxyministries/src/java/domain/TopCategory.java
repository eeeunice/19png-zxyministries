package domain;

public class TopCategory {
    private String categoryName;
    private int productCount;
    
    public TopCategory() {
    }
    
    public TopCategory(String categoryName, int productCount) {
        this.categoryName = categoryName;
        this.productCount = productCount;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public int getProductCount() {
        return productCount;
    }
    
    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
}