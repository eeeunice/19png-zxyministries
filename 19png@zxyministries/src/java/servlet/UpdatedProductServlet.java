package servlet;

import domain.Products;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import da.ProductDAO;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/UpdatedProductServlet")
@MultipartConfig
public class UpdatedProductServlet extends HttpServlet {
    private static final String[] ALLOWED_EXTENSIONS = { "jpg", "jpeg", "png", "gif" };

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String productId = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String categoryId = request.getParameter("category_id");
        String subcategoryId = ""; // Set this if needed
        double price = Double.parseDouble(request.getParameter("price"));
        int stockQty = Integer.parseInt(request.getParameter("stock_qty"));
        String imageUrl = ""; // Initialize imageUrl

        // Handle image upload
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = getFileExtension(fileName);

            // Validate file type
            if (isAllowedFileExtension(fileExtension)) {
                // Construct the upload directory path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + categoryId + File.separator + subcategoryId;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs(); // Create directory if it doesn't exist

                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                imageUrl = "img/" + categoryId + "/" + subcategoryId + "/" + fileName; // Construct the image URL
            } else {
                // Set an error message for unsupported file type
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Invalid file type! Only JPG, JPEG, PNG, and GIF files are allowed.");
                response.sendRedirect("Product_Admin.jsp");
                return; // Stop the processing here
            }
        }

        // Create and update the product object
        Products product = new Products();
        product.setProductId(productId);
        product.setProductName(productName);
        product.setCategoryId(categoryId);
        product.setSubcategoryId(subcategoryId);
        product.setPrice(price);
        product.setStockQty(stockQty);
        product.setImageUrl(imageUrl); // Set the image URL

        // Update product in the database
        ProductDAO productDAO = new ProductDAO();
        boolean isUpdated = productDAO.updateProduct(product);

        // Set messages for the session
        HttpSession session = request.getSession();
        if (isUpdated) {
            session.setAttribute("successMessage", "Product updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to update the product. Please try again.");
        }

        // Redirect to the product admin page
        response.sendRedirect("Product_Admin.jsp");
    }

    // Method to get file extension
    private String getFileExtension(String fileName) {
        int lastIndex = fileName.lastIndexOf('.');
        return (lastIndex == -1) ? "" : fileName.substring(lastIndex + 1).toLowerCase();
    }

    // Method to check allowed file extensions
    private boolean isAllowedFileExtension(String fileExtension) {
        for (String ext : ALLOWED_EXTENSIONS) {
            if (ext.equals(fileExtension)) {
                return true;
            }
        }
        return false;
    }
}