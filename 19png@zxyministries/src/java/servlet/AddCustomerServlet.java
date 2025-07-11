package servlet;

import domain.CustomerRegister;
import domain.Address;
import da.CustomerDB;
import da.AddressDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class AddCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form data for customer
            String custName = request.getParameter("custname");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String password = request.getParameter("password").trim();
            String confirmPassword = request.getParameter("confirmPassword").trim();
            String phoneNum = request.getParameter("phonenum");
            String dateOfBirth = request.getParameter("dateofbirth");
            String gender = request.getParameter("gender");

            // Get form data for address
            String street = request.getParameter("street");
            String postcode = request.getParameter("postcode");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String country = request.getParameter("country");

            // Validate phone number
            if (phoneNum.length() < 11 || phoneNum.length() > 12) {
                request.setAttribute("errorMessage", "Phone number must be 11 or 12 characters long!");
                request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
                return;
            }

            // Debug information - you can remove this after debugging
            System.out.println("Password: '" + password + "'");
            System.out.println("Password length: " + password.length());

            // Validate password length
            if (password.length() != 8) {
                request.setAttribute("errorMessage",
                        "Password must be exactly 8 characters long! (Current length: " + password.length() + ")");
                request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
                return;
            }

            // Password match check
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Password and Confirm Password do not match!");
                request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
                return;
            }

            // Date validation
            try {
                LocalDate today = LocalDate.now();
                LocalDate inputDate = LocalDate.parse(dateOfBirth);

                if (inputDate.isAfter(today)) {
                    request.setAttribute("errorMessage", "Date of Birth cannot be in the future!");
                    request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
                    return;
                }
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid date format!");
                request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
                return;
            }

            // Create database access objects
            CustomerDB customerDB = new CustomerDB();
            AddressDB addressDB = new AddressDB();

            // Generate next IDs
            String customerId = customerDB.getNextCustomerId();
            String addressId = addressDB.getNextAddressId();

            // Step 1: Create CustomerRegister object with NULL addressId
            CustomerRegister customer = new CustomerRegister(
                    customerId, custName, email, username, password, phoneNum, dateOfBirth, null, gender);

            // Step 2: Save customer to database with NULL addressId
            customerDB.addCustomer(customer);

            // Step 3: Create Address object and save to database
            Address address = new Address(
                    addressId, customerId, street, postcode, city, state, country);
            addressDB.addAddress(address);

            // Step 4: Update customer with addressId
            customerDB.updateCustomerAddress(customerId, addressId);

            // Close database connections
            customerDB.shutDown();
            addressDB.shutDown();

            // Set success message and redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Customer registered successfully!");
            response.sendRedirect("Manager_Customers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Print more detailed error information to console
            System.out.println("Database Error: " + e.getMessage());
            System.out.println("Error Type: " + e.getClass().getName());
            if (e.getCause() != null) {
                System.out.println("Caused by: " + e.getCause().getMessage());
            }

            request.setAttribute("errorMessage", "Customer creation failed due to an error: " + e.getMessage());
            request.getRequestDispatcher("AddCustomer.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If someone accesses the servlet directly, redirect to the form
        response.sendRedirect("AddCustomer.jsp");
    }
}
