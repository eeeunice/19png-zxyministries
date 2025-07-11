package servlet;

import domain.CartItem;
import java.sql.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.CartDAO;

@WebServlet(name = "ViewCartServlet", urlPatterns = {"/ViewCartServlet"})
public class ViewCartServlet extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get cart items from session
        List<CartItem> cartItems = cartDAO.getAllItems(
            (Map<String, CartItem>) session.getAttribute("cart")
        );
        
        // Calculate totals
        double totalPrice = 0.0;
        double shippingCost = 10.0; // Fixed shipping cost
        
        for (CartItem item : cartItems) {
            totalPrice += item.getTotalPrice();
        }
        
        double salesTax = totalPrice * 0.06; // 6% sales tax
        double finalTotal = totalPrice + shippingCost + salesTax;
        
        // Set attributes for JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", String.format("%.2f", totalPrice));
        request.setAttribute("shippingCost", String.format("%.2f", shippingCost));
        request.setAttribute("salesTax", String.format("%.2f", salesTax));
        request.setAttribute("finalTotal", String.format("%.2f", finalTotal));
        
        session.setAttribute("cartItems", cartItems);
        session.setAttribute("totalPrice", String.format("RM %.2f", totalPrice));
        session.setAttribute("shippingCost", String.format("RM %.2f", shippingCost));
        session.setAttribute("salesTax", String.format("RM %.2f", salesTax));
        session.setAttribute("finalTotal", String.format("RM %.2f", finalTotal));

        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            // 如果是结账操作，转到支付页面
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
        } else {
            // 否则显示购物车页面
            request.getRequestDispatcher("/Cart_Customer.jsp").forward(request, response);
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