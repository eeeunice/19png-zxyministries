
//package servlet;
//
//import da.AddressDAO;
//import da.CustomerDAO;
//import domain.Address;
//import da.DatabaseLink;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//
//@WebServlet("/InsertAddressServlet")
//public class InsertAddressServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        try {
//            // Retrieve parameters
//            String customerId = request.getParameter("customerId");
//            String street = request.getParameter("street");
//            String city = request.getParameter("city");
//            String state = request.getParameter("state");
//            String zip = request.getParameter("zip");
//
//            // Debugging output
//            System.out.println("Received customerId: " + customerId);
//            System.out.println("Received street: " + street);
//            System.out.println("Received city: " + city);
//            System.out.println("Received state: " + state);
//            System.out.println("Received zip: " + zip);
//
//            // Check for null or empty values
//            if (customerId == null || street == null || city == null || state == null || zip == null ||
//                customerId.isEmpty() || street.isEmpty() || city.isEmpty() || state.isEmpty() || zip.isEmpty()) {
//                throw new IllegalArgumentException("All fields must be filled.");
//            }
//
//            // Proceed with database insert
//            AddressDAO addressDAO = new AddressDAO();
//            Address address = new Address(customerId, street, city, state, zip);
//            addressDAO.insertAddress(address);
//
//            // Redirect to user profile
//            response.sendRedirect("UserProfile_Customer.jsp?customerId=" + customerId);
//        } catch (Exception e) {
//            e.printStackTrace(); // Log the error
//            request.setAttribute("javax.servlet.error.exception", e); // Set the exception for the error page
//            request.getRequestDispatcher("/error500.jsp").forward(request, response); // Forward to error500.jsp
//        }
//    }
//}

package servlet;

import da.AddressDAO;
import da.CustomerDAO;
import domain.Address;
import da.DatabaseLink;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/InsertAddressServlet")
public class InsertAddressServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieve parameters
            String customerId = request.getParameter("customerId");
            String street = request.getParameter("street");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zip = request.getParameter("zip");

            // Debugging output
            System.out.println("Received customerId: " + customerId);
            System.out.println("Received street: " + street);
            System.out.println("Received city: " + city);
            System.out.println("Received state: " + state);
            System.out.println("Received zip: " + zip);

            // Check for null or empty values
            if (customerId == null || street == null || city == null || state == null || zip == null ||
                customerId.isEmpty() || street.isEmpty() || city.isEmpty() || state.isEmpty() || zip.isEmpty()) {
                throw new IllegalArgumentException("All fields must be filled.");
            }

            // Proceed with database insert
            AddressDAO addressDAO = new AddressDAO();
            // Generate an address ID (you might want to use a method from AddressDB instead)
            String addressId = "A" + System.currentTimeMillis();
            String country = "Malaysia"; // Default country or get from form
            
            // Create address object with all required parameters
            Address address = new Address(addressId, customerId, street, zip, city, state, country);
            addressDAO.insertAddress(address);

            // Redirect to user profile
            response.sendRedirect("UserProfile_Customer.jsp?customerId=" + customerId);
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            request.setAttribute("javax.servlet.error.exception", e); // Set the exception for the error page
            request.getRequestDispatcher("/error500.jsp").forward(request, response); // Forward to error500.jsp
        }
    }
}