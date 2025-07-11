package servlet;

import da.ProductDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteProductServlet", urlPatterns = {"/DeleteProductServlet"})
public class DeleteProductServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("product_id");
        HttpSession session = request.getSession();
        
        if (productId != null && !productId.trim().isEmpty()) {
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.deleteProduct(productId);
            
            if (success) {
                session.setAttribute("successMessage", "Product deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete product.");
            }
        } else {
            session.setAttribute("errorMessage", "Invalid product ID.");
        }
        
        response.sendRedirect("Product_Admin.jsp");
    }
}