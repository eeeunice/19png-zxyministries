package servlet;

import domain.Products;
import domain.Categories;
import domain.Subcategories;
import domain.CartItem;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.CategoryDAO;
import da.ProductDAO;
import da.SubcategoryDAO;

@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private SubcategoryDAO subcategoryDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
        subcategoryDAO = new SubcategoryDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryId = request.getParameter("category");
        String subcategoryId = request.getParameter("subcategory");
        
        try {
            if (categoryId != null && subcategoryId != null) {
                handleCategoryAndSubcategory(request, categoryId, subcategoryId);
            } else if (categoryId != null) {
                handleCategory(request, categoryId);
            } else {
                handleAllProducts(request);
            }
            
            // Always get all categories for navigation
            List<Categories> allCategories = categoryDAO.getAllCategories();
            request.setAttribute("categories", allCategories);
            
            // Debug information
            System.out.println("CategoryID: " + categoryId);
            System.out.println("SubcategoryID: " + subcategoryId);
            System.out.println("Products count: " + 
                ((List<Products>)request.getAttribute("products")).size());
            
            request.getRequestDispatcher("/Product_Customer.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in ProductServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void handleCategoryAndSubcategory(HttpServletRequest request, String categoryId, String subcategoryId) {
        // Get products for specific category and subcategory
        List<Products> products = productDAO.getProductsByCategoryAndSubcategory(categoryId, subcategoryId);
        
        // Get subcategories for the selected category
        List<Subcategories> subcategories = subcategoryDAO.getSubcategoriesByCategory(categoryId);
        
        // Get category and subcategory names
        Categories category = categoryDAO.getCategoryById(categoryId);
        Subcategories subcategory = null;
        for (Subcategories sub : subcategories) {
            if (sub.getSubcategoryId().equals(subcategoryId)) {
                subcategory = sub;
                break;
            }
        }
        
        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedSubcategory", subcategory);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("subcategoryId", subcategoryId);
    }
    
    private void handleCategory(HttpServletRequest request, String categoryId) {
        // Get products for specific category
        List<Products> products = productDAO.getProductsByCategory(categoryId);
        
        // Get subcategories for the selected category
        List<Subcategories> subcategories = subcategoryDAO.getSubcategoriesByCategory(categoryId);
        
        // Get category information
        Categories category = categoryDAO.getCategoryById(categoryId);
        
        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("categoryId", categoryId);
    }
    
    private void handleAllProducts(HttpServletRequest request) {
        List<Products> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("addToCart".equals(action)) {
            handleAddToCart(request, response);
        } else if ("addToWishlist".equals(action)) {
            handleAddToWishlist(request, response);
        }
    }
    
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        String productId = request.getParameter("productId");
        
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }
        
        Products product = productDAO.getProductById(productId);
        if (product != null) {
            CartItem item = cart.get(productId);
            if (item == null) {
                item = new CartItem(product, 1);
                cart.put(productId, item);
            } else {
                item.setQuantity(item.getQuantity() + 1);
            }
            
            int cartCount = cart.values().stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();
            session.setAttribute("cartCount", cartCount);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Added to cart\", \"cartCount\": " + cartCount + "}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Product not found\"}");
        }
    }
    
    private void handleAddToWishlist(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String productId = request.getParameter("productId");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"message\": \"Added to wishlist\"}");
    }
    
    @Override
    public void destroy() {
        if (productDAO != null) {
            // Clean up resources
        }
    }
}