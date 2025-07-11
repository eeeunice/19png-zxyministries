package da;

import domain.CartItem;
import domain.Products;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class CartDAO {
    // Get cart from session
    public Map<String, CartItem> getCartFromSession(Map<String, CartItem> sessionCart) {
        return sessionCart != null ? sessionCart : new ConcurrentHashMap<>();
    }

    // Add item to cart
    public void addItem(Map<String, CartItem> cart, Products product, int quantity) {
        if (product == null || quantity <= 0 || cart == null) {
            return;
        }

        String productId = product.getProductId();
        CartItem existingItem = cart.get(productId);

        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            cart.put(productId, new CartItem(product, quantity));
        }
    }

    // Remove item from cart
    public void removeItem(Map<String, CartItem> cart, String productId) {
        if (cart != null && productId != null) {
            cart.remove(productId);
        }
    }

    // Update item quantity
    public void updateQuantity(Map<String, CartItem> cart, String productId, int quantity) {
        if (cart == null || productId == null) {
            return;
        }

        if (quantity <= 0) {
            cart.remove(productId);
            return;
        }

        CartItem item = cart.get(productId);
        if (item != null) {
            item.setQuantity(quantity);
        }
    }

    // Get all items from cart
    public List<CartItem> getAllItems(Map<String, CartItem> cart) {
        return cart != null ? new ArrayList<>(cart.values()) : new ArrayList<>();
    }

    // Calculate total price
    public double getTotalPrice(Map<String, CartItem> cart) {
        double total = 0.0;
        if (cart != null) {
            for (CartItem item : cart.values()) {
                total += item.getTotalPrice();
            }
        }
        return total;
    }

    // Get cart item count
    public int getCartItemCount(Map<String, CartItem> cart) {
        int count = 0;
        if (cart != null) {
            for (CartItem item : cart.values()) {
                count += item.getQuantity();
            }
        }
        return count;
    }

    // Clear cart
    public void clearCart(Map<String, CartItem> cart) {
        if (cart != null) {
            cart.clear();
        }
    }

    public void addItem(Map<String, CartItem> cart, CartItem cartItem) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}