package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import domain.CartItem;
import domain.Products;
import da.CartDAO;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String action = request.getParameter("action");
        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        double price = Double.parseDouble(request.getParameter("price"));
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }
        
        if ("add".equals(action)) {
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getProduct().getProductId().equals(productId)) {
                    item.setQuantity(item.getQuantity() + 1);
                    found = true;
                    break;
                }
            }
            
            if (!found) {
                Products product = new Products();
                product.setProductId(productId);
                product.setProductName(productName);
                product.setPrice(price);
                
                CartItem newItem = new CartItem(product, 1);
                cart.add(newItem);
            }
            
            session.setAttribute("cart", cart);
            session.setAttribute("cartCount", getCartCount(cart));
            
            response.setContentType("text/plain");
            response.getWriter().write("Product added to cart successfully");
        }
    }
    
    private int getCartCount(List<CartItem> cart) {
        int count = 0;
        for (CartItem item : cart) {
            count += item.getQuantity();
        }
        return count;
    }
}