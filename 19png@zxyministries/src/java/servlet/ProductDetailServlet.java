package servlet;
import domain.Products;
import domain.CartItem;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.ProductDAO;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/ProductDetailServlet"})
public class ProductDetailServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("id");
        
        // 获取购物车数量
        HttpSession session = request.getSession();
        int cartCount = 0;
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cartCount = cart.size();
        }
        request.setAttribute("cartCount", cartCount);
        
        // 获取愿望清单数量
        int wishlistCount = 0;
        Map<String, Products> wishlist = (Map<String, Products>) session.getAttribute("wishlist");
        if (wishlist != null) {
            wishlistCount = wishlist.size();
        }
        request.setAttribute("wishlistCount", wishlistCount);
        
        if (productId != null && !productId.isEmpty()) {
            ProductDAO productDAO = new ProductDAO();
            Products product = productDAO.getProductById(productId);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("ProductDetail_Customer.jsp").forward(request, response);
            } else {
                response.sendRedirect("ProductServlet");
            }
        } else {
            response.sendRedirect("ProductServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
}