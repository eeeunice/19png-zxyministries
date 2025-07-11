package domain;

import java.io.Serializable;

public class CartItem implements Serializable {
    private Products product; // 关联的产品
    private int quantity;

    public CartItem() {
    }

    public CartItem(Products product, int quantity) {
        this.product = product;
        setQuantity(quantity); // 使用 setter 确保数量有效
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
        this.quantity = quantity;
    }

    // 计算此条目的总价
    public double getTotalPrice() {
        return product != null ? product.getPrice() * quantity : 0.0;
    }

    // 重写 equals 和 hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartItem cartItem = (CartItem) o;
        return product != null ? product.getProductId().equals(cartItem.product.getProductId()) : cartItem.product == null;
    }

    @Override
    public int hashCode() {
        return product != null ? product.getProductId().hashCode() : 0;
    }
}