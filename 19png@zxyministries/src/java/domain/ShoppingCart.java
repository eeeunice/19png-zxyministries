package domain;

import java.util.ArrayList;
import java.util.List;


public class ShoppingCart {
    private List<CartItem> items;
    private double totalAmount;
    
    public ShoppingCart() {
        items = new ArrayList<>();
        totalAmount = 0.0;
    }
    
    public void addItem(CartItem item) {
        // 检查购物车中是否已存在该商品
        for (CartItem existingItem : items) {
            if (existingItem.getProduct().getProductId().equals(item.getProduct().getProductId())) {
                existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
                calculateTotal();
                return;
            }
        }
        // 如果商品不存在，添加新商品
        items.add(item);
        calculateTotal();
    }
    
    public void removeItem(String productId) {
        items.removeIf(item -> item.getProduct().getProductId().equals(productId));
        calculateTotal();
    }
    
    public void updateQuantity(String productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProduct().getProductId().equals(productId)) {
                item.setQuantity(quantity);
                calculateTotal();
                return;
            }
        }
    }
    
    public void clearCart() {
        items.clear();
        totalAmount = 0.0;
    }
    
    private void calculateTotal() {
        totalAmount = 0.0;
        for (CartItem item : items) {
            totalAmount += item.getTotalPrice(); // 使用getTotalPrice()替代getSubtotal()
        }
    }
    
    // Getters and Setters
    public List<CartItem> getItems() {
        return items;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public int getItemCount() {
        return items.size();
    }
    
    public CartItem getItem(String productId) {
        for (CartItem item : items) {
            if (item.getProduct().getProductId().equals(productId)) {
                return item;
            }
        }
        return null;
    }
}