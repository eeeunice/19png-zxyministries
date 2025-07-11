package servlet;

import da.CustomerDB;
import da.AddressDB;
import domain.CustomerRegister;
import domain.Address;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class UpdateCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String customerId = request.getParameter("customerId");
            String addressId = request.getParameter("addressId");
            String custName = request.getParameter("custname");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String phoneNum = request.getParameter("phonenum");
            String dateOfBirthStr = request.getParameter("dateofbirth");
            String gender = request.getParameter("gender");
            
            // Address parameters
            String street = request.getParameter("street");
            String postcode = request.getParameter("postcode");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String country = request.getParameter("country");
            
            // Validate required fields
            if (customerId == null || customerId.trim().isEmpty() ||
                addressId == null || addressId.trim().isEmpty() ||
                custName == null || custName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                phoneNum == null || phoneNum.trim().isEmpty() ||
                dateOfBirthStr == null || dateOfBirthStr.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty() ||
                street == null || street.trim().isEmpty() ||
                postcode == null || postcode.trim().isEmpty() ||
                city == null || city.trim().isEmpty() ||
                state == null || state.trim().isEmpty() ||
                country == null || country.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All fields are required");
                request.getRequestDispatcher("CustomerEdit.jsp?id=" + customerId).forward(request, response);
                return;
            }
            
            // Validate phone number format (simple validation)
            if (!phoneNum.matches("\\d{10,12}")) {
                request.setAttribute("errorMessage", "Phone number must be 10-12 digits");
                request.getRequestDispatcher("CustomerEdit.jsp?id=" + customerId).forward(request, response);
                return;
            }
            
            // Validate date format
            LocalDate dateOfBirth;
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr);
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid date format");
                request.getRequestDispatcher("CustomerEdit.jsp?id=" + customerId).forward(request, response);
                return;
            }
            
            // Create database access objects
            CustomerDB customerDB = new CustomerDB();
            AddressDB addressDB = new AddressDB();
            
            // Get existing customer to preserve password
            CustomerRegister existingCustomer = customerDB.getCustomerById(customerId);
            if (existingCustomer == null) {
                request.setAttribute("errorMessage", "Customer not found");
                request.getRequestDispatcher("Manager_Customers.jsp").forward(request, response);
                return;
            }
            
            // Create updated customer object
            CustomerRegister updatedCustomer = new CustomerRegister(
                customerId,
                custName,
                email,
                username,
                existingCustomer.getPassword(), // Preserve existing password
                phoneNum,
                dateOfBirthStr,
                addressId,
                gender,
                existingCustomer.getRegistrationDate() // Preserve registration date
            );
            
            // Create updated address object
            Address updatedAddress = new Address(
                addressId,
                customerId,
                street,
                postcode,
                city,
                state,
                country
            );
            
            // Update customer and address in database
            customerDB.updateCustomer(updatedCustomer);
            addressDB.updateAddress(updatedAddress);
            
            // Close database connections
            customerDB.shutDown();
            addressDB.shutDown();
            
            // Set success message and redirect
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Customer updated successfully!");
            response.sendRedirect("Manager_Customers.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Print more detailed error information to console
            System.out.println("Database Error: " + e.getMessage());
            
            // Set error message and forward back to edit page
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            String customerId = request.getParameter("customerId");
            if (customerId != null && !customerId.isEmpty()) {
                request.getRequestDispatcher("CustomerEdit.jsp?id=" + customerId).forward(request, response);
            } else {
                request.getRequestDispatcher("Manager_Customers.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Print more detailed error information to console
            System.out.println("General Error: " + e.getMessage());
            
            // Set error message and forward back to edit page
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            String customerId = request.getParameter("customerId");
            if (customerId != null && !customerId.isEmpty()) {
                request.getRequestDispatcher("CustomerEdit.jsp?id=" + customerId).forward(request, response);
            } else {
                request.getRequestDispatcher("Manager_Customers.jsp").forward(request, response);
            }
        }
    }
}
