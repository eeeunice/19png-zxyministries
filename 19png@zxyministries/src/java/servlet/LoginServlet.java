package servlet;

import da.CustomerDA;
import domain.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve username and password from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Create CustomerDA object to validate login
        CustomerDA customerDA = new CustomerDA();
        Customer customer = customerDA.validateLoginByUsername(username, password);

        // Check if customer exists
        if (customer != null) {
            // Set session attributes and forward to the homepage or dashboard
            HttpSession session = request.getSession();
            session.setAttribute("customerId", customer.getCustomerId());
            session.setAttribute("customerName", customer.getCustName());
            session.setAttribute("customerEmail", customer.getEmail());
            session.setAttribute("username", customer.getUsername());
            response.sendRedirect("homepage.jsp");  // Redirect to the dashboard page
        } else {
            // If login fails, set an error message and forward back to the login page
            request.setAttribute("errorMessage", "Invalid username or password!");
            request.getRequestDispatcher("Login_cust.jsp").forward(request, response);
        }

        // Close the database connection
        customerDA.shutDown();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Login_cust.jsp");
    }
}