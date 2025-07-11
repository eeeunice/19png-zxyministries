package servlet;

import domain.CartItem;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.CartDAO;

@WebServlet(name = "UpdateCartServlet", urlPatterns = {"/UpdateCartServlet"})
public class UpdateCartServlet extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<String, CartItem> cart = cartDAO.getCartFromSession(
            (Map<String, CartItem>) session.getAttribute("cart")
        );

        String[] productIds = request.getParameterValues("productId");
        if (productIds != null) {
            for (String productId : productIds) {
                String quantityParam = request.getParameter("quantity_" + productId);
                if (quantityParam != null && !quantityParam.isEmpty()) {
                    try {
                        int quantity = Integer.parseInt(quantityParam);
                        if (quantity > 0) {
                            cartDAO.updateQuantity(cart, productId, quantity);
                        } else {
                            cartDAO.removeItem(cart, productId);
                        }
                    } catch (NumberFormatException e) {
                        // Invalid quantity format, skip this item
                        continue;
                    }
                }
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/ViewCartServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}