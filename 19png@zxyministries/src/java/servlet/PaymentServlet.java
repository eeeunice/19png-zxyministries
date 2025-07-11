//<<<<<<< Updated upstream:ASSIGNMENT_AACS3094/src/java/PaymentServlet.java
//=======
//package servlet;
//
///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//>>>>>>> Stashed changes:ASSIGNMENT_AACS3094/src/java/servlet/PaymentServlet.java
//import java.io.IOException;
//import java.io.PrintWriter;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
///**
// *
// * @author eunic
// */
//@WebServlet(urlPatterns = {"/PaymentServlet"})
//public class PaymentServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String name = request.getParameter("name");
//        String card = request.getParameter("card");
//        String expiry = request.getParameter("expiry");
//        String cvv = request.getParameter("cvv");
//
//        // Create Payment object
//        Payment payment = new Payment(name, card, expiry, cvv);
//
//        // Process payment
//        boolean paymentSuccess = payment.processPayment();
//
//        response.setContentType("text/html");
//        PrintWriter out = response.getWriter();
//        out.println("<html><body style='font-family:Arial;'>");
//
//        if (paymentSuccess) {
//            out.println("<h2>Payment Processed Successfully!</h2>");
//            out.println("<p>Thank you, <b>" + name + "</b>. Your payment was successful.</p>");
//        } else {
//            out.println("<h3 style='color:red;'>Payment Failed. Please check your card details.</h3>");
//        }
//
//        out.println("</body></html>");
//    }
//
//    private static class Payment {
//
//        public Payment() {
//        }
//
//        private Payment(String name, String card, String expiry, String cvv) {
//            throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//        }
//
//        private boolean processPayment() {
//            throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//        }
//    }
//}
