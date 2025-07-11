package servlet;

import domain.CartItem;
import domain.Products;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.CartDAO;
import da.ProductDAO;

public class AddToCartServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            productDAO = new ProductDAO(); // Initialize ProductDAO
            cartDAO = new CartDAO();       // Initialize CartDAO
            System.out.println("AddToCartServlet initialized successfully.");
        } catch (Exception e) {
            System.err.println("Error initializing DAOs: " + e.getMessage());
            throw new ServletException("DAO Initialization failed", e);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AddToCartServlet: processRequest started.");
        HttpSession session = request.getSession();
        Map<String, CartItem> cart = getCartFromSession(session);

        // 设置响应类型为JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        int quantity = parseQuantity(quantityStr);

        if (productId != null && !productId.isEmpty()) {
            try {
                Products product = productDAO.getProductById(productId);

                if (product != null) {
                    cartDAO.addItem(cart, product, quantity);
                    session.setAttribute("cart", cart);
                    
                    // 创建JSON响应
                    String jsonResponse = String.format(
                        "{\"success\": true, \"cartSize\": %d, \"message\": \"%s added to cart!\"}",
                        cart.size(),
                        product.getProductName().replace("\"", "\\\"")
                    );
                    
                    response.getWriter().write(jsonResponse);
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Product not found.\"}");
                }
            } catch (Exception e) {
                System.err.println("Error adding product to cart: " + e.getMessage());
                response.getWriter().write("{\"success\": false, \"message\": \"Error adding product to cart.\"}");
            }
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid product specified.\"}");
        }
    }

    private Map<String, CartItem> getCartFromSession(HttpSession session) {
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = cartDAO.getCartFromSession(null);
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private int parseQuantity(String quantityStr) {
        int quantity = 1; // Default quantity
        if (quantityStr != null && !quantityStr.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    quantity = 1; // Ensure positive quantity
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid quantity format: '" + quantityStr + "'. Defaulting to 1.");
            }
        }
        return quantity;
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

    @Override
    public String getServletInfo() {
        return "Servlet to add products to the shopping cart (session-based)";
    }
}