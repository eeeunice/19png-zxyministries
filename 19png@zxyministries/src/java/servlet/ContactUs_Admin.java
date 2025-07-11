package servlet;

import da.ContactUs;
import domain.Contact;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "adminContact", urlPatterns = {"/adminContact"})
public class ContactUs_Admin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ContactUs db = new ContactUs();
        List<Contact> allContacts = db.getAllRecords();

        request.setAttribute("contacts", allContacts);
        request.getRequestDispatcher("contactus_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ContactUs db = new ContactUs();

        // Handle status update
        if ("update".equals(action)) {
            String contactusId = request.getParameter("id");
            Contact contact = db.getRecordByID(contactusId);
            if (contact != null) {
                contact.setStatus("Complete");

                // Detect logged-in user type
                HttpSession session = request.getSession();
                String managerId = (String) session.getAttribute("managerId");
                String staffId = (String) session.getAttribute("staffId");

                if (managerId != null) {
                    contact.setManagerId(managerId);
                    contact.setStaffId(null);
                } else if (staffId != null) {
                    contact.setStaffId(staffId);
                    contact.setManagerId(null);
                }

                db.updateRecord(contact);
                request.setAttribute("message", "Status updated to Complete!");
            }
        }

        // Handle deletion
        else if ("delete".equals(action)) {
            String contactusId = request.getParameter("id");
            db.deleteRecord(contactusId);
            request.setAttribute("message", "Record deleted successfully!");
        }

        // Handle search
        if (request.getParameter("searchId") != null && !request.getParameter("searchId").isEmpty()) {
            String searchId = request.getParameter("searchId");
            Contact contact = db.getRecordByID(searchId);
            if (contact != null) {
                request.setAttribute("contacts", Collections.singletonList(contact));
            } else {
                request.setAttribute("contacts", Collections.emptyList());
            }
        } else {
            request.setAttribute("contacts", db.getAllRecords());
        }

        request.getRequestDispatcher("contactus_admin.jsp").forward(request, response);
    }
}
