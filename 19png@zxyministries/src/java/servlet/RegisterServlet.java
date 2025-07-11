package servlet;

import domain.CustomerRegister;
import da.CustomerDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/RegisterServlets")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get form data
            String custName = request.getParameter("custname");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String phoneNum = request.getParameter("phonenum");
            String dateOfBirth = request.getParameter("dateofbirth");
            String addressid = request.getParameter("addressid");
            String gender = request.getParameter("gender");
            
            if (phoneNum.length() < 11 || phoneNum.length() > 12) {
    request.setAttribute("errorMessage", "Phone number must be 11 or 12 characters long!");
    request.getRequestDispatcher("register_cust.jsp").forward(request, response);
    return;
}
            
            if (password.length() != 8) {
    request.setAttribute("errorMessage", "Password must be exactly 8 characters long!");
    request.getRequestDispatcher("register_cust.jsp").forward(request, response);
    return;
}

            // Password match check
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Password and Confirm Password do not match!");
                request.getRequestDispatcher("register_cust.jsp").forward(request, response);
                return;
            }

            // Date validation
            try {
                LocalDate today = LocalDate.now();
                LocalDate inputDate = LocalDate.parse(dateOfBirth);

                if (inputDate.isAfter(today)) {
                    request.setAttribute("errorMessage", "Date of Birth cannot be in the future!");
                    request.getRequestDispatcher("register_cust.jsp").forward(request, response);
                    return;
                }
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid date format!");
                request.getRequestDispatcher("register_cust.jsp").forward(request, response);
                return;
            }

            CustomerDB customerDB = new CustomerDB();
            
            // Generate next customerId
            String customerId = customerDB.getNextCustomerId();

            // Create CustomerRegister object
            CustomerRegister customer = new CustomerRegister(
                customerId, custName, email, username, password, phoneNum, dateOfBirth, addressid, gender
            );

            // Save to database
            customerDB.addCustomer(customer);
            customerDB.shutDown();

            // Redirect after success
            response.sendRedirect("Login_cust.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed due to an error.");
            request.getRequestDispatcher("register_cust.jsp").forward(request, response);
        }
    }
}
