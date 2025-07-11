package servlet;

import domain.Products;
import da.ProductDAO;
import da.WishlistDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import da.WishlistDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/WishlistServlet"})
public class WishlistServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String userId = (String) request.getSession().getAttribute("userId");
        WishlistDAO wishlistDAO = new WishlistDAO();

        if ("add".equals(action)) {
            String productId = request.getParameter("productId");
            boolean success = wishlistDAO.addProductToWishlist(userId, productId);
            response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } else if ("view".equals(action)) {
            List<Products> wishlistProducts = wishlistDAO.getWishlistByUserId(userId);
            request.setAttribute("wishlistProducts", wishlistProducts);
            request.getRequestDispatcher("Wishlist_Customer.jsp").forward(request, response);
        } else if ("remove".equals(action)) {
            String productId = request.getParameter("productId");
            boolean success = wishlistDAO.removeProductFromWishlist(userId, productId);
            response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}