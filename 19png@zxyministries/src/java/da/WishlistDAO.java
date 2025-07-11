package da;

import domain.Products;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import da.DatabaseLink;

public class WishlistDAO {
    private Connection conn;

    public WishlistDAO() {
        DatabaseLink db = new DatabaseLink();
        this.conn = db.getConnection();
    }

    public boolean addProductToWishlist(String userId, String productId) {
        String queryStr = "INSERT INTO Wishlist (user_id, product_id) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
            stmt.setString(1, userId);
            stmt.setString(2, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error adding product to wishlist: " + ex.getMessage());
            return false;
        }
    }

    public List<Products> getWishlistByUserId(String userId) {
        List<Products> wishlistProducts = new ArrayList<>();
        String queryStr = "SELECT p.* FROM Wishlist w JOIN Products p ON w.product_id = p.product_id WHERE w.user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Products product = new Products();
                product.setProductId(rs.getString("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setPrice(rs.getDouble("price"));
                product.setImageUrl(rs.getString("image_url"));
                wishlistProducts.add(product);
            }
        } catch (SQLException ex) {
            System.out.println("Error retrieving wishlist: " + ex.getMessage());
        }
        return wishlistProducts;
    }

    public boolean removeProductFromWishlist(String userId, String productId) {
        String queryStr = "DELETE FROM Wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
            stmt.setString(1, userId);
            stmt.setString(2, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error removing product from wishlist: " + ex.getMessage());
            return false;
        }
    }
}