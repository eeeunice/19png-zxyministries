 package domain;

public class OrderDetail {
    private String orderDetailsId;
    private int quantity;
    private double unitPrice;
    private double totalAmountProduct;
    private double discountAmountProduct;
    private String productId;
    private String orderId;
    private Products product; // Reference to product details
    
    public OrderDetail() {}
    
    // Getters
    public String getOrderDetailsId() { return orderDetailsId; }
    public int getQuantity() { return quantity; }
    public double getUnitPrice() { return unitPrice; }
    public double getTotalAmountProduct() { return totalAmountProduct; }
    public double getDiscountAmountProduct() { return discountAmountProduct; }
    public String getProductId() { return productId; }
    public String getOrderId() { return orderId; }
    public Products getProduct() { return product; }
    
    // Setters
    public void setOrderDetailsId(String orderDetailsId) { this.orderDetailsId = orderDetailsId; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public void setTotalAmountProduct(double totalAmountProduct) { this.totalAmountProduct = totalAmountProduct; }
    public void setDiscountAmountProduct(double discountAmountProduct) { this.discountAmountProduct = discountAmountProduct; }
    public void setProductId(String productId) { this.productId = productId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public void setProduct(Products product) { this.product = product; }
}